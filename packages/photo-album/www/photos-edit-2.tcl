ad_page_contract { 
    Bulk edit a set of images.
} { 
    album_id:naturalnum,notnull
    {page:integer,notnull "1"}
    d:array,integer,optional
    hide:array,optional
    caption:array
    photo_story:array
    photo_description:array
    photo_title:array
    sequence:array,integer
} -validate {
    valid_album -requires {album_id:integer} {
	if [string equal [pa_is_album_p $album_id] "f"] {
	    ad_complain "The specified album is not valid."
	}
    }
}
   
# These lines are to uncache the image in Netscape, Mozilla. 
# IE6 & Safari (mac) have a bug with the images cache
ns_set put [ns_conn outputheaders] "Expires" "-"
ns_set put [ns_conn outputheaders] "Last-Modified" "-"
ns_set put [ns_conn outputheaders] "Cache-Control" "no-cache"

set context_list [pa_context_bar_list -final "Edit page $page" $album_id]

set hides [list]
set shows [list]
foreach id [array names caption] { 
    # create a list of hide and show images.
    if {[info exists hide($id)]} { 
        lappend hides $id
    } else { 
        lappend shows $id
    }
    
    set acaption $caption($id)
    set aphoto_story $photo_story($id)
    set aphoto_description $photo_description($id)
    set aphoto_title $photo_title($id)
    set asequence $sequence($id)
    set aphoto_id $id
    set arevision_id [db_string get_rev_id "select coalesce(live_revision,latest_revision) from cr_items where item_id = :id"]
    set auser_id [ad_conn user_id]
    set apeeraddr [ad_conn peeraddr]
    

    db_dml update_photo_attributes { update cr_revisions set description = :aphoto_description, title = :aphoto_title where revision_id = :arevision_id  }

    db_dml update_photo { 
        update pa_photos
        set caption = :acaption, 
        story = :aphoto_story
        where pa_photo_id = (select latest_revision from cr_items where item_id = :id)
    }

    db_dml update_sequence {
        update cr_child_rels 
        set order_n = :asequence 
        where child_id = :id 
        and parent_id = :album_id 
    }

    if {[llength $hides]} { 
        db_dml update_hides "update cr_items set live_revision = null where item_id in ([join $hides ,])"
    } 
    if {[llength $shows]} { 
        db_dml update_shows "update cr_items set live_revision = latest_revision where item_id in ([join $shows ,])"
    }
        
}



foreach id [array names d] { 
    if { $d($id) > 0 } { 
        pa_rotate $id $d($id)
    }
}

pa_flush_photo_in_album_cache $album_id

ad_returnredirect "album?album_id=$album_id&page=$page&msg=1"


        
ad_script_abort

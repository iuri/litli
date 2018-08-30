# /packages/photo-album/www/album.tcl
ad_page_contract {
    Album display page.

    @author Tom Baginski (bags@arsdigita.com)
    @author Jeff Davis (davis@xarg.net)

    @creation-date 12/10/2000
    @cvs-id $Id: album.tcl,v 1.11 2018/05/09 15:33:33 hectorr Exp $
} {
    album_id:naturalnum,notnull
    {page:integer,notnull "1"}
    {msg:integer,notnull "0"}
} -validate {
    valid_album -requires {album_id:integer} {
	if [string equal [pa_is_album_p $album_id] "f"] {
	    ad_complain "[_ photo-album._The_1]"
	}
    }
} -properties {
    album_id:onevalue
    title:onevalue
    photographer:onevalue
    description:onevalue
    story:onevalue
    context:onevalue
    child_photo:multirow
    page_nav:onevalue
    admin_p:onevalue
    photo_p:onevalue
    write_p:onevalue
    move_p:onevalue
    delete_p:onevalue
    collections:onevalue
}

set user_id [ad_conn user_id]

# check for read permission on album
permission::require_permission -object_id $album_id -privilege read

# These lines are to uncache the image in Netscape, Mozilla. 
# IE6 & Safari (mac) have a bug with the images cache
ns_set put [ns_conn outputheaders] "Expires" "-"
ns_set put [ns_conn outputheaders] "Last-Modified" "-"
ns_set put [ns_conn outputheaders] "Pragma" "no-cache"
ns_set put [ns_conn outputheaders] "Cache-Control" "no-cache"


set context [pa_context_bar_list $album_id]

db_1row get_album_info {} 

# to move an album need write on album and write on parent folder
set move_p [expr {$write_p && $folder_write_p}]

# to delete an album, album must be empty, need delete on album, and write on parent folder
set has_children_p [expr {[pa_count_photos_in_album $album_id] > 0}]
set delete_p [expr {!($has_children_p) && $album_delete_p && $folder_write_p}]

# Did we get a msg id, if so display it at the top of the page
# TODO: JCD: We should remove it from vars so it does not propagate
array set msgtext { 
    1 {<strong>Your text changes have been saved and any image changes such as rotations 
        are being carried out in the background</strong>}
    2 {There was a problem with your update.  Please notify the webmaster}
}

if {$msg && [info exists msgtext($msg)]} { 
    set message $msgtext($msg)
} else { 
    set message {}
}

# change design so permission checks stop at the album level
# load testing showed serious performance problems when 
# each photo could have individual permissions
# 
# for now all photo in an album inherit the permission of the album that
# contains them.  Only need to check the read permission of the album, which was done at the top of the page. 

set photos_on_page [pa_all_photos_on_page $album_id $page]

if {$has_children_p && [llength $photos_on_page] > 0} {
    # query gets all child photos in album
    # I query the data without an orderby in the sql to cut the querry time
    # and then sort the returned data manually while constructing the multirow datasource.
    # This goes against the theory of let oracle do the hard work, but load testing and
    # query tuning showed that the order by doubled the query time while sorting a few rows in tcl was fast

    # wtem@olywa.net, 2001-09-24
    db_foreach get_child_photos {} {
	set val(photo_id) $photo_id
	set val(caption) $caption
	set val(thumb_path) $thumb_path
	set val(thumb_height) $thumb_height
	set val(thumb_width) $thumb_width
	set child($photo_id) [array get val]
    }
    
    # if the structure of the multirow datasource ever changes, this needs to be rewritten    
    set counter 0
    foreach id $photos_on_page {
        if {[info exists child($id)]} {
            incr counter 
            foreach {key value} $child($id) {
                set child_photo:${counter}($key) $value
            }
        }
    }
    set child_photo:rowcount $counter

    set pages [list]
    set total_pages [pa_count_pages_in_album $album_id]

    for {set i 1} {$i <= $total_pages} {incr i} {
        lappend pages $i
    }
    set page_nav [pa_pagination_bar $page $pages "[export_vars -base album {album_id}]&page="]

} else {
    # don't bother querying for children if we know they don't exist
    set child_photo:rowcount 0
    set page_nav ""
}

set collections [db_string collections {select count(*) from pa_collections where owner_id = :user_id}]

ad_return_template



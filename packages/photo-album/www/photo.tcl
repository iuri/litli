# /packages/photo-album/www/photo.tcl

ad_page_contract {

    Photo display page and allows user to move a photo from one album to another album in the same folder
    
    @author Tom Baginski (bags@arsdigita.com)
    @creation-date 12/10/2000
    @cvs-id $Id: photo.tcl,v 1.14 2018/01/20 22:49:15 gustafn Exp $
} {
    {latest_revision 0}
    {photo_id:naturalnum,notnull 0}
    {collection_id:naturalnum,optional {}}
    {show_html_p:boolean 0}
} -properties {
    context:onevalue
    title:onevalue
    description:onevalue
    story:onevalue
    caption:onevalue
    path:onevalue
    height:onevalue
    width:onevalue
    photo_nav_html:onevalue
    admin_p:onevalue
    write_p:onevalue
    album_id:onevalue
    page_num:onevalue
    show_base_link:onevalue
    clipboards:multirow
} -validate {
     valid_photo -requires {photo_id:integer} {
	 if { $photo_id eq "0" && $latest_revision ne "0" } {
	     set photo_id $latest_revision
	 } 
 	 if [string equal [pa_is_photo_p $photo_id] "f"] {
 	     ad_complain "The specified photo is not valid."
  	}
     }
}

permission::require_permission -object_id $photo_id -privilege "read"
set user_id [ad_conn user_id]
set context [pa_context_bar_list $photo_id]
set root_folder_id [pa_get_root_folder]
set package_id [ad_conn package_id]
set photo_base_url [site_node::get_url_from_object_id -object_id $package_id]

set system_url [ad_url]
set node_url [site_node::get_url -node_id [ad_conn node_id]]

# to move a photo need write on photo, and old parent album
# and pa_create_photo on new parent album (which is check in the is_valid block)

set old_album_id [db_string get_parent_album {}]

set write_p [permission::permission_p -object_id $photo_id \
                                      -party_id $user_id \
		 -privilege "write"]

set album_write_p [permission::permission_p -object_id $old_album_id \
                                      -party_id $user_id \
		 -privilege "write"]

# These lines are to uncache the image in Netscape, Mozilla. 
# IE6 & Safari (mac) have a bug with the images cache
ns_set put [ns_conn outputheaders] "Expires" "-"
ns_set put [ns_conn outputheaders] "Last-Modified" "-"
ns_set put [ns_conn outputheaders] "Pragma" "no-cache"
ns_set put [ns_conn outputheaders] "Cache-Control" "no-cache"


# this is handled with a parameter rather than a permission on the 
# individual photo so admin can turn access on and off for entire
# subsite at once.   A permission would allow greater flexability, but
# to shut down access to base photos an admin would need to search through
# database and revoke all such permissions.

set show_base_link [parameter::get -parameter AllowBasePhotoAccessP]

# query all the photo and permission info with a single trip to database
if {![db_0or1row get_photo_info { *SQL* }]} { 
    ad_return_complaint 1 "<li>[_ photo-album._This]
                             <ul><li>[_ photo-album._Photo_2]</li>
                                 <li>[_ photo-album._For]</li>
                                 <li>[_ photo-album._Your]</li>
                             </ul>"
    ad_script_abort
} else {
    set thumb_image_id ""
    set thumb_photo_id ""
    set thumb_height   ""
    set thumb_width    ""
    if {$show_html_p} {
        # if we did get a photo, and we need html source, get some info about the thumbnail
        db_0or1row get_thumbnail_info { *SQL* }
    }
    set path $image_id

    # to move a photo need write on photo and write on parent album
    set move_p [expr {$write_p && $album_write_p}]
    # build form to move the photo if move_p is 1
    if {$move_p} {
	
	template::form create move_photo
	
	template::element create move_photo photo_id -label "photo ID" \
	    -datatype integer -widget hidden
	
	
	set albums_list [db_list_of_lists get_albums { *SQL* }]
	
	template::element create move_photo new_album_id -label "[_ photo-album._Please]" \
	    -datatype integer -widget select \
	    -options $albums_list
	
	
	if { [template::form is_request move_photo] } {
	    template::element set_properties move_photo photo_id -value $photo_id
	    template::element create move_photo move_button -widget submit -label "[_ photo-album.Move]"	 
	}
	
	
	if { [template::form is_valid move_photo] } {
	    set new_album_id [template::element::get_value move_photo new_album_id]
	    permission::require_permission -object_id $new_album_id -privilege "pa_create_photo"
	    
	    if [string equal [pa_is_album_p $new_album_id] "f"] {
		# may add some sort of error message
		# but this case only happens due to url hacking
		# (or coding errors, which never happen)
		ad_script_abort
	    }
	    
	    db_transaction {
		
		# not using content_item move because is only accepts 
		# a folder_id as target not another content_item
		
		set rel_id [db_string photo_rel_id {}]
		
		db_dml photo_move {}
		
		db_dml photo_move2 {}
		
		db_dml context_update {}
		
	    } on_error {
		# most likely a duplicate name or a double click
		
		set filename [db_string filename {}]
		
		if {[db_string duplicate_check {}]} {
		    ad_return_complaint 1 "[_ photo-album._Either_4]"
		} else {
		    ad_return_complaint 1 "[_ photo-album._We_1]

	    <pre>$errmsg</pre>"
		}
		
		ad_script_abort
	    }
	    pa_flush_photo_in_album_cache $old_album_id
	    pa_flush_photo_in_album_cache $new_album_id
	    
	    
	    
	    #page used to redirect user to the page of new album containing moved photos
	    set page [pa_page_of_photo_in_album $photo_id $new_album_id]
	    
	    ad_returnredirect "album?album_id=$new_album_id&page=$page"
	    ad_script_abort
	    
	}
    }
    
    # to delete a photo need delete on photo and write on parent album
    set delete_p [expr {$photo_delete_p && $album_write_p}]
    
    # determine what album page the photo is on so page can present link back to thumbnail page
    set page_num [pa_page_of_photo_in_album $photo_id $album_id]
    
    set photo_nav_html [pa_pagination_bar $photo_id [pa_all_photos_in_album $album_id] "photo?photo_id=" photo]
    
    pa_clipboards_multirow -create_new -force_default $user_id clipboards
    
    #proc pa_clipboards_get -photo_id $photo_id -multirow clipped
    
    db_multirow clipped get_clips { *SQL* }
    
}

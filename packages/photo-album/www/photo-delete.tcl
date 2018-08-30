# photo-album/www/photo-delete.tcl

ad_page_contract {
    Confirms that user wants to delete a photo and deletes photo

    The delete removes all traces of a pa_photo and its associated images
    Schedules binaries to be deleted from filesystem
    Cannot be undone

    @author Tom Baginski (bags@arsdigita.com)
    @creation-date 12/21/2000
    @cvs-id $Id: photo-delete.tcl,v 1.9 2015/06/26 20:59:39 gustafn Exp $
} {
    photo_id:naturalnum,notnull
    {confirmed_p:boolean "f"}
} -validate {
    valid_photo -requires {photo_id:integer} {
	if [string equal [pa_is_photo_p $photo_id] "f"] {
	    ad_complain "[_ photo-album._The_2]"
	}
    }
} -properties {
    photo_id:onevalue
    title:onevalue
    path:onevalue
    height:onevalue
    width:onevalue
}

# to delete a photo need delete on photo and write on parent album 
set album_id [db_string get_parent_album "select parent_id from cr_items where item_id = :photo_id"]
permission::require_permission -object_id $photo_id -privilege delete
permission::require_permission -object_id $album_id -privilege write

if {$confirmed_p == "t"} {
    # they have confirmed that they want to delete the photo
    # delete pa_photo object which drops all associate images and schedules binaries to be deleted

    db_exec_plsql drop_image {
	begin
	pa_photo.del (:photo_id);
	end;
    }

    pa_flush_photo_in_album_cache $album_id
    
    ad_returnredirect "album?album_id=$album_id"
    ad_script_abort

} else {
    # they still need to confirm

    set context_list [pa_context_bar_list -final "[_ photo-album._Delete_1]" $photo_id]
    db_1row get_photo_info {select 
      cr.title,
      i.height as height,
      i.width as width,
      i.image_id as image_id
    from cr_items ci,
      cr_revisions cr,
      cr_items ci2,
      cr_child_rels ccr2,
      images pi
    where ci.live_revision = cr.revision_id
      and ci.item_id = ccr2.parent_id
      and ccr2.child_id = ci2.item_id
      and ccr2.relation_tag = 'thumb'
      and ci2.live_revision = i.image_id
      and ci.item_id = :photo_id
     }
     
     set path $image_id
     
     ad_return_template
 }

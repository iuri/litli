# /packages/photo-album/www/album-delete.tcl

ad_page_contract {
    page to confirm and delete album.
    album must be empty to delete

    @author Tom Baginski (bags@arsdigita.com)
    @creation-date 1/8/2000
    @cvs-id $Id: album-delete.tcl,v 1.9 2015/06/26 20:59:39 gustafn Exp $
} {
    album_id:naturalnum,notnull
    {confirmed_p:boolean "f"}
} -validate {
    valid_album -requires {album_id:integer} {
	if [string equal [pa_is_album_p $album_id] "f"] {
	    ad_complain "[_ photo-album._The_1]"
	}
    }

    no_children -requires {album_id:integer} {
	if { [pa_count_photos_in_album $album_id] > 0 } {
	    ad_complain "<#_We're sorry, but you cannot delete albums unless they are already empty.#>"
	}
    }
} -properties {
    album_id:onevalue
    title:onevalue
    context_bar:onevalue
}

# to delete a album must have delete permission on the album
# and write on parent folder
set parent_folder_id [db_string get_parent "select parent_id from cr_items where item_id = :album_id"]
permission::require_permission -object_id $album_id -privilege delete
permission::require_permission -object_id $parent_folder_id -privilege write

if {$confirmed_p == "t"} {
    # they have confirmed that they want to delete the album

    db_exec_plsql album_delete "
    begin
        pa_album.del(:album_id);
    end;"

    pa_flush_photo_in_album_cache $album_id

    ad_returnredirect "?folder_id=$parent_folder_id"
    ad_script_abort

} else {
    # they still need to confirm

    set title [db_string album_name "
    select content_item.get_title(:album_id,'t') from dual"]

    set context_list [pa_context_bar_list -final "Delete Album" $album_id]

}

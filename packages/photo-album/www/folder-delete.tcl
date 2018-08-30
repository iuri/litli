# /packages/photo-album/www/folder-delete.tcl
# based on file-storage folder-delete.tcl

ad_page_contract {
    page to confirm and delete folder.  
    Folder must be empty to delete

    @author Tom Baginski (bags@arsdigita.com)
    @creation-date 1/8/2000
    @cvs-id $Id: folder-delete.tcl,v 1.9 2015/06/26 20:59:39 gustafn Exp $
} {
    folder_id:naturalnum,notnull
    {confirmed_p:boolean "f"}
} -validate {
    valid_folder -requires {folder_id:integer} {
	if [string equal [pa_is_folder_p $folder_id] "f"] {
	    ad_complain "[_ photo-album._The_3]"
	}
    }

    not_root_folder -requires {folder_id} {
	if { $folder_id == [pa_get_root_folder] } {
	    ad_complain "[_ photo-album._You_1]"
	}
    }

    no_children -requires {not_root_folder} {
	if { [db_string child_count "
	select count(*) from cr_items where parent_id = :folder_id"] > 0 } {
	    ad_complain "<#_We're sorry, but you cannot delete folders unless they are already empty.#>"
	}
    }
} -properties {
    folder_id:onevalue
    title:onevalue
    context_bar:onevalue
}

# to delete a folder must have delete permission on the folder
# and write on parent folder
set parent_folder_id [db_string get_parent "select parent_id from cr_items where item_id = :folder_id"]
permission::require_permission -object_id $folder_id -privilege delete
permission::require_permission -object_id $parent_folder_id -privilege write

if {$confirmed_p == "t"} {
    # they have confirmed that they want to delete the folder

    db_exec_plsql folder_delete "
    begin
        content_folder.del(:folder_id);
    end;"

    ad_returnredirect "?folder_id=$parent_folder_id"
    ad_script_abort
} else {
    # they still need to confirm

    set title [db_string folder_name "
    select label from cr_folders where folder_id = :folder_id"]

    set context_list [pa_context_bar_list -final "[_ photo-album._Delete]" $folder_id]

}

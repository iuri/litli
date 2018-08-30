ad_page_contract {

    Delete an fs item.

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2007-06-03

} {
    object_id:multiple
}

set result "{\"success\":true}"
set fs_object_ids [split $object_id " "]
set viewing_user_id [ad_conn user_id]

db_transaction {

    foreach fs_object_id $fs_object_ids {

        if { ![fs::object_p -object_id $fs_object_id]} {
            set errmsg "Sorry, this object is not a File Storage Object."
            db_abort_transaction
            break;
        } else {
            # check if user has permission to delete the file/folder
            if { [permission::permission_p -party_id $viewing_user_id -object_id $fs_object_id -privilege "delete"] } {
                if { [fs::folder_p -object_id $fs_object_id] } {
                    fs::delete_folder -folder_id $fs_object_id -parent_id [fs::get_parent -item_id $fs_object_id]
                    # db_exec_plsql folder_delete "select file_storage__delete_folder(:fs_object_id,'t');"
                    # ns_log notice "HAM : delete folder *******"
                } else {
                    # fs::delete_file -item_id $fs_object_id
                    # ns_log notice "HAM : delete file *******"
                    # if { [content::symlink::is_symlink -item_id $fs_object_id] == "t" } {
                        fs::delete_file -item_id $fs_object_id
                        # db_exec_plsql file_delete "select file_storage__delete_file(:fs_object_id);"
                    # } else {
                        # HAM : we want admins to be able to request undeleting a file
                        # to prevent name clashes, we need to prepend the name with "deleted_"
                        # before we unpublish the item
                    #    db_dml "update_name" "update cr_items set name='deleted_$fs_object_id', deleted_p='t' where item_id = :fs_object_id"
                    #    item::unpublish -item_id $fs_object_id
                    #}
                }
            } else {
                set errmsg "You do not have permission to delete this file."
                db_abort_transaction
                break;
            }
        }

    }

} on_error {

    ns_return 500 "text/html" "{\"success\":false,\"error\":\"$errmsg\"}"
    ad_script_abort

}

ns_return 200 "text/html" $result
ad_script_abort


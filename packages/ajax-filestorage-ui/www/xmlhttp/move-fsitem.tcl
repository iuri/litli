ad_page_contract {

    Allow an fs_item where file or folder to be moved to
        a new target folder.

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2007-06-03

} {
    folder_target_id:integer,notnull
    file_ids:multiple
}

set user_id [ad_conn user_id]
set result "{\"success\":true}"

# check permissions on parent folder
# see if the user has write
set parent_id [fs::get_parent -item_id $folder_target_id]
if { ![permission::permission_p -no_cache \
        -party_id $user_id \
        -object_id $parent_id \
        -privilege "write"] } {

    ns_return 500 "text/html" "{\"success\":false,\"error\":\"You do not have permission to move.\"}"
    ad_script_abort
}

set file_id_list [split $file_ids " "]

db_transaction {

    foreach file_id $file_id_list {
        set parent_id $folder_target_id
        set address [ad_conn peeraddr]
        db_exec_plsql dbqd.file-storage.www.file-move-2.file_move {}
    }

} on_error {

    ns_return 500 "text/html" "{\"success\":false,\"error\":\"$errmsg\"}"
    ad_script_abort

}
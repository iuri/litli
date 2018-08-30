ad_page_contract {

    Accepts the object_id and a new name for the object.
        Returns 1 if update is successful, should return an error message if not.

    @author Hamilton Chua (ham@solutiongrove.com)
    @creation-date 2006-05-07
} {
    newname
    object_id
    type
    url:optional
}

set user_id [ad_conn user_id]
set result "{\"success\":true,\"newname\":\"$newname\",\"type\":\"$type\",\"url\":\"$url\"}"

# check permissions on parent folder
# see if the user has write
if { ![permission::permission_p -no_cache \
        -party_id $user_id \
        -object_id $object_id \
        -privilege "write"] } {

    ns_return 500 "text/html" "{\"success\":false,\"error\":\"You do not have permission to rename.\"}"
    ad_script_abort
}

# change the name of the give object_id
if { [exists_and_not_null newname] } {
    # determine if this is a folder or file
    db_transaction {
        if { $type == "folder" } {
            fs::rename_folder -folder_id $object_id -name $newname
        } elseif { $type == "url" } {
            content::extlink::edit -extlink_id $object_id -url $url -label $newname -description ""
        } else {
            set title $newname
            set file_id $object_id
            db_dml dbqd.file-storage.www.file-edit-2.edit_title {}
        }
    } on_error {
        ns_return 500 "text/html" "{\"success\":false,\"error\":\"$errmsg\"}"
        ad_script_abort
    }
} else {
    set result "{\"success\":false,\"error\":\"You must provide a new name\"}"
}
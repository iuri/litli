ad_page_contract {

    Add a URL to the file storage instance

} {
    folder_id:integer,notnull
    package_id:integer,notnull
    fstitle:notnull,trim
    fsdescription
    fsurl:notnull,trim
}

set user_id [ad_conn user_id]
set result "{\"success\":true}"

# Check for write permission on this folder
# ad_require_permission $folder_id write
if { ![permission::permission_p -object_id $folder_id -privilege "write"] } {

    # ns_return 500 "text/html" "You don't have permission to create a url on this folder."
    # ad_script_abort
    set result "{\"success\":false,\"error\":\"You don't have permission to create a url on this folder.\"}"

} else {

    set item_id [content_extlink::new -url $fsurl -label $fstitle -description $fsdescription -parent_id $folder_id]
    
    # Analogous as for files (see file-add-2) we know the user has write permission to this folder, 
    # but they may not have admin privileges.
    # They should always be able to admin their own url (item) by default, so they can delete it, control
    # who can read it, etc.
    
    if { [string is false [permission::permission_p -party_id $user_id -object_id $folder_id -privilege admin]] } {
        permission::grant -party_id $user_id -object_id $item_id -privilege admin
    }
    
    fs::do_notifications -folder_id $folder_id -filename $fsurl -item_id $item_id -action "new_url"

}

ad_page_contract {

    Script to receive a new revision of a file

} {
    file_id:integer
    title
    upload_file:trim
    upload_file.tmpfile:tmpfile
    package_id:integer,notnull
}

set user_id [ad_conn user_id]
set this_title $title
set filename [template::util::file::get_property filename $upload_file]
if {[string equal $this_title ""]} { set this_title $filename }
set result "{\"success\":true}"

# check permissions first
set folder_id [db_string get_folder_id "select parent_id as folder_id from cr_items where item_id=:file_id;" -default ""]

# check for write permission on the folder of this file
if { ![permission::permission_p -object_id $folder_id -privilege "write"] } {

    ns_return 500 "text/html" "You don't have permission to upload a new revision for this file."
    ad_script_abort

} else {


    fs::add_version \
        -name $filename \
        -tmp_filename ${upload_file.tmpfile} \
        -item_id $file_id \
        -creation_user $user_id \
        -creation_ip [ad_conn peeraddr] \
        -title $this_title \
        -description "" \
        -package_id $package_id

}

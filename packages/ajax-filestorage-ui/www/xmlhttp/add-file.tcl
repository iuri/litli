ad_page_contract {

    script to receive the new file and insert it into the database

} {
    folder_id:integer,notnull
    upload_file:notnull,trim
    upload_file.tmpfile:tmpfile
    package_id:integer,notnull
    {filetitle:trim ""}
    {filedescription ""}
    {unpack_p:boolean "f"}
} -validate {
    valid_folder -requires {folder_id:integer} {
        if ![fs_folder_p $folder_id] {
            ns_return 500 "text/html" "[_ file-storage.lt_The_specified_parent_]"
            ad_script_abort
        }
    }
    max_size -requires {upload_file} {
        set n_bytes [file size ${upload_file.tmpfile}]
        set max_bytes [parameter::get -package_id $package_id -parameter "MaximumFileSize"]
        # ns_log notice "HAM : $n_bytes : $max_bytes *"
        if { $n_bytes > $max_bytes } {
            ns_return 500 "text/html"  [_ file-storage.lt_Your_file_is_larger_t_1 [list max_number_of_bytes [util_commify_number $max_bytes]]]
            ad_script_abort
        }
    }
} 

# ns_log notice "HAM : UPLOADING FILE : $folder_id : $upload_file : $upload_file.tmpfile ***"

# Get the user
set user_id [auth::require_login]

# Get the ip
set creation_ip [ad_conn peeraddr]

set action ""

set result ""

# Check for write permission on this folder
# ad_require_permission $folder_id write
if { ![permission::permission_p -object_id $folder_id -privilege "write"] } {
    ns_return 500 "text/html" "You don't have permission to add files to this folder."
    ad_script_abort
}

# Get the storage type
set indb_p [parameter::get -package_id $package_id -parameter StoreFilesInDatabaseP]

set unpack_p [template::util::is_true $unpack_p]
set unzip_binary [string trim [parameter::get -package_id $package_id -parameter UnzipBinary]]

if { $unpack_p && ![empty_string_p $unzip_binary] && [file extension [template::util::file::get_property filename $upload_file]] eq ".zip"  } {
    
    set path [ns_tmpnam]
    file mkdir $path

    
    catch { exec $unzip_binary -jd $path ${upload_file.tmpfile} } errmsg

    # More flexible parameter design could be:
    # zip {unzip -jd {out_path} {in_file}} tar {tar xf {in_file} {out_path}} tgz {tar xzf {in_file} {out_path}} 

    set upload_files [list]
    set upload_tmpfiles [list]
    
    foreach file [glob -nocomplain "$path/*"] {
        lappend upload_files [file tail $file]
        lappend upload_tmpfiles $file
    }

} else {
    set upload_files [list $upload_file]
    set upload_tmpfiles [list ${upload_file.tmpfile}]
}

db_transaction {

    foreach upload_file $upload_files tmpfile $upload_tmpfiles {

        set mime_type [cr_filename_to_mime_type -create $upload_file]

        # Get the filename part of the upload file
        if { ![regexp {[^//\\]+$} $upload_file filename] } {
            # no match
            set filename $upload_file
        }
        
        # Get the title
        if { [empty_string_p $filetitle] || $unpack_p } {
            set filetitle $filename
        }

        set file_id [db_nextval "acs_object_id_seq"]
        fs::add_file \
            -name $filename \
            -item_id $file_id \
            -parent_id $folder_id \
            -tmp_filename $tmpfile\
            -creation_user $user_id \
            -creation_ip $creation_ip \
            -title $filetitle \
            -description $filedescription \
            -package_id $package_id \
            -mime_type $mime_type
    
        file delete $tmpfile

        # We know the user has write permission to this folder, but they may not have admin privileges.
        # They should always be able to admin their own file by default, so they can delete it, control
        # who can read it, etc.

        if { [string is false [permission::permission_p -party_id $user_id -object_id $folder_id -privilege admin]] } {
            permission::grant -party_id $user_id -object_id $file_id -privilege admin
        }
        
        # So we'll set the title from the filename in the next iteration
        set filetitle {}
    }


} on_error {

    ns_return 500 "text/html" $errmsg
    ad_script_abort

}

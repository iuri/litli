ad_page_contract {

    Display information about a homework file.   Based on the template in
    file-storage.  Unfortunately the semantics defined for user actions on
    homework files and our desire for consistent navigation make it impossible
    to just call the file-storage version directly.  

    I've also cleaned things up a bit ...

    @author Don Baccus (dhogaza@pacifier.com)

} {
    file_id:integer,notnull
    folder_id:integer,notnull
    {show_all_versions_p:boolean "f"}
} -validate {
    valid_file -requires {file_id} {
	if {![fs_file_p $file_id]} {
	    ad_complain "[_ dotlrn-homework.lt_specified_file]"
	}
    }
} -properties {
    title:onevalue
    name:onevalue
    owner:onevalue
    version:multirow
    show_all_versions_p:onevalue
    context_bar:onevalue
    file_path:onevalue
    version_add_url:onevalue
    move_url:onevalue
    correction_file_p:onevalue
    folder_id:onevalue
}

# check that they have read permission on this file.

permission::require_permission -object_id $file_id -privilege read

#set templating datasources

set user_id [ad_conn user_id]
set context_bar [list [_ dotlrn-homework.lt_one_assignment]]
set return_url "[ad_conn url]?[ad_conn query]"

db_1row file_info {}
set name [dotlrn_homework::decode_name $name]

set version_add_url [export_vars -base version-add {return_url folder_id file_id name}]
set move_url [export_vars -base file-move {file_id name}]

# DRB: I'm setting this up but think copy in the homework context is a bad
# idea so I'm not putting out a link to it.   As of July Sloan agrees.
set copy_url [export_vars -base file-copy {file_id name}]

if {$show_all_versions_p == "t"} {
    set show_versions [db_map show_all_versions]
} else {
    set show_versions [db_map show_live_version]
}

set file_storage_url [dotlrn_homework::get_file_storage_url]

set action_exists_p 0
db_multirow -extend {download_url} version version_info {}  {
    set version_name [dotlrn_homework::decode_name $version_name]

    set download_url [export_vars -base ${file_storage_url}/download/$version_name {version_id}]
    if { [string is true $delete_p] } {
        set action_exists_p 1
    }
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

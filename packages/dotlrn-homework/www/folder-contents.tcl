ad_page_contract {

    Display the contents of a single folder

    @author Don Baccus (dhogaza@pacifier.com)

} {
    folder_id:integer,notnull
    {min_level:integer ""}
    {max_level:integer ""}
} -validate {
    valid_folder -requires {folder_id:integer} {
	if {![fs_folder_p $folder_id]} {
	    ad_complain "[_ dotlrn-homework.lt_spec_parent]"
	}
    }
} -properties {
    list_of_folder_ids:onevalue
    min_level:onevalue
    max_level:onevalue
    return_url:onevalue
    package_id:onevalue
    folder_name:onevalue
    show_upload_url_p:onevalue
    admin_actions_p:onevalue
    admin_p:onevalue
}

# Make sure our visitor can read and write to the folder.
if { ![permission::permission_p -object_id $folder_id -privilege "read"] } {
    return -code error "visitor can't read folder"
}

set list_of_folder_ids [list $folder_id]
set package_id [ad_conn package_id]
set folder_name [fs_get_folder_name $folder_id]
set context_bar [list [_ dotlrn-homework.lt_one_folder]]

set community_id [dotlrn_community::get_community_id]
set admin_p [permission::permission_p -object_id $folder_id -privilege "admin"]

set show_upload_url_p [expr {!$admin_p && [permission::permission_p -object_id $folder_id -privilege "write"]}]
set admin_actions_p [string is true $admin_p]

ad_return_template 

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

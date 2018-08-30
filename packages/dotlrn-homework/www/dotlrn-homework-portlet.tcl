ad_page_contract {

    The display logic for the homework portlet. 

    @author Don Baccus (dhogaza@pacifier.com)

} -properties {
    list_of_file_ids:onevalue
    package_id:onevalue
    admin_p:onevalue
    show_upload_url_p:onevalue
    admin_actions_p:onevalue
}

array set config $cf
set list_of_folder_ids $config(folder_id)
set shaded_p $config(shaded_p)
set package_id $config(package_id)

set n_folders [llength $list_of_folder_ids]

if {$n_folders != 1} {
    # something went wrong, we can't have more than one folder here
    return -code error "can't have more than one folder"
}
set folder_id [lindex $list_of_folder_ids 0]

# Make sure our visitor can read the folder.
if { ![permission::permission_p -object_id $folder_id -privilege "read"] } {
    return -code error "visitor can't read folder"
}

# No need to do any more work if the shade's pulled up
if { $shaded_p } {
    ad_return_template
    return
}

set community_id [dotlrn_community::get_community_id]
set admin_p [permission::permission_p -object_id $folder_id -privilege "admin"]
set show_upload_url_p [expr {!$admin_p && [permission::permission_p -object_id $folder_id -privilege "write"]}]
set admin_actions_p 0

#AG: In Oracle this query is a seemingly nonsensical "select 1 from dual".
#The problem is, the db logic in PG is completely different and requires a query.
#To avoid propagating these differences up to Tcl we use a query in Oracle too.
set min_level [db_string select_default_min_level {}]

if { $admin_p } {
    # Admin view is limited to the folder name due to the fact that the admin can see every
    # student's files
    set max_level $min_level
} else {
    set max_level [expr {$min_level + 1}]
}

ad_return_template 

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

ad_page_contract {

    The display logic for the homework portlet. 

    @author Don Baccus (dhogaza@pacifier.com)

} -properties {
    shaded_p:onevalue
    toggle_url:onevalue
    subscribe_p:onevalue
    request_id:onevalue
    type_id:onevalue
    return_url:onevalue
}

set community_id [dotlrn_community::get_community_id]
dotlrn::require_user_admin_community -community_id $community_id

array set config $cf
set list_of_folder_ids $config(folder_id)
set shaded_p $config(shaded_p)
set package_id $config(package_id)

set n_folders [llength $list_of_folder_ids]

if {$n_folders != 1} {
    # something went wrong, we can't have more than one folder here
    return -code error "more than one folder"
}
set folder_id [lindex $list_of_folder_ids 0]

# No need to do any more work if the shade's pulled up
if { $shaded_p } {
    ad_return_template
    return
}

set return_url "[ad_conn url]?[ad_conn query]"

# Get the type_id for homework file notifications
set type_id [notification::type::get_type_id -short_name homework_upload]

# Check to see if our admin has already asked for alerts on this folder
set request_id [notification::request::get_request_id -object_id $folder_id -user_id [ad_conn user_id] -type_id $type_id]

set subscribe_p [expr {[string equal "" $request_id]}]

set url [site_node::get_url_from_object_id -object_id $package_id]
set toggle_url [export_vars -base ${url}toggle-homework-alert {folder_id subscribe_p request_id type_id return_url}]

ad_return_template 

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

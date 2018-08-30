set return_url [ad_return_url]

set swa_p [acs_user::site_wide_admin_p]

set dotlrn_admin_url [dotlrn::get_admin_url]

set class_instances_pretty_plural [parameter::get -localize -parameter class_instances_pretty_plural]
set clubs_pretty_plural [parameter::get -localize -parameter clubs_pretty_plural]
set departments_pretty_plural [parameter::get -localize -parameter departments_pretty_plural]
set subjects_pretty_plural [parameter::get -localize -parameter classes_pretty_plural]

set parameters_url [export_vars -base /shared/parameters { { package_id {[dotlrn::get_package_id]} } return_url }] 

set parameters_d_url [export_vars -base /shared/parameters { { package_id {[apm_package_id_from_key dotlrn-portlet]} } return_url }]

if { ![parameter::get -localize -package_id [dotlrn::get_package_id] -parameter dotlrn_toolbar_enabled_p -default 1] } {
    set dotlrn_toolbar_action [_ dotlrn.show_lrn_toolbar]
    set action "show"
} else {
    set dotlrn_toolbar_action [_ dotlrn.hide_lrn_toolbar]
    set action "hide"
}
set toolbar_actions_url [export_vars -base $dotlrn_admin_url/toolbar-actions {action return_url}]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

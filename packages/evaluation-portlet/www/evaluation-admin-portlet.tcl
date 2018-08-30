# /evaluation-portlet/www/evaluation-admin-portlet.tcl

ad_page_contract {
    The display logic for the evaluation admin portlet

    @author jopez@galileo.edu
    @creation-date May 2004
    @cvs_id $Id: evaluation-admin-portlet.tcl,v 1.4.10.1 2015/09/12 11:06:11 gustafn Exp $
} -properties {
    
}
set return_url [get_referrer]
array set config $cf
set user_id [ad_conn user_id]
set list_of_package_ids $config(package_id)

if {[llength $list_of_package_ids] > 1} {
    # We have a problem!
    return -code error "[_ evaluation-portlet.lt_There_should_be_only_]"
}        

set package_id [lindex $list_of_package_ids 0]        

set url [lindex [site_node::get_url_from_object_id -object_id $package_id] 0]

ad_return_template 

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

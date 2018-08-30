# /evaluation-portlet/www/evaluation-portlet.tcl

ad_page_contract {
    The display logic for the evaluation portlet

    @author jopez@galileo.edu
    @creation-date May 2004
    @cvs_id $Id: evaluation-evaluations-portlet.tcl,v 1.8.2.1 2015/09/12 11:06:11 gustafn Exp $
} {
    item_id:naturalnum,notnull,optional,multiple
    {evaluations_orderby ""}
    {page_num:naturalnum 0}
} -properties {

}

set user_id [ad_conn user_id]

array set config $cf	
set shaded_p $config(shaded_p)
set evaluation_id [evaluation_evaluations_portlet::get_package_id_from_key -package_key "evaluation"]
set simple_p  [parameter::get -parameter "SimpleVersion" -package_id $evaluation_id]
set list_of_package_ids $config(package_id)
set one_instance_p [ad_decode [llength $list_of_package_ids] 1 1 0]

set admin_p 0
array set package_admin_p [list]
foreach package_id $config(package_id) {
    set package_admin_p($package_id) [permission::permission_p -object_id $package_id -privilege admin]
    if { $package_admin_p($package_id) } {
        set admin_p 1
    }
}

db_multirow grades get_grades { *SQL* } {
}

if { $one_instance_p eq "1" && $admin_p eq "0" } {
    set total_class_grade [lc_numeric [db_string get_total_grade { *SQL* }]]
    set max_possible_grade [lc_numeric [db_string max_possible_grade { *SQL* }]]
}


set notification_chunk [notification::display::request_widget \
			    -type one_evaluation_notif \
			    -object_id $package_id \
			    -pretty_name "[_ evaluation-portlet.Evaluations_]" \
			    -url "[ad_conn url]?[ns_conn query]" \
			   ]


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

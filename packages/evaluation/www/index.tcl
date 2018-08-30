# /package/evaluation/www/index.tcl

ad_page_contract {
    
    Index page for evaluation package

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id: index.tcl,v 1.12.8.1 2015/09/12 11:06:02 gustafn Exp $
    
} {
    {assignments_orderby ""}
    {evaluations_orderby ""}
}

set page_title "[_ evaluation.Evaluation_Index_]"
set context {}
set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]

db_multirow grades get_grades { *SQL* } {
	
}

set total_class_grade [lc_numeric [db_string get_total_grade { *SQL* }]]
set max_possible_grade [lc_numeric [db_string max_possible_grade { *SQL* }]]

set notification_chunk [notification::display::request_widget \
							-type one_assignment_notif \
							-object_id $package_id \
							-pretty_name "[_ evaluation.Assignments_]" \
							-url [ad_conn url] \
						   ]

template::head::add_css -href "/resources/evaluation/evaluation.css"
ad_return_template
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

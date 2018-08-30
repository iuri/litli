# /packages/evaluation/www/evaluation-list.tcl

ad_page_contract {
	
	Display the evaluations for the group

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id: evaluation-list.tcl,v 1.3.8.2 2017/02/02 14:18:02 gustafn Exp $

} -query {
	{orderby:token,optional}
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set admin_p [permission::permission_p -party_id $user_id -object_id $package_id -privilege admin]
#set admin_p 0

if { $admin_p } {
    set actions "<a href=[export_vars -base "admin/grades/grades" { }]>[_ evaluation.Grade_Distribution_]</a>"
} else {
    set actions "[_ evaluation.Total_current_grade_] [lc_numeric %.2f [db_string total_grade { *SQL* }]] / [lc_numeric %.2f [db_string max_grade { *SQL* }]]"
}

set page_title "[_ evaluation.Evaluations_List_]"
set context "[_ evaluation.Evaluations_List_]"

db_multirow grades get_grades { *SQL* } {	
}

template::head::add_css -href "/resources/evaluation/evaluation.css"
ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

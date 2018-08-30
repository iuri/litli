# /packages/evaluation/www/task-list.tcl

ad_page_contract {

	Displays the tasks with different options depending on the user's role

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id: task-list.tcl,v 1.8.10.2 2017/02/02 14:18:02 gustafn Exp $

} -query {
	{orderby:token,optional}
}

set package_id [ad_conn package_id]
# [permission::permission_p -party_id $user_id -object_id $package_id -privilege read]

db_multirow grades get_grades { *SQL* } {
	
}

set page_title "[_ evaluation.Tasks_List_]"
set context "[_ evaluation.Tasks_List_]"


ad_return_template





# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

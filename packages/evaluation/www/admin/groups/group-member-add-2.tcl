# /packages/evaluation/www/admin/groups/group-member-add-2.tcl

ad_page_contract {
	Associates a student whith a group

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id: group-member-add-2.tcl,v 1.7.2.1 2015/09/12 11:06:06 gustafn Exp $
} {
	evaluation_group_id:naturalnum,notnull
	task_id:naturalnum,notnull
	student_id:naturalnum,notnull
}

set creation_user_id [ad_conn user_id]
set creation_ip [ad_conn peeraddr]
set package_id [ad_conn package_id]

db_exec_plsql associate_student { *SQL* }		

ad_returnredirect [export_vars -base one-task { task_id }]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

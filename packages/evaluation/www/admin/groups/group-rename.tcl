# /packages/evaluation/www/admin/groups/group-rename.tcl

ad_page_contract {
	Renames a group.

	@author jopez@galileo.edu
	@creation-date Mar 2004
	@cvs-id $Id: group-rename.tcl,v 1.8.2.1 2015/09/12 11:06:07 gustafn Exp $
} {
	evaluation_group_id:naturalnum,notnull
	task_id:naturalnum,notnull
	group_name:notnull
}

db_dml rename_group { *SQL* }		

ad_returnredirect [export_vars -base one-group { task_id evaluation_group_id }]


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

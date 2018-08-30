# /packages/evaluation/www/admin/evaluations/evaluaiton-delete.tcl

ad_page_contract {

	Deletes an evaluation after confirmation

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id: evaluation-delete.tcl,v 1.7.2.1 2015/09/12 11:06:03 gustafn Exp $

} {
	evaluation_id:naturalnum,notnull
	task_id:naturalnum,notnull
}

set page_title "[_ evaluation.Delete_Evaluation_]"

set context [list [list "[export_vars -base student-list { task_id }]" "[_ evaluation.Studen_List_]"] "[_ evaluation.Delete_Evaluation_]"]

db_1row get_evaluation_info { *SQL* }

set export_vars [export_vars -form { evaluation_id return_url task_id }]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

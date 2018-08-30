# /packages/evaluation/www/admin/evaluations/grades-sheet-explanation.tcl

ad_page_contract {

	@author jopez@galileo.edu
    @creation-date May 2004
    @cvs-id $Id: grades-sheet-explanation.tcl,v 1.7.2.1 2015/09/12 11:06:04 gustafn Exp $

} {
	task_id:naturalnum,notnull
}

set page_title "[_ evaluation.lt_Grades_Sheet_Explanat]"
set context [list [list "[export_vars -base student-list { task_id }]" "[_ evaluation.Studen_List_]"] "[_ evaluation.lt_Grades_Sheet_Explanat]"]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

# /packages/evaluation/www/admin/evaluations/evaluation-delete-2.tcl

ad_page_contract {
    Removes relations
    
    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id: evaluation-delete-2.tcl,v 1.11.2.1 2015/09/12 11:06:03 gustafn Exp $
} {
    evaluation_id:naturalnum,notnull
	task_id:naturalnum,notnull
	operation
} 

if {$operation eq [_ evaluation.lt_Yes_I_really_want_to_]} {
    db_transaction {
        evaluation::delete_student_eval -evaluation_id $evaluation_id
    } on_error {
		ad_return_error "[_ evaluation.lt_Error_deleting_the_ev]" "[_ evaluation.lt_We_got_the_following_]"
		ad_script_abort
    }
}

db_release_unused_handles

# redirect to the index page by default
ad_returnredirect [export_vars -base student-list { task_id }]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

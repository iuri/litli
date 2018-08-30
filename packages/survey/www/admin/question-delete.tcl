# /www/survsimp/admin/question-delete.tcl
ad_page_contract {

    Delete a question from a survey
    (or ask for confirmation if there are responses).

    @param  question_id  question we're about to delete

    @author jsc@arsdigita.com
    @date   March 13, 2000
    @cvs-id question-delete.tcl,v 1.5.2.4 2000/07/21 04:04:15 ron Exp
} {

    question_id:naturalnum,notnull
    {sort_order ""}
}

permission::require_permission -object_id $question_id -privilege survey_delete_question

db_1row section_id_from_question_id ""

get_survey_info -section_id $section_id
set survey_id $survey_info(survey_id)

set n_responses [db_string survey_number_responses {} ]

ad_form -name confirm_delete -export {sort_order} -form {
    question_id:key
    {question_text:text(inform) {label "[_ survey.Delete_1]"}}
    {from:text(inform) {label "[_ survey.From]"} {value $survey_info(name)}}
}

if {$n_responses > 0} {
    if {$n_responses >1} {
	set response_text "[_ survey.responses]"
    } else {
	set response_text "[_ survey.response]"
    }
    ad_form -extend -name confirm_delete -form {
	{warning:text(inform) {value "[_ survey.lt_This_question_has_n]"}
	{label "[_ survey.Warning]"}}
    }
 
}

ad_form -extend -name confirm_delete -form {
   {confirmation:text(radio) {label " "}
	{options
	    {{"[_ survey.Continue_with_Delete]" t }
	     {"[_ survey.lt_Cancel_and_return_to_]" f }}	}
	     {value f}}
    } -select_query_name {get_question_details} -on_submit {
	if {$confirmation} {
	    db_transaction {

		db_dml survey_question_responses_delete {}
		db_dml survey_question_choices_delete {}
		db_exec_plsql survey_delete_question {}

		if {$sort_order ne ""} {
		    db_dml survey_renumber_questions {}
		}
	    } on_error {
    
		ad_return_error [_ survey.Database_Error] "[_ survey.lt_There_was_an_error_wh]
		<pre>
		$errmsg
		</pre>
		<p> [_ survey.lt_Please_go_back_using_]
		"
                ad_script_abort
	    }

	    db_release_unused_handles
	    set sort_order [expr {$sort_order -1}]
	}
        ad_returnredirect "[export_vars -base one {survey_id}]&#$sort_order"
        ad_script_abort
    }

set context [_ survey.Delete_Question]
ad_return_template


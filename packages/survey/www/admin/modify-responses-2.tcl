ad_page_contract {
    Modify question responses

    @param section_id               integer denoting which survey we're adding question to
    @param question_id             id of new question
    @param responses               list of possible responses
    @param scores                  list of variable scores

    @author Nick Strugnell (nstrug@arsdigita.com)
    @date   September 15, 2000
    @cvs-id $Id: modify-responses-2.tcl,v 1.4 2015/06/27 20:46:15 gustafn Exp $
} {
    section_id:naturalnum,notnull
    question_id:naturalnum,notnull
    {responses:multiple ""}
    {scores:multiple,array,integer ""}
    {variable_id_list ""}
    {choice_id_list ""}
}

permission::require_permission -object_id $section_id -privilege survey_modify_question

db_transaction {
    
    set i 0
    foreach choice_id $choice_id_list {
	set trimmed_response [string trim [lindex $responses $i]]
	db_dml update_survey_question_choice "update survey_question_choices
          set label = :trimmed_response
          where choice_id = :choice_id"

	foreach variable_id $variable_id_list {
	    set score_list $scores($variable_id)
	    set score [lindex $score_list $i]
	    db_dml update_survey_scores "update survey_choice_scores
                                           set score = :score
                                           where choice_id = :choice_id
                                           and variable_id = :variable_id"
	}

	incr i
    }
}

db_release_unused_handles

get_survey_info -section_id $section_id
set survey_id $survey_info(survey_id)
ad_returnredirect [export_vars -base one {survey_id}]

	

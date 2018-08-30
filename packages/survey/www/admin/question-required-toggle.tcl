# /www/survsimp/admin/question-required-toggle.tcl
ad_page_contract {

    Toggle required field for a question.

    @param required_p    flag indicating original status of this question
    @param section_id     survey this question belongs to
    @param question_id   question we're dealing with

    @author  jsc@arsdigita.com
    @date    February 9, 2000
    @cvs-id  question-required-toggle.tcl,v 1.5.2.5 2000/07/23 16:53:34 seb Exp

} {

    required_p:boolean,notnull
    section_id:naturalnum,notnull
    question_id:naturalnum,notnull

}

permission::require_permission -object_id $section_id -privilege survey_modify_question
   
db_dml survey_question_required_toggle "update survey_questions set required_p = util.logical_negation(required_p)
where section_id = :section_id
and question_id = :question_id"

db_release_unused_handles
get_survey_info -section_id $section_id
set survey_id $survey_info(survey_id)
ad_returnredirect [export_vars -base one {survey_id}]


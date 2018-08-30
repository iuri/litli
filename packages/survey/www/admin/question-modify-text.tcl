ad_page_contract {

    Allow the user to modify the text of a question.

    @param   section_id   survey this question belongs to
    @param   question_id question which text we're changing

    @author  cmceniry@arsdigita.com
    @author  nstrug@arsdigita.com
    @date    Jun 16, 2000
    @cvs-id  $Id: question-modify-text.tcl,v 1.7 2015/06/27 20:46:15 gustafn Exp $
} {

    question_id:naturalnum,notnull
    section_id:naturalnum,notnull

}

permission::require_permission -object_id $section_id -privilege survey_modify_question

get_survey_info -section_id $section_id
set survey_name $survey_info(name)
set survey_id $survey_info(survey_id)

ad_form -name modify_question -form {
    question_id:key
    {question_text:text(textarea) {label [_ survey.Question]} {html {rows 5 cols 70}}}
    {section_id:text(hidden) {value $section_id}}
    {survey_id:text(hidden) {value $survey_id}}
} -select_query_name {survey_question_text_from_id} -edit_data {
    
    db_dml survey_question_text_update "update survey_questions set question_text=:question_text where question_id=:question_id" 
    ad_returnredirect "one?survey_id=$survey_id"
    ad_script_abort

}

set context [list [list [export_vars -base one {survey_id}] $survey_info(name)] "[_ survey.lt_Modify_a_Questions_Te]"]

ad_return_template

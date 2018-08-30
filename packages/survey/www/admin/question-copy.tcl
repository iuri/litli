ad_page_contract {
    Copy a question to the same survey
    @author  dave@thedesignexperience.org
    @date    July 29, 2002
    @cvs-id $Id:
} {
    question_id:naturalnum,notnull
    {sort_order 0}
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -object_id $package_id -privilege survey_create_question
set section_id [db_string get_section_id_from_question {}]
get_survey_info -section_id $section_id
set survey_id $survey_info(survey_id)
set new_question_id [survey_question_copy -question_id $question_id]
incr sort_order
ad_returnredirect "[export_vars -base one survey_id]&#$sort_order"


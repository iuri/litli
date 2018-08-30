# /www/survsimp/admin/view-text-responses.tcl
ad_page_contract {

  View all the typed-in text responses for one question.

  @param  question_id  which question we want to list answers to
 
  @author jsc@arsdigita.com
  @date   February 11, 2000
  @cvs-id view-text-responses.tcl,v 1.5.2.3 2000/07/21 04:04:25 ron Exp

} {

  question_id:naturalnum,notnull

}

db_1row one_question ""

get_survey_info -section_id $section_id
set survey_name $survey_info(name)
set survey_id $survey_info(survey_id)

permission::require_permission -object_id $survey_id -privilege survey_admin_survey

set abstract_data_type [db_string abstract_data_type "select abstract_data_type
from survey_questions q
where question_id = :question_id"]

if { $abstract_data_type eq "text" } {
    set column_name "clob_answer"
} elseif { $abstract_data_type eq "shorttext" } {
    set column_name "varchar_answer"
} elseif { $abstract_data_type eq "date" } {
    set column_name "date_answer"
}

set results ""


db_multirow responses all_responses_to_question {}

set context [list [list [export_vars -base one {survey_id}] $survey_info(name)] "[_ survey.lt_Responses_to_Question]"]

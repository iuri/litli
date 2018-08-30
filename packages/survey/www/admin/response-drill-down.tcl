ad_page_contract {

  Display the list of users who gave a particular answer to a
  particular question.

  @param   question_id  question for which we're drilling down responses
  @param   choice_id    we're seeking respondents who selected this choice
                        as an answer to question

  @author  philg@mit.edu
  @author  jsc@arsdigita.com
  @author  nstrug@arsdigita.com
  @date    February 16, 2000
  @cvs-id  $Id: response-drill-down.tcl,v 1.6 2015/06/27 20:46:15 gustafn Exp $

} {

  question_id:naturalnum,notnull
  choice_id:naturalnum,notnull
  
}

permission::require_permission -object_id $question_id -privilege survey_admin_survey

# get the prompt text for the question and the ID for survey of 
# which it is part

set question_exists_p [db_0or1row get_question_text ""]
get_survey_info -section_id $section_id
set survey_name $survey_info(name)
set survey_id $survey_info(survey_id)

if { !$question_exists_p }  {
    db_release_unused_handles
    ad_return_error "[_ survey.lt_Survey_Question_Not_F]" "[_ survey.lt_Could_not_find_a_surv] #$question_id"
    return
}

set response_exists_p [db_0or1row get_response_text ""]

if { !$response_exists_p } {
    db_release_unused_handles
    ad_return_error "[_ survey.Response_Not_Found]" "[_ survey.lt_Could_not_find_the_re] #$choice_id"
    return
}

# Get information of users who responded in particular manner to
# choice question.

db_multirow user_responses all_users_for_response {}

set context [list \
     [list [export_vars -base one {survey_id}] $survey_info(name)] \
     [list [export_vars -base responses {survey_id}] "[_ survey.Responses]"] \
     "[_ survey.One_Response]"]

ad_return_template

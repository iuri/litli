ad_page_contract {

    Display the user's previous responses.

    @param   section_id  id of survey for which responses are displayed
    @param   return_url  if provided, generate a 'return' link to that URL
    @param   group_id    if specified, display all the responses for all
                         users of that group

    @author  philg@mit.edu
    @author  nstrug@arsdigita.com
    @date    28th September 2000
    @cvs-id  $Id: one-respondent.tcl,v 1.9.2.1 2016/05/21 11:04:16 gustafn Exp $
} {

    survey_id:naturalnum,notnull
    {return_url:localurl ""}

} -validate {
        survey_exists -requires {survey_id} {
	    if {![db_0or1row survey_exists {}]} {
		ad_complain "[_ survey.lt_Survey_section_id_does]"
	    }
	}
} -properties {
    survey_name:onerow
    description:onerow
    responses:multirow
}

# If group_id is specified, we return all the responses for that group by any user

set user_id [ad_conn user_id]

get_survey_info -survey_id $survey_id

set survey_name $survey_info(name)
set description $survey_info(description)
set description_html_p $survey_info(description_html_p)
set editable_p $survey_info(editable_p)

set context [_ survey.Responses]

if {$description_html_p != "t" } {
    set description [ad_text_to_html $description]
}

db_multirow -extend {answer_summary pretty_submission_date respond_url} responses responses_select {} {
    set answer_summary [survey_answer_summary_display $response_id 1] 
    set pretty_submission_date [lc_time_fmt $pretty_submission_date_ansi %x]
    set respond_url [export_vars -base respond {survey_id response_id}]
}

ad_return_template

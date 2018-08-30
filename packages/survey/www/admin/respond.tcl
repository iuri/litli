ad_page_contract {

    Display the questionnaire prefilled with responses for one survey submission.  
    Allows administrator to edit the answers to a survey.
    Adapted from www/respond.tcl

    @param  user_id    user whose response we're viewing
    @param  survey_id  survey we're viewing
    @param  response_id  response we are editing
    @param  return_url   url to redirect to after submission 
    @author teadams@alum.mit
    @date   March 27, 2003
    @cvs-id $Id: respond.tcl,v 1.5.2.2 2017/06/30 17:55:10 gustafn Exp $
} {

    user_id:naturalnum,notnull
    survey_id:naturalnum,notnull
    {section_id:naturalnum,notnull 0}
    {response_id:naturalnum,notnull 0} 
    return_url:localurl,optional

} -validate {
    survey_exists -requires {survey_id} {
	if {![db_0or1row survey_exists {}]} {
	    ad_complain "Survey $survey_id does not exist"
	}
    }
} -properties {

    name:onerow
    section_id:onerow
    button_label:onerow
    questions:onerow
    description:onerow
    return_url:onerow
}


# Added by request from a professor at Sloan.

permission::require_permission -object_id $survey_id -privilege survey_admin_survey

get_survey_info -survey_id $survey_id
set survey_name $survey_info(name)
set description $survey_info(description)
set type $survey_info(type)
set display_type $survey_info(display_type)

# survey_name and description are now set 

set user_exists_p [db_0or1row user_name_from_id "select first_names, last_name from persons where person_id = :user_id" ]

if { !$user_exists_p } {
    ad_return_error "Not Found" "Could not find user #$user_id"
    return
}

# XXX TODO - person name
set context $survey_name

# XXX TODO - check how the correct response get's filled
#  with the correct response esp if there is more than
#  one response to a survey.

# Get the last response to the survey
set button_label "Modify previous response"
db_1row get_initial_response ""

# build a list containing the HTML (generated with survey_question_display) for each question
set rownum 0
# for double-click protection
set new_response_id [db_nextval acs_object_id_seq]    
set questions [list]

db_foreach survey_sections {} {

    db_foreach question_ids_select {} {
	lappend questions [survey_question_display $question_id $response_id]
    }

    # survey will return to survey_url if it exists 
    # rather than executing the survey associated with the logic
    # after the survey is completed
    
    if {![info exists return_url]} {
	set return_url {}
    }
}

set edited_response_id $response_id
set form_vars [export_vars -form {section_id survey_id new_response_id user_id edited_response_id}]  

ad_return_template


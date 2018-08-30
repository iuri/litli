ad_page_contract {

    Display a questionnaire for one survey.

    @param  section_id   id of displayed survey

    @author philg@mit.edu
    @author nstrug@arsdigita.com
    @date   28th September 2000
    @cvs-id $Id: respond.tcl,v 1.10.2.1 2016/05/21 11:04:16 gustafn Exp $

} {
    
    survey_id:naturalnum,notnull
    {section_id:naturalnum,notnull 0}
    {response_id:naturalnum,notnull 0}
    return_url:localurl,optional

} -validate {
    survey_exists -requires {survey_id} {
	if {![db_0or1row survey_exists {}]} {
	    ad_complain "[_ survey.lt_Survey_survey_id_do_no]"
	}
    set user_id [auth::require_login]
    set number_of_responses [db_string count_responses {}]
    get_survey_info -survey_id $survey_id
    set single_section_p $survey_info(single_section_p)
        if {$section_id==0 && $single_section_p=="t"} {
            set section_id $survey_info(section_id)
        }
    set name $survey_info(name)
    set description $survey_info(description)
    set description_html_p $survey_info(description_html_p)
    set single_response_p $survey_info(single_response_p)
    set editable_p $survey_info(editable_p)
    set display_type $survey_info(display_type)

   if {$description_html_p != "t"} {
       set description [ad_text_to_html $description]
   } 

   if {($single_response_p=="t" && $editable_p=="f" && $number_of_responses>0) || ($single_response_p=="t" && $editable_p=="t" && $number_of_responses>0 && $response_id==0)} {
	    ad_complain "[_ survey.lt_You_have_already_comp]"
	} elseif {$response_id>0 && $editable_p=="f"} {
	    ad_complain "[_ survey.lt_This_survey_is_not_ed]"
	}
    }
} -properties {

    name:onerow
    section_id:onerow
    button_label:onerow
    questions:onerow
    description:onerow
    modification_allowed_p:onerow
    return_url:onerow
}

permission::require_permission -object_id $survey_id -privilege survey_take_survey

set context $name
set button_label "[_ survey.Submit_response]"
if {$editable_p == "t"} {
    if {$response_id > 0} {
	set button_label "[_ survey.lt_Modify_previous_respo]"
	db_1row get_initial_response ""
    }
}

# build a list containing the HTML (generated with survey_question_display) for each question
set rownum 0
# for double-click protection
set new_response_id [db_nextval acs_object_id_seq]    
set questions [list]

db_foreach survey_sections {} {

    db_foreach question_ids_select {} {
	lappend questions [survey_question_display $question_id $response_id]
    }

    # return_url is used for infoshare - if it is set
    # the survey will return to it rather than
    # executing the survey associated with the logic
    # after the survey is completed
    #
    if {![info exists return_url]} {
	set return_url {}
    }
}
set form_vars [export_vars -form {section_id survey_id new_response_id}]
ad_return_template


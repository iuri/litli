ad_page_contract {

    Display a questionnaire for one survey.

    @param  section_id   id of displayed survey

    @author philg@mit.edu
    @author nstrug@arsdigita.com
    @date   28th September 2000
    @cvs-id $Id: survey-preview.tcl,v 1.7.2.1 2016/05/21 11:04:16 gustafn Exp $

} {
    
    survey_id:naturalnum,notnull
    {section_id:naturalnum ""}
    return_url:localurl,optional

} -validate {
    survey_exists -requires {survey_id} {
	if {![db_0or1row survey_exists {}]} {
	    ad_complain "[_ survey.lt_Survey_survey_id_does]"
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

    get_survey_info -survey_id $survey_id
    set name $survey_info(name)
    set description $survey_info(description)
    set description_html_p $survey_info(description_html_p)
    set single_response_p $survey_info(single_response_p)
    set editable_p $survey_info(editable_p)
    set display_type $survey_info(display_type)

   if {$description_html_p != "t"} {
       set description [ad_text_to_html $description]
   } 
   

set context [list "[_ survey.Preview] $name"]

# build a list containing the HTML (generated with survey_question_display) for each question
set rownum 0
    
set questions [list]

db_foreach survey_sections {} {

    db_foreach question_ids_select {} {
	lappend questions [survey_question_display $question_id]
    }


    }

set return_url [export_vars -base one survey_id]
set form_vars [export_vars -form {section_id survey_id}]
ad_return_template


ad_page_contract {
    Present form to begin adding a question to a survey.
    Lets user enter the question and select a presentation type.

    @param section_id    integer designating survey we're adding question to
    @param after        optinal integer denoting position of question within survey

    @author  jsc@arsdigita.com
    @author  nstrug@arsdigita.com
    @date    February 9, 2000
    @cvs-id $Id: question-add.tcl,v 1.8 2015/06/27 20:46:15 gustafn Exp $
} {
    section_id:naturalnum,notnull
    {after:integer ""}
    
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
permission::require_permission -object_id $package_id -privilege survey_create_question

get_survey_info -section_id $section_id

ad_form -name create_question -action question-add-2  -export { after } -form {
    question_id:key
    {section_id:text(hidden) {value $section_id}}
    {question_text:text(textarea) {label "[_ survey.Question]"}  {html {rows 5 cols 70}}}   
}

ad_form -extend -name create_question -form {
     {presentation_type:text(select)
	 {label "[_ survey.Presentation_Type]"}
	 {options {{ "[_ survey.lt_One_Line_Answer_Text_]" "textbox" }
	           { "[_ survey.lt_Essay_Answer_Text_Are]" "textarea" }
        	     { "[_ survey.lt_Multiple_Choice_Drop_]" "select" }
        	     { "[_ survey.lt_Multiple_Choice_Radio]" "radio" }
		     { "[_ survey.lt_Multiple_Choice_Check]" "checkbox" }
		     { "[_ survey.Date]" "date" }
		     { "[_ survey.File_Attachment]" "upload_file" } } } }
}	    
		
    

get_survey_info -section_id $section_id
set survey_id $survey_info(survey_id)
set context [list [list [export_vars -base one {survey_id}] $survey_info(name)] "[_ survey.Add_A_Question]"]

if {[parameter::get -parameter allow_question_deactivation_p] == 1} {
    ad_form -extend -name create_question -form {
        {active:text(radio)     {label "[_ survey.Active]"} {options {{[_ survey.Yes] t} {[_ survey.No] f}}} {value t}}
    } 
} else {
    ad_form -extend -name create_question -form {
        {active:text(hidden) {value t}}
    }
}
ad_form -extend -name create_question -form {
    {required_p:text(radio)     {label "[_ survey.Required]"} {options {{"[_ survey.Yes]" t} {"[_ survey.No]" f}}} {value t}}
}
    
ad_return_template





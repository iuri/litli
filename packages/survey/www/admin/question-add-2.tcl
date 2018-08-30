# /www/survsimp/admin/question-add-2.tcl
ad_page_contract {

    Based on the presentation type selected in previous form,
    gives the user various options on how to lay out the question.

    @param section_id         integer determining survey we're dealing with
    @param after              optional integer determining placement of question
    @param question_text      text comprising this question
    @param presentation_type  string denoting widget used to provide answer
    @param required_p         flag indicating whether this question is mandatory
    @param active_p           flag indicating whether this question is active
    @param category_id        optional integer describing category of this question (within survey)

    @author Jin Choi (jsc@arsdigita.com)
    @author nstrug@arsdigita.com
    @date   February 9, 2000
    @cvs-id $Id: question-add-2.tcl,v 1.8 2015/06/27 20:46:15 gustafn Exp $
} {

    section_id:naturalnum,notnull
    question_text:html,notnull
    presentation_type
    {after:integer ""}
    {required_p:boolean t}
    {active_p:boolean t}
    {n_responses ""}

}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
permission::require_permission -object_id $package_id -privilege survey_create_question

set question_id [db_nextval acs_object_id_seq]
get_survey_info -section_id $section_id

if {![info exists survey_info(survey_id)]} {
    ad_return_complaint 1 "[_ survey.lt_Requested_survey_does]"
    ad_script_abort
}

set survey_id $survey_info(survey_id)
set type $survey_info(type)

# create a blank form, we fill it based on the question type
# maybe put question_id:key in there if we move the processing from quesion-add-3 to this form.

ad_form -name create-question-2 -action question-add-3 -form {
    {question:text(inform) {label "[_ survey.Question_Text]"} {value $question_text}}
    {survey_id:text(hidden) {value $survey_id}}
    {section_id:text(hidden) {value $section_id}}
    {question_id:text(hidden) {value $question_id}}
    {question_text:text(hidden) {value $question_text}}
    {presentation_type:text(hidden) {value $presentation_type}}
    {after:text(hidden) {value $after}}
    {required_p:text(hidden) {value $required_p}}
    {active_p:text(hidden) {value $active_p}}
    {type:text(hidden) {value $type}}
}


# set exception_count 0
# set exception_text ""

# if { $type ne "general" && $type ne "scored" } {
#     incr exception_count
#     append exception_text "<li>Surveys of type $type are not currently available\n"
# }

# if { $presentation_type eq "upload_file" } {
# #    incr exception_count
# #    append exception_text "<li>The presentation type: upload file is not supported at this time."
    
# }

# if { $exception_count > 0 } {
#     ad_return_complaint $exception_count $exception_text
#     return
# }

# Survey-type specific question settings

if { $type eq "scored" } {

    db_1row count_variable_names ""

    set response_fields "<table border=0>
<tr><th>[_ survey.Answer_Text]</th><th colspan=$n_variables>[_ survey.Score]</th></tr>
<tr><td></td>"

    set variable_id_list [list]
    db_foreach select_variable_names "" {
	lappend variable_id_list $variable_id
	append response_fields "<th>$variable_name</th>"
    }

    append response_fields "</tr>\n"

    for {set response 0} {$response < $n_responses} {incr response} {
	append response_fields "<tr><td align=center><input type=text name=\"responses\" size=80></td>"
	for {set variable 0} {$variable < $n_variables} {incr variable} {
	    append response_fields "<td align=center><input type=text name=\"scores.$variable\" size=2></td>"
	}
	append response_fields "</tr>\n"
    }

    append response_fields "</table>\n"
    set response_type_html "<input type=hidden name=abstract_data_type value=\"choice\">"
    set presentation_options_html ""
    set form_var_list [export_vars -form {section_id question_id question_text presentation_type after required_p active_p type n_variables variable_id_list}]

} elseif { $type eq "general" } {

# Display presentation options for sizing text input fields and textareas.

    switch -- $presentation_type {
	"textbox" { 

	    ad_form -extend -name create-question-2 -form {
		{textbox_size:text(select) {options {{[_ survey.Small] small} {[_ survey.Medium] medium} {[_ survey.Large] large}}} {label "[_ survey.Size]"}}
		{abstract_data_type:text(select) {label "[_ survey.Type_of_Response]"}
		{options {{"[_ survey.Short_Text]" shorttext} {[_ survey.Text] text} {[_ survey.Boolean] boolean} {[_ survey.Number] number} {[_ survey.Integer] integer}}}
	    }

	    }	    
	}
	"textarea" {
	    ad_form -extend -name create-question-2 -form {
		{textarea_size:text(select) {options {{[_ survey.Small] small} {[_ survey.Medium] medium} {[_ survey.Large] large}}} {label "[_ survey.Size]"}}
		{abstract_data_type:text(hidden) {value "text"}}

	    }
	}
    }
}
# Let user enter valid responses for selections, radio buttons, and check boxes.

    set response_fields ""

    switch -- $presentation_type {
	"radio" -
	"select" {

	    ad_form -extend -name create-question-2 -form {
		{abstract_data_type:text(radio)
		    {label "[_ survey.Type_of_Response]"} {value "choice"} 
		    {options {{"[_ survey.True_or_False]" boolean} {"[_ survey.Yes_or_No]" yn} {"[_ survey.Multiple_Choice]" choice}}}}
		{valid_responses:text(textarea)
		    {label "[_ survey.lt_For_Multiple_Choicebr]"}
		    {html {rows 10 cols 50}}}
	    }
	}
	 
	"checkbox" {
	    ad_form -extend -name create-question-2 -form {
		{valid_responses:text(textarea) {label "[_ survey.lt_Valid_Resposnes_enter]"} {html {rows 10 cols 50}}}
		{abstract_data_type:text(hidden) {value "choice"}}
	    }
	}


	
	"date" {

	    ad_form -extend -name create-question-2 -form {
		{abstract_data_type:text(hidden) {value date}}
	    }

	}
	"upload_file" {
	    ad_form -extend -name create-question-2 -form {
		{abstract_data_type:text(hidden) {value blob}}
	    }
	}
    }

ad_form -extend -name create-question-2 -form {
    {presentation_alignment:text(radio) {options {{"[_ survey.Beside_the_question]" beside} {"[_ survey.Below_the_question]" below}}} {value below} {label "[_ survey.lt_Presentation_Alignmen]"}}
}
set context [list [list [export_vars -base one {survey_id}] $survey_info(name)] "[_ survey.Add_A_Question]"]

ad_return_template

ad_page_contract {

    Allow the user to modify a question.

    @param   section_id   survey this question belongs to
    @param   question_id question which text we're changing

    @author  cmceniry@arsdigita.com
    @author  nstrug@arsdigita.com
    @date    Jun 16, 2000
    @cvs-id  $Id: question-modify.tcl,v 1.6 2014/10/27 16:41:58 victorg Exp $
} {

    question_id:naturalnum,notnull
    section_id:naturalnum,notnull
    {valid_responses ""}
    {presentation_options ""}
    {sort_order ""}
}

get_survey_info -section_id $section_id
set survey_name $survey_info(name)
set survey_id $survey_info(survey_id)
permission::require_permission -object_id $survey_id -privilege survey_modify_question
set allow_question_deactivation [parameter::get -parameter "allow_question_deactivation_p"]
set n_responses [db_string survey_number_responses {} ]

ad_form -name modify_question -form {
    question_id:key
}

if {$n_responses > 0} {
    if {$n_responses >1} {
	set isare "[_ survey.are]"
	set resp "[_ survey.responses]"
    } else {
	set isare "[_ survey.is]"
	set resp "[_ survey.response]"
    }
    ad_form -extend -name modify_question -form {
	{warning:text(inform) {label "[_ survey.Warning]"} {value "<span style=\"color: #f00;\">[_ survey.lt_There_isare_n_resp]"}}
    }
}
ad_form -extend -name modify_question -export {sort_order} -form {
    {question_number:text(inform) {label "[_ survey.Modify_Question] #"}}
    {survey_name:text(inform) {label "[_ survey.From_1]"} {value $survey_name}}
    {question_text:text(textarea) {label "[_ survey.Question]"} {html {rows 5 cols 70}}}
}

if {$allow_question_deactivation == 1} {
    ad_form -extend -name modify_question -form {
        {active_p:text(radio)     {label "[_ survey.Active]"} {options {{[_ survey.Yes] t} {[_ survey.No] f}}}}
    }
} else {
    ad_form -extend -name modify_question -form {
        {active_p:text(hidden) {value t}}
    }
}
ad_form -extend -name modify_question -form {
    {required_p:text(radio)     {label "[_ survey.Required]"} {options {{"[_ survey.Yes]" t} {"[_ survey.No]" f}}}}
    {section_id:text(hidden) {value $section_id}}
    {survey_id:text(hidden) {value $survey_id}}
} 


db_1row presentation {}

if {($presentation_type=="checkbox" || $presentation_type=="select" || $presentation_type=="radio") && $abstract_data_type ne "boolean"} {
    set valid_responses_list [db_list survey_question_valid_responses {}]
    set response_list ""
    foreach response $valid_responses_list {
	append valid_responses "$response\n"
    }
    ad_form -extend -name modify_question -form {
        {valid_responses:text(textarea)
            {label "[_ survey.lt_For_Multiple_Choicebr]"}
            {html {rows 10 cols 50}}
            {value $valid_responses}}
    } 
} 

if {$presentation_type eq "textarea" || $presentation_type eq "textbox"} {
    ad_form -extend -name modify_question -form {
	{presentation_options:text(select) {options {{[_ survey.Small] small} {[_ survey.Medium] medium} {[_ survey.Large] large}}} {value $presentation_options} {label "[string totitle $presentation_type] [_ survey.Size]"}} 

    }
}


ad_form -extend -name modify_question -select_query_name {survey_question_details} -edit_data {

    db_dml survey_question_update {}

    # add new responses is choice type question


    if {[info exists valid_responses]} {

        set responses [split $valid_responses "\n"]
        set count 0
        set response_list ""
        foreach response $responses {
            set trimmed_response [string trim $response]
            if { $trimmed_response eq "" } {
                # skip empty lines
                continue
            }

            lappend response_list [list "$trimmed_response" "$count"]
            incr count
        }
        
        set choice_id_to_update_list [db_list get_choice_id {}]
        set choice_count 0
        foreach one_response $response_list {
            set choice_name [lindex $one_response 0]
            set choice_value [lindex $one_response 1]
            set choice_id_to_update [lindex $choice_id_to_update_list $choice_count]
            if {$choice_id_to_update eq ""} {
                db_dml insert_new_choice {}
            } else {

                db_dml update_new_choice {}
            }
            incr choice_count
        }
        while {[llength $choice_id_to_update_list] >= $choice_count} {
            set choice_id_to_delete [lindex $choice_id_to_update_list $choice_count]
            db_dml delete_old_choice {}
            incr choice_count
        }

    }


    


    ad_returnredirect "one?survey_id=$survey_id&#${sort_order}"
    ad_script_abort
}


set context [_ survey.Modify_Question]

ad_return_template

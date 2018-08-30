# /www/survsimp/admin/survey-create.tcl
ad_page_contract {

  Form for creating a survey.

  @param  name         title for new survey
  @param  description  description for new survey

  @author raj@alum.mit.edu
  @author nstrug@arsdigita.com
  @date   February 9, 2000
  @cvs-id $Id: survey-create.tcl,v 1.9 2014/10/27 16:41:58 victorg Exp $

} {
    survey_id:naturalnum,optional
    {name ""}
    {description:html ""}
    {variable_names ""}
    {type "general"}
}

set package_id [ad_conn package_id]

# bounce the user if they don't have permission to admin surveys
permission::require_permission -object_id $package_id -privilege survey_create_survey
set user_id [ad_conn user_id]

# use ad_form --DaveB
set display_type "list"

ad_form -name create_survey -confirm_template survey-create-confirm -form {
    survey_id:key
    {display_type:text(hidden)  {value $display_type}}
    {name:text(text)            {label "[_ survey.Survey_Name_1]"} {html {size 55}}}
    {description:text(textarea) {label "[_ survey.Description_1]"} {html {rows 10 cols 40}}}
    {desc_html:text(radio)      {label "[_ survey.lt_The_Above_Description]"}
	{options {{"[_ survey.Preformatted_Text]" "pre"}
	       {"HTML" "html"} }}
		{value "pre"}
    }
    
} -validate { 
    {name {[string length $name] <= 4000}
    "[_ survey.lt_Survey_Name_must_be_4]"
}     {description {[string length $description] <= 4000}
    "[_ survey.lt_Survey_Name_must_be_4]"
}
    {survey_id {[db_string count_surveys "select count(survey_id) from surveys where survey_id=:survey_id"] < 1} "[_ survey.oops]"
    }
    
} -new_data {
        
    if {$desc_html eq "html" } {
	set description_html_p "t"
    } else {
	set description_html_p "f"
    }

    if {[parameter::get -package_id $package_id -parameter survey_enabled_default_p -default 0]} {
	set enabled_p "t"
    } else {
	set enabled_p "f"
    }
    db_transaction {
	db_exec_plsql create_survey ""

	# survey type-specific inserts


	# create new section here. the questions go in the section
	# section_id is null to create a new section
	# we might want to specify a section_id later for
	# multiple section surveys
	set section_id ""
	set section_id [db_exec_plsql create_section ""]
    }
    ad_returnredirect "question-add?section_id=$section_id"
    ad_script_abort
}




# function to insert survey type-specific form html

set context [_ survey.Create_Survey]

ad_return_template


ad_page_contract {
    Copy a survey
    @author  dave@thedesignexperience.org
    @date    August 3, 2002
    @cvs-id $Id:
} {
    survey_id:naturalnum,notnull
    name:optional
    new_survey_id:naturalnum,optional
}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

permission::require_permission -object_id $package_id -privilege survey_create_question
db_1row get_survey_info {}
set title_name $name
set name "[_ survey.Copy_of] $name"

ad_form -name copy_survey -form {
    new_survey_id:key
    {message:text(inform) {value "[_ survey.lt_Copying_a_survey_will]"}} 
    {name:text(text) {label "[_ survey.Name_copy]"} {html {size 60}} {value $name}}
    {survey_id:text(hidden) {value $survey_id}}
    
} -on_submit {
    set new_survey_id [survey_copy -survey_id $survey_id -new_name $name]

    set survey_id $new_survey_id
 
    ad_returnredirect [export_vars -base one survey_id]
    ad_script_abort
}


set context "[_ survey.Copy] $title_name"
ad_return_template

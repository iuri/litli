ad_page_contract {

    Edit the name of the survey

    @param  section_id  integer denoting survey whose description we're changing

    @author Jin Choi (jsc@arsdigita.com) 
    @author nstrug@arsdigita.com
    @date   February 16, 2000
    @cvs-id $Id: name-edit.tcl,v 1.8 2015/06/27 20:46:15 gustafn Exp $
} {

    survey_id:naturalnum,notnull
    {name ""}
    {description:html ""}
}

get_survey_info -survey_id $survey_id
set survey_name "$survey_info(name)"

permission::require_permission -object_id $survey_id -privilege survey_modify_survey

ad_form -name edit-name -form {
    survey_id:key
    {name:text(text) {label "[_ survey.Survey_Name_1]"} {html {size 80}}}
	{description:text(textarea) {label "[_ survey.Description_1]"} 
	{html {rows 10 cols 65}}}
	{description_html_p:text(radio)      {label "[_ survey.lt_The_Above_Description]"}
	{options {{"[_ survey.Preformatted_Text]" "f"}
	       {"HTML" "t"} }}
	       {value "pre"}}

} -validate {
    {name {[string length $name] <= 4000}
    "[_ survey.lt_Survey_Name_must_be_l]"
    }
} -edit_request {
    get_survey_info -survey_id $survey_id
    set name "$survey_info(name)"
    set description "$survey_info(description)"
    set description_html_p "$survey_info(description_html_p)"
} -edit_data {
    db_dml survey_update ""
    ad_returnredirect [export_vars -base one survey_id]
    ad_script_abort
}

set context [_ survey.Edit_Name]

ad_return_template



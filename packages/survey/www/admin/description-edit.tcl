ad_page_contract {

    Form to allow user to the description of a survey.

    @param  section_id  integer denoting survey whose description we're changing

    @author Jin Choi (jsc@arsdigita.com) 
    @author nstrug@arsdigita.com
    @date   February 16, 2000
    @cvs-id $Id: description-edit.tcl,v 1.8 2015/06/27 20:46:15 gustafn Exp $
} {

    survey_id:naturalnum,notnull

}

permission::require_permission -object_id $survey_id -privilege survey_modify_survey
ad_form -name edit-survey -form {
    survey_id:key
    {description:text(textarea) {label "[_ survey.Survey_Description]"} {html {rows 10 cols 65}}}
    {desc_html:text(radio)      {label "[_ survey.lt_The_Above_Description]"}
	                        {options {{"[_ survey.Preformatted_Text]" "pre"}    
				    {"HTML" "html"} {"[_ survey.Plain_Text]" "plain"}}}}
} -edit_request {
    get_survey_info -survey_id $survey_id
    set survey_name $survey_info(name)
    set description $survey_info(description)
    set description_html_p $survey_info(description_html_p)
    set desc_html ""
    if {$description_html_p=="t"} {
	set desc_html "html"
    } else {
	set desc_html "plain"
    }
    ad_set_form_values desc_html description
    
} -validate {
    {description {[string length $description] <= 4000}
    "[_ survey.lt_Description_must_be_l]"
    }
}
} -edit_data { 
    if {$desc_html=="pre" || $desc_html=="html"} {
	set description_html_p t
    } else {
	set description_html_p f
    }
        db_dml survey_update_description ""

    ad_returnredirect [export_vars -base one {survey_id}]
    ad_script_abort
}

set context [list [list [export_vars -base one {survey_id}] $survey_info(name)] "[_ survey.Edit_Description]"]

ad_return_template

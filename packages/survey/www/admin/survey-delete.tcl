ad_page_contract {

    This page allows the admin to delete survey and all responses.

    @param survey_id

    @author dave@thedesignexperience.org
    @date   August 7, 2002
    @cvs-id $Id: survey-delete.tcl,v 1.7 2015/06/27 20:46:16 gustafn Exp $
} {

   survey_id:naturalnum,notnull

}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege survey_admin_survey

get_survey_info -survey_id $survey_id

set questions_count ""
set responses_count ""

ad_form -name confirm_delete -form {
    {survey_id:text(hidden) {value $survey_id}}
    {warning:text(inform) {label "[_ survey.Warning_1]"} {value "[_ survey.lt_Deleting_this_surve]"}}
    {confirmation:text(radio) {label " "}
	{options
	    {{"[_ survey.Continue_with_Delete]" t }
	     {"[_ survey.lt_Cancel_and_return_to__1]" f }}	}
	    {value f}
    }

} -on_submit {
    if {$confirmation} {
	db_exec_plsql delete_survey {}
	ad_returnredirect "."
        ad_script_abort
    } else {
	ad_returnredirect [export_vars -base one survey_id]
        ad_script_abort
    }
}

set context [_ survey.Delete_Survey]

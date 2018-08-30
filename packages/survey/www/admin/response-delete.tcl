ad_page_contract {

    This page allows the admin to delete survey and all responses.

    @param survey_id

    @author dave@thedesignexperience.org
    @date   August 7, 2002
    @cvs-id $Id: response-delete.tcl,v 1.6 2015/06/27 20:46:15 gustafn Exp $
} {
   response_id:naturalnum,optional
}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege survey_admin_survey

db_1row get_response_info {}

ad_form -name confirm_delete -form {
    {response_id:text(hidden) {value $response_id}}
    {survey_id:text(hidden) {value $survey_id}}
    {user_id:text(hidden) {value $user_id}}
    {warning:text(inform) {value "[_ survey.lt_Completely_delete [list user_name_var user_name response_date_var response_date]]"}
    {label "[_ survey.Warning]"}}
    {confirmation:text(radio) {label " "}
	{options
	    {{"[_ survey.Continue_with_Delete]" t }
	     {"[_ survey.lt_Cancel_and_return_to_]" f }}	}
	    {value f}
    }

} -on_submit {
    if {$confirmation} {
	db_exec_plsql delete_response {}
    } 
    ad_returnredirect [export_vars -base one-respondent {survey_id user_id}]
}

set context [_ survey.Delete_Response]

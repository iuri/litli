ad_page_contract {

    Toggles a survey between allowing a user to
    edit to or not.

    @param  section_id survey we're dealing with

    @author Jin Choi (jsc@arsdigita.com)
    @author nstrug@arsdigita.com
    @cvs-id $Id: response-editable-toggle.tcl,v 1.4 2015/06/27 20:46:16 gustafn Exp $
} {

    survey_id:naturalnum,notnull

}

permission::require_permission -object_id $survey_id -privilege survey_admin_survey

db_dml survey_response_editable_toggle ""

db_release_unused_handles
ad_returnredirect [export_vars -base one {survey_id}]

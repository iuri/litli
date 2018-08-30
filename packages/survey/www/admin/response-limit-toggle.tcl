# /www/survsimp/admin/response-limit-toggle.tcl
ad_page_contract {

    Toggles a survey between allowing multiple responses or one response per user.

    @param section_id survey whose properties we're changing

    @cvs-id response-limit-toggle.tcl,v 1.2.2.6 2000/07/21 04:04:21 ron Exp

} {

    survey_id:naturalnum,notnull

}

permission::require_permission -object_id $survey_id -privilege survey_admin_survey

db_dml survey_response_toggle ""

db_release_unused_handles
ad_returnredirect [export_vars -base one {survey_id}]

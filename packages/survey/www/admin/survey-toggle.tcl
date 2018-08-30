ad_page_contract {
    Survey,-toggle.tcl will toggle (ie - enable or disable) a single survey.

    @param section_id   survey we're toggling
    @param enabled_p    flag describing original state of survey
    @param target       URL where we will be redirected to after toggling

    @author raj@alum.mit.edu
    @author nstrug@arsdigita.com
    @date   February 9, 2000
    @cvs-id $Id: survey-toggle.tcl,v 1.5 2015/06/14 00:49:36 gustafn Exp $
} {
    survey_id:naturalnum,notnull
    enabled_p:boolean
    {target "./"}
}

permission::require_permission -object_id $survey_id -privilege survey_admin_survey

if {$enabled_p == "f"} {
    set enabled_p "t"
} else {
    set enabled_p "f"
}

db_dml survey_active_toggle ""

ad_returnredirect "$target"


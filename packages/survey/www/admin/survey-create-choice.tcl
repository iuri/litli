# /www/survsimp/admin/survey-create-choice.tcl
ad_page_contract {

    Ask the user what kind of survey they wish to create.

    @author nstrug@arsdigita.com
    @date September 13, 2000
    @cvs-id $Id: survey-create-choice.tcl,v 1.4 2014/10/27 16:41:58 victorg Exp $

} {



}

set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege survey_create_survey

set title [_ survey.Choose_a_Survey_Type]
set context [list [_ survey.Choose_Type]]

set body [subst {
    <hr>
    <dl>
    <dt><a href="survey-create?type=scored">[_ survey.Scored_Survey]</a>
    <dd>[_ survey.lt_This_is_a_multiple_ch]</dd>
    <dt><a href="survey-create?type=general">[_ survey.General_Survey]</a>
    <dd>[_ survey.lt_This_survey_allows_yo]</dd>
    </dl>
}]

ad_return_template generic


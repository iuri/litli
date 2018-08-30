ad_page_contract {
    List respondents to this survey.

    @param section_id which survey we're displaying respondents to

    @author jsc@arsdigita.com
    @author nstrug@arsdigita.com
    @creation-date February 11, 2000
    @version $Id: respondents.tcl,v 1.11.4.1 2017/02/02 21:45:38 gustafn Exp $
} -query {
    survey_id:integer
    {orderby:token "email"}
    {response_type "responded"}
} -properties {
    survey_id:onevalue
    survey_name:onevalue
    respondents:multirow
}

permission::require_permission -object_id $survey_id -privilege survey_admin_survey

# for sloanspace, we can also list users who have NOT responded or
# the entire group.


get_survey_info -survey_id $survey_id
set survey_name $survey_info(name)

set doc(title) [_ survey.Respondents]
set context [list [list [export_vars -base "one" {survey_id}] $survey_info(name)] $doc(title)]

template::list::create -name respondents -multirow respondents -no_data [_ survey.No_data_found] -elements {
    first_names {
        label "[_ survey.First_Name]" 
        link_url_col one_respondent_url
        orderby first_names
    }
    last_name {
        label "[_ survey.Last_Name]"
        link_url_col one_respondent_url
        orderby last_name
    }
    email {
        label "[_ survey.Email_Address]"
        link_url_col one_respondent_url
        orderby email
    }
    action {
        label "[_ survey.Actions]"
        link_url_col one_respondent_url
    } 
} -filters {
    survey_id {}
}

db_multirow -extend { one_respondent_url action } respondents select_respondents {} {
    set one_respondent_url [export_vars -base "one-respondent" {user_id survey_id}]
    set action [_ survey.View]
}

ad_return_template

# 

ad_page_contract {
    
    Add new | Edit Site Templates 
    
    @author Victor Guerra (guerra@galileo.edu)
    @creation-date 2005-05-20
    @arch-tag: 9619249e-d7fb-4292-8af1-98b92ee33bba
    @cvs-id $Id: add-edit-site-template.tcl,v 1.3.2.1 2015/09/11 11:40:48 gustafn Exp $
} {
    site_template_id:naturalnum,optional
    referer:notnull
    {pretty_name ""}
    {site_master ""}
} -properties {
    title:onevalue
    context_bar:onevalue
} -validate {
} -errors {
}

dotlrn::require_admin

if {![info exists site_template_id]} {
    set title "[_ dotlrn.Site_Template_Adding]"
} else {
    set title "[_ dotlrn.Site_Template_Editting]"
}

set context_bar [list [list site-templates "[_ dotlrn.Site_Templates]"] "$title"]

set options [db_list_of_lists select_portal_themes { *SQL* }]
ad_form -cancel_url $referer -export {referer} -name site_template -form {
    site_template_id:key
    {pretty_name:text(text)
	{label "[_ dotlrn.Site_Template_Name]"}
	{html {size 30}}
	{help_text "[_ dotlrn.Site_Template_Name_help]"}
    }
    {site_master:text(text)
	{label "[_ dotlrn.Site_Template_Sitemaster]"}
	{html {size 40}}
	{help_text "[_ dotlrn.Site_Template_Sitemaster_help]"}
    }
    {portal_theme_id:text(radio)
	{label "[_ dotlrn.Site_Template_Portal_theme]"}
	{help_text "[_ dotlrn.Site_Template_Portal_theme_help]"}
	{options $options}
    }    
} -select_query_name select_site_template_info -new_data {
    set site_template_id [db_nextval acs_object_id_seq]
    db_dml insert_site_template { *SQL* }
} -edit_data {
    db_dml update_site_template { *SQL* }
    util_memoize_flush [list dotlrn::get_master_from_site_template_id_not_cached -site_template_id $site_template_id]
} -new_request {
    set pretty_name ""
    set site_master ""
} -after_submit {
    ad_returnredirect $referer
    ad_script_abort
}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

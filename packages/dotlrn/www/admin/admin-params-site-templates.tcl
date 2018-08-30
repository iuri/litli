# 

ad_page_contract {
    
    Parameter Administration for Site Templates
    
    @author Victor Guerra (guerra@galileo.edu)
    @creation-date 2005-12-08
    @arch-tag: f5015caa-41c8-4f82-bbef-44450f1c6ffc
    @cvs-id $Id: admin-params-site-templates.tcl,v 1.2.10.2 2016/05/20 20:17:34 gustafn Exp $
} {
    return_url:localurl,notnull
} -properties {
    title:onevalue
    contex_bar:onevalue
} -validate {
} -errors {
}

set title "[_ dotlrn.Site_Templates_Template_AdminParams]"
set context_bar [list [list site-templates "[_ dotlrn.Site_Templates]"] "$title"]

set dotlrn_package_id [dotlrn::get_package_id]
set template_options [db_list_of_lists select_templates {select pretty_name, site_template_id from dotlrn_site_templates}]
set template_options [lang::util::localize_list_of_lists -list $template_options]

ad_form -cancel_url $return_url -export { dotlrn_package_id return_url } -name admin-params -form {
    {user_change_p:text(radio) 
	{label "[_ dotlrn.Site_Template_Userchange]"}
	{options { {"[_ dotlrn.Yes]" 1 } { "[_ dotlrn.No]" 0} } }
    }
    {user_default_sitetemplate:text(select) 
	{label "[_ dotlrn.Site_Template_Userdefault]"}
	{options $template_options}
    }
    {comm_change_p:text(radio) 
	{label "[_ dotlrn.Site_Template_Commchange]"}
	{options { {"[_ dotlrn.Yes]" 1 } { "[_ dotlrn.No]" 0} } }
    }
    {comm_default_sitetemplate:text(select) 
	{label "[_ dotlrn.Site_Template_Commdefault]"}
	{options $template_options}
    }
    {none_default_sitetemplate:text(text) 
	{label "[_ dotlrn.Site_Template_Nonedefault]"}
	{html {size 50}}
    }
} -on_request {
    
    set user_change_p [parameter::get -package_id $dotlrn_package_id -parameter UserChangeSiteTemplate_p]
    set user_default_sitetemplate [parameter::get -package_id $dotlrn_package_id -parameter UserDefaultSiteTemplate_p]
    set comm_change_p [parameter::get -package_id $dotlrn_package_id -parameter AdminChangeSiteTemplate_p]
    set comm_default_sitetemplate [parameter::get -package_id $dotlrn_package_id -parameter CommDefaultSiteTemplate_p]
    set none_default_sitetemplate [parameter::get -package_id $dotlrn_package_id -parameter DefaultMaster_p]
    
} -on_submit {
    
    set user_change_p_old [parameter::get -package_id $dotlrn_package_id -parameter UserChangeSiteTemplate_p]
    set comm_change_p_old [parameter::get -package_id $dotlrn_package_id -parameter AdminChangeSiteTemplate_p]
    
    if { (!$user_change_p && $user_change_p_old) || (!$user_change_p && $user_default_sitetemplate != [parameter::get -package_id $dotlrn_package_id -parameter UserDefaultSiteTemplate_p]) } {
	ns_log Warning "Flush for users"
	dotlrn::assign_default_sitetemplate -site_template_id $user_default_sitetemplate
    }
    
    if { (!$comm_change_p && $comm_change_p_old) || (!$comm_change_p && $comm_default_sitetemplate != [parameter::get -package_id $dotlrn_package_id -parameter CommDefaultSiteTemplate_p]) } {
	dotlrn_community::assign_default_sitetemplate -site_template_id $comm_default_sitetemplate
    }
    
    parameter::set_value -package_id $dotlrn_package_id \
	-parameter "UserChangeSiteTemplate_p" \
	-value $user_change_p
    
    parameter::set_value -package_id $dotlrn_package_id \
	-parameter "AdminChangeSiteTemplate_p" \
	-value $comm_change_p
    
    parameter::set_value -package_id $dotlrn_package_id \
	-parameter "UserDefaultSiteTemplate_p" \
	-value $user_default_sitetemplate
    
    parameter::set_value -package_id $dotlrn_package_id \
	-parameter "CommDefaultSiteTemplate_p" \
	-value $comm_default_sitetemplate
    
    parameter::set_value -package_id $dotlrn_package_id \
	-parameter "DefaultMaster_p" \
	-value $none_default_sitetemplate

} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

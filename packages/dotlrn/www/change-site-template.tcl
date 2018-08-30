# 

ad_page_contract {
    
    Change the dotlrn site template for a given user or community
    
    @author Victor Guerra (guerra@galileo.edu)
    @creation-date 2005-05-25
    @arch-tag: 71db35e8-e432-49b0-900c-6d8a5cdbdb16
    @cvs-id $Id: change-site-template.tcl,v 1.3.4.1 2015/09/11 11:40:41 gustafn Exp $
} {
    referer:notnull
} -properties {
} -validate {
} -errors {
}

set title "Change Site Template"
set context [list $title]



set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set dotlrn_package_id [dotlrn::get_package_id]

if { $community_id eq ""} {
    set allowed_to_change [parameter::get -package_id $dotlrn_package_id -parameter "UserChangeSiteTemplate_p" \
			      -default 0]
    set site_template_id [dotlrn::get_site_template_id -user_id $user_id]
} else {
    set allowed_to_change [parameter::get -package_id $dotlrn_package_id -parameter "AdminChangeSiteTemplate_p" \
			       -default 0]
    set site_template_id [dotlrn_community::get_site_template_id -community_id $community_id]
}

if {!$allowed_to_change} {
    ad_return_complaint  1 "<li>You are not allowed to change the Site Template</li>"
    ad_script_abort
}

set options [db_list_of_lists select_site_templates {} ]

ad_form -export {community_id user_id referer site_template_id} -cancel_url $referer -name site_templates -form {
    {site_templates:text(radio)
	{label "Template"}
	{options $options}
	{value $site_template_id}
    }
} -on_submit {
    if {$site_templates ne ""} {
	if {$community_id eq ""} {
	    dotlrn::set_site_template_id -user_id $user_id -site_template_id $site_templates
	} else {
	    dotlrn_community::set_site_template_id -community_id $community_id -site_template_id $site_templates
	}
	ad_returnredirect $referer
	ad_script_abort
    } else {
	template::form::set_error site_templates site_templates "You must select a Site Template!!"
    } 
}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

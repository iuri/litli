ad_page_contract {
    
    Displays the site map

    @author Emmanuelle Raffenne (eraffenne@gmail.com)
    @creation-date 2008-10-16
    @version $Id: site-map.tcl,v 1.4.4.1 2015/09/11 11:40:46 gustafn Exp $
}

# Make sure user is logged in
set user_id [auth::require_login]

set doc(title) [_ dotlrn.Site_Map]
set context [list $doc(title)]

set dotlrn_url [dotlrn::get_url]
set dotlrn_admin_url [dotlrn::get_admin_url]
set dotlrn_package_id [dotlrn::get_package_id]

set return_url [ad_return_url]

# Get user portal pages

set portal_id [dotlrn::get_portal_id -user_id $user_id]

db_multirow -extend { url } home_pages list_page_nums_select {} {
    set url [export_vars -base $dotlrn_url {{page_num $sort_key}}]
}


# Get user memberships for courses

db_multirow -extend { admin_p } courses select_courses {} {
    set admin_p [dotlrn::user_can_admin_community_p  -user_id $user_id  -community_id $community_id]
}


# Get user memberships for communities

db_multirow -extend { admin_p } communities select_communities {} {
    set admin_p [dotlrn::user_can_admin_community_p  -user_id $user_id  -community_id $community_id]
}

# control panel
set subsite_url [subsite::get_element -element url]
set account_status [ad_conn account_status]

set notifications_url [lindex [site_node::get_children -node_id [subsite::get_element -element node_id] -package_key "notifications"] 0]

set portrait_url "${subsite_url}user/portrait"
set community_member_url [acs_community_member_url -user_id $user_id]
set email_privacy_url [export_vars -base "${subsite_url}user/email-privacy-level" {return_url}]
set password_update_url [export_vars -base "${subsite_url}user/password-update" {return_url}]

set whos_online_url "${subsite_url}shared/whos-online"
set make_visible_url [export_vars -base "${subsite_url}shared/make-visible" {return_url}]
set make_invisible_url [export_vars -base "${subsite_url}shared/make-invisible" {return_url}]
set invisible_p [whos_online::user_invisible_p [ad_conn untrusted_user_id]]

set allowed_to_change_site_template_p [parameter::get -package_id $dotlrn_package_id -parameter "UserChangeSiteTemplate_p" -default 0]
set site_template_url [export_vars -base change-site-template {{referer $return_url}}]


# .LRN administration

set dotlrn_admin_p [dotlrn::admin_p]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

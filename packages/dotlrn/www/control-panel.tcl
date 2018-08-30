#
#  Copyright (C) 2001, 2002 MIT
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

ad_page_contract {

    My account page for a user.

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-11-10
    @version $Id: control-panel.tcl,v 1.16.4.1 2015/09/11 11:40:42 gustafn Exp $

}


# Make sure user is logged in
set user_id [auth::require_login]
acs_user::get -array user -include_bio -user_id $user_id

# General data
set dotlrn_url [dotlrn::get_url]
set dotlrn_package_id [dotlrn::get_package_id]

set return_url [ad_return_url]

set subsite_url [subsite::get_element -element url]

set pvt_home_url [ad_pvt_home]
set pvt_home_name [ad_pvt_home_name]

set system_owner [ad_system_owner]

# Page information
set doc(title) $pvt_home_name
set context [list $doc(title)]

# Get URLs for options

## Your account

set portrait_p [db_0or1row get_portrait_info {}] 
if { $portrait_p } {
    set portrait_image_src [export_vars -base "${subsite_url}shared/portrait-bits.tcl" { user_id item_id {size avatar}}]
    set portrait_url [export_vars -base "${subsite_url}user/portrait" { return_url }]
} else {
    set portrait_url [export_vars -base "${subsite_url}user/portrait/upload" { return_url }]
}

set user_info_template [parameter::get -package_id [ad_conn subsite_id] -parameter UserInfoTemplate -default "/packages/acs-subsite/lib/user-info"]

set community_member_url [acs_community_member_url -user_id $user_id]

set email_privacy_url "${subsite_url}user/email-privacy-level"
set change_password_url "${subsite_url}user/password-update"

set close_account_url "${subsite_url}pvt/unsubscribe"

## Preferences
set notifications_url [lindex [site_node::get_children -node_id [subsite::get_element -element node_id] -package_key "notifications"] 0]

set allowed_to_change_site_template_p [parameter::get -package_id $dotlrn_package_id -parameter "UserChangeSiteTemplate_p" -default 0]
set site_template_url [export_vars -base "change-site-template" {{referer $return_url}}]

set invisible_p [whos_online::user_invisible_p [ad_conn untrusted_user_id]]
set make_visible_url "${subsite_url}shared/make-visible"
set make_invisible_url "${subsite_url}shared/make-invisible"
set whos_online_url "${subsite_url}shared/whos-online"

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

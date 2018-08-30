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
    One user view by a dotLRN admin
    
    @author yon (yon@openforce.net)
    @creation-date 2002-03-13
    @version $Id: user.tcl,v 1.29.2.1 2015/09/11 11:40:53 gustafn Exp $
} {
    user_id:naturalnum,notnull
} -properties {
    context:onevalue
    first_names:onevalue
    last_name:onevalue
    email:onevalue
    screen_name:onevalue
    user_id:onevalue
    registration_date:onevalue
    last_visit:onevalue
    export_edit_vars:onevalue
    portrait_p:onevalue
    portrait_title:onevalue
    change_state_links:onevalue
    return_url:onevalue
    dotlrn_user_p:onevalue
    member_classes:multirow
    member_clubs:multirow
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set return_url "[parameter::get -package_id [ad_acs_kernel_id] -parameter CommunityMemberAdminURL]?user_id=$user_id"
set export_edit_vars [export_vars {user_id return_url}]

set dotlrn_url [dotlrn::get_url]
set root_object_id [acs_magic_object security_context_root]
if {![db_0or1row select_user_info {}]} {
    ad_return_complaint 1 "<li>[_ dotlrn.couldnt_find_user_id [list user_id $user_id]]</li>"
    ad_script_abort
}
if {$screen_name eq ""} {
    set screen_name "([_ dotlrn.none_set_up])"
}
set registration_date [lc_time_fmt $registration_date "%q"]
if {$last_visit ne ""} {
    set last_visit [lc_time_fmt $last_visit "%q"]
}

set dotlrn_package_id [dotlrn::get_package_id]
set dotlrn_user_p 0
if {[db_0or1row select_dotlrn_user_info {}]} {
    set dotlrn_user_p 1
}

# dotlrn Access level
if { [dotlrn::user_can_browse_p -user_id $user_id] } {
    set browse_label [_ dotlrn.Full]
    set browse_toggle_url [export_vars -base "browse-toggle" {user_id {can_browse_p 0} {referer $return_url}}]
    set browse_toggle_label [_ dotlrn.Limited]
} else {
    set browse_label [_ dotlrn.Limited]
    set browse_toggle_url [export_vars -base "browse-toggle" {user_id {can_browse_p 1} {referer $return_url}}]
    set browse_toggle_label [_ dotlrn.Full]
}

# dotlrn Guest status
if { ![info exists guest_p] } {
    set guest_p 0
}

if { $guest_p } {
    set guest_label [_ dotlrn.Yes]
    set guest_toggle_url [export_vars -base "guest-toggle" {user_id {guest_p f} {referer $return_url}}]
    set guest_toggle_label [_ dotlrn.No]
} else {
    set guest_label [_ dotlrn.No]
    set guest_toggle_url [export_vars -base "guest-toggle" {user_id {guest_p t} {referer $return_url}}]
    set guest_toggle_label [_ dotlrn.Yes]
}

set portrait_p 0
if {[parameter::get -parameter "show_portrait_p"] && [db_0or1row select_portrait_info {}]} {
    set portrait_p 1
}

template::multirow create change_state_links url label
foreach elm [ad_registration_finite_state_machine_admin_links -nohtml -- $member_state $email_verified_p $user_id $return_url] {
    template::multirow append change_state_links [lindex $elm 0] [lindex $elm 1]
}

db_multirow member_classes select_member_classes {} {
    set role_pretty_name [dotlrn_community::get_role_pretty_name -community_id $class_instance_id -rel_type $rel_type]
}
db_multirow member_clubs select_member_clubs {} {
    set role_pretty_name [dotlrn_community::get_role_pretty_name -community_id $club_id -rel_type $rel_type]
}
db_multirow member_subgroups select_member_subgroups {} {
    set role_pretty_name [dotlrn_community::get_role_pretty_name -community_id $community_id -rel_type $rel_type]
}

set site_wide_admin_p [acs_user::site_wide_admin_p]
# ER: this is silly, user has to be at least dotlrn admin to get 
# to this page and dotlrn admin right is checked above
set dotlrn_admin_p [dotlrn::admin_p]

set administrative_action_p [expr {$site_wide_admin_p || $dotlrn_admin_p}]

set doc(title) "$first_names $last_name"
set context [list [list users [_ dotlrn.Users]] $doc(title)]

set dual_approve_return_url [export_vars -base "[dotlrn::get_admin_url]/user-new-2" {user_id {referer $return_url}}]

set approve_user_url [export_vars -base "/acs-admin/users/member-state-change" {user_id {member_state approved} {return_url $dual_approve_return_url}}]

set remove_user_url [export_vars -base user-nuke {user_id}]

set add_to_comm_url [export_vars -base "users-add-to-community" {{users $user_id} {referer $return_url}}]
set add_to_dotlrn_url [export_vars -base "user-new-2" {user_id {referer $return_url}}]

# Used in some en_US messages in the adp file
set class_instances_pretty_name [parameter::get -localize -parameter class_instances_pretty_name]
set clubs_pretty_name [parameter::get -localize -parameter clubs_pretty_name]
set subcommunities_pretty_name [parameter::get -localize -parameter subcommunities_pretty_name]

if { [acs_user::site_wide_admin_p -user_id $user_id] } {
    set toggle_value revoke
    set toggle_text [_ dotlrn.Revoke_site_wide_admin]
} else {
    set toggle_value grant
    set toggle_text [_ dotlrn.Grant_site_wide_admin]
}
set toggle_swa_url [export_vars -base "site-wide-admin-toggle" {user_id {value $toggle_value} {referer $return_url}}]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

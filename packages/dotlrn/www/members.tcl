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

    @author nimam (mazloumi@uni-mannheim.de)
    @creation-date Oct 05, 2004
    @version $Id: members.tcl,v 1.34.2.2 2016/09/28 10:17:59 gustafn Exp $

} {
    {orderby:token,optional "last_name,asc"}
    {csv:optional}
    {reset:optional}
    {reltype:optional}
}

set my_user_id [ad_conn user_id]
set context [list [list "one-community-admin" [_ dotlrn.Admin]] [_ dotlrn.Manage_Members]]
set community_id [dotlrn_community::get_community_id]
set spam_p [dotlrn::user_can_spam_community_p -user_id [ad_conn user_id] -community_id $community_id]
set approval_policy_p [string equal [group::join_policy -group_id $community_id] "needs approval"]
set subcomm_p [dotlrn_community::subcommunity_p -community_id $community_id]

set referer [ns_conn url]
set return_url "[ns_conn url]?[ns_conn query]"

set csv_p [expr {[info exists csv] && $csv ne ""}]

set site_wide_admin_p [permission::permission_p -object_id [acs_magic_object security_context_root]  -privilege admin]

if {!$site_wide_admin_p} {
    set admin_p [dotlrn::user_can_admin_community_p -user_id $my_user_id -community_id $community_id]
} else {
    set admin_p 1
}

if {(![info exists referer] || $referer eq "")} {
    if {$admin_p == "t"} {
        set referer "one-community-admin"
    } else {
        set referer "one-community"
    }
}

# Actions for Removing Members according to their role
set rel_types [dotlrn_community::get_roles -community_id $community_id]

set bulk_actions ""
set bulk_actions_export_vars ""
set actions ""

if {$admin_p && !$csv_p} {
    set bulk_actions [list "[_ dotlrn.Drop_Membership]" "deregister" "[_ dotlrn.Drop_Membership]"]
    set bulk_actions_export_vars [list "user_id" "referer" "reset"]

    if { !$subcomm_p } {
        lappend actions \
            [_ dotlrn.Create_and_add_a_member] \
            [export_vars -base user-add { {can_browse_p 1} {read_private_data_p t} {referer $return_url} }] \
            [_ dotlrn.Create_and_add_a_member]
    }

    if { $spam_p } {
        lappend actions [_ dotlrn.Email_Members] [export_vars -base "spam-recipients" {community_id}] [_ dotlrn.Email_Members]
    }

    lappend actions "CSV" "members?csv=yes" [_ dotlrn.Export_members_list_to_CSV]

    foreach role $rel_types {
        set action_label "[_ dotlrn.Remove_all] [lang::util::localize [lindex $role 3]]" 
        lappend actions  $action_label "member-confirm?reset=1&reltype=[lindex $role 0]" $action_label
    }
}

# Set the elements list
set elm_list {
    portrait {
        label ""
        html "align right"
        display_template {
            <if @members.portrait_p@ true>
              <a href="@members.member_url@" title="#acs-subsite.lt_User_has_portrait_title#">
                <img src="/resources/acs-subsite/profile-16.png" height="16" width="16" alt="#acs-subsite.Profile#" style="border:0">
              </a>
            </if>
        }
        hide_p $csv_p
    } last_name {
        label "[_ acs-subsite.Last_name]"
        html "align left"
        link_url_col member_url
    } first_names {
        label "[_ acs-subsite.First_names]"
        html "align left"
        link_url_col member_url
    } email {
        label "[_ dotlrn.Email_1]"
        html "align left"
        display_template {@members.email_pretty;noquote@}
    } role {
        label "[_ dotlrn.Role]"
        html "align left"
    } 
}

if {$admin_p && !$csv_p} {
    lappend elm_list {action} {
        label "[_ dotlrn.Actions]"
        html "align left"
        display_template {
            <if @members.user_id@ ne \"\">
            <a href="member-confirm?user_id=@members.user_id@&amp;referer=@members.member_referer@">#dotlrn.Drop_Membership#</a> | 
            <a href="member-add-2?user_id=@members.user_id@&amp;referer=@members.member_referer@">#dotlrn.User_Admin_Page#</a>
            </if>
        }
    }
}

# Build the list-builder list
template::list::create \
    -name members \
    -multirow members \
    -key user_id \
    -actions $actions \
    -bulk_actions $bulk_actions \
    -bulk_action_export_vars $bulk_actions_export_vars \
    -elements $elm_list -orderby {
        last_name {orderby last_name}
        first_names {orderby first_names}
        email {orderby email}
        role {orderby role}
    } -selected_format csv -formats {
        csv { output csv }
    }

set orderby [template::list::orderby_clause -name "members" -orderby]

set member_page [acs_community_member_page]

db_multirow -extend { member_url member_referer email_pretty } members select_current_members {} {
    set email_pretty [email_image::get_user_email -user_id $user_id -return_url $return_url]

    set member_url "$member_page?user_id=$user_id"
    set member_referer $referer

    set role [dotlrn_community::get_role_pretty_name -community_id $community_id -rel_type $rel_type]
}

if { $csv_p } {
    template::list::write_output -name members
}

set user_ids ""
db_multirow -extend { member_url pending_user_referer } pending_users select_pending_users {} {
    set role [dotlrn_community::get_role_pretty_name -community_id $community_id -rel_type $rel_type]
    append user_ids "user_id=$user_id&"
    set email [email_image::get_user_email -user_id $user_id -return_url $return_url]
    set member_url "$member_page?user_id=$user_id"
    set pending_user_referer $referer
}


if {$admin_p} {
    if { [template::multirow size pending_users] > 0 } {
        set pend_actions [list "[_ dotlrn.Approve_all]" "approve?${user_ids}referer=$referer" "[_ dotlrn.Approve_all]" \
                              "[_ dotlrn.Reject_all]" "reject?${user_ids}referer=$referer" "[_ dotlrn.Reject_all]"]
    } else {
        set pend_actions ""
    }
} else {
    set pend_actions ""
}

template::list::create -name pending_users -multirow pending_users -key user_id -actions $pend_actions -elements {
    last_name {
        label "[_ acs-subsite.Last_name]"
        html "align left"
        link_url_col member_url
    } first_names {
        label "[_ acs-subsite.First_names]"
        html "align left"
        link_url_col member_url
    } email {
        label "[_ dotlrn.Email_1]"
        html "align left"
        display_template {@pending_users.email;noquote@}
    } role {
        label "[_ dotlrn.Role]"
        html "align left"
    } action {
        label "[_ dotlrn.Actions]"
        html "align left"
        display_template {
            <a href="approve?user_id=@pending_users.user_id@&amp;referer=@pending_users.pending_user_referer@">#dotlrn.Approve#</a> |
            <a href="reject?user_id=@pending_users.user_id@&amp;referer=@pending_users.pending_user_referer@">#dotlrn.Reject#</a>
        }
    }
}

if {$subcomm_p} {

    form create parent_users_form

    set parent_user_list [dotlrn_community::list_possible_subcomm_users -subcomm_id $community_id]
    set n_parent_users [llength $parent_user_list]

    foreach user $parent_user_list {
        element create parent_users_form "selected_user.[ns_set get $user user_id]" -datatype text -widget radio -options {{{} none} {{} dotlrn_member_rel} {{} dotlrn_admin_rel}} -value none
    }

    if {[form is_valid parent_users_form]} {
        set user_ids_to_email [list]
        foreach user $parent_user_list {
            set rel [element get_value parent_users_form "selected_user.[ns_set get $user user_id]"]

            if {![string match $rel none]} {
                dotlrn_community::add_user -rel_type $rel $community_id [ns_set get $user user_id]
                lappend user_ids_to_email [ns_set get $user user_id]
            }
        }
        if {[llength $user_ids_to_email]} {
            set return_url [export_vars -base member-email-confirm {{user_id $user_ids_to_email} community_id}]
        } else {
            set return_url [ns_conn url]
        }
        ad_returnredirect $return_url
    }

}

if {([info exists reset] && $reset ne "") && ([info exists reltype] && $reltype ne "")} {
    set result ""
    db_multirow reset_members select_members {} {
        rp_form_put user_id $member_id
    }
    rp_form_put referer "one-community"
    rp_form_put community_id $community_id
    rp_internal_redirect "deregister"
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

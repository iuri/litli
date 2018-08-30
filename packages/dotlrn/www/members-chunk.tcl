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

# dotlrn/www/members-chunk.tcl

ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date Jan 08, 2002
    @version $Id: members-chunk.tcl,v 1.22.4.1 2015/09/11 11:40:45 gustafn Exp $
} -query {
    parent_user_role:multiple,array,optional
} -properties {
    users:multirow
    n_parent_users:onevalue
}

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]

set referer [ns_conn url]

set site_wide_admin_p [permission::permission_p -party_id $user_id -object_id [acs_magic_object "security_context_root"] -privilege "admin"]
if {!$site_wide_admin_p} {
    set admin_p [dotlrn::user_can_admin_community_p -user_id $user_id -community_id $community_id]
    set read_private_data_p [dotlrn::user_can_read_private_data_p -user_id $user_id -object_id $community_id]
} else {
    set admin_p 1
    set read_private_data_p 1
}

if {(![info exists referer] || $referer eq "")} {
    if {$admin_p == "t"} {
        set referer "one-community-admin"
    } else {
        set referer "one-community"
    }
}

# Used in I18N message lookups in adp
set parent_community_name [dotlrn_community::get_parent_name -community_id $community_id]
set community_name [dotlrn_community::get_community_name $community_id]

# Get all users for this community, including role
set community_members [dotlrn_community::list_users $community_id]

template::util::list_of_ns_sets_to_multirow \
    -rows $community_members \
    -var_name "users"

set user_list [list]
foreach user $community_members {
    lappend user_list [ns_set get $user user_id]
}

db_multirow pending_users select_pending_users {
    select dotlrn_users.*,
           dotlrn_member_rels_full.rel_type,
           dotlrn_member_rels_full.role
    from dotlrn_users,
         dotlrn_member_rels_full
    where dotlrn_users.user_id = dotlrn_member_rels_full.user_id
    and dotlrn_member_rels_full.community_id = :community_id
    and dotlrn_member_rels_full.member_state = 'needs approval'
}

# If we are in a subcomm. get the list of the users of the parent
# comm that are not in the subcomm yet, and output them with radios
# for roles, etc.
set subcomm_p [dotlrn_community::subcommunity_p -community_id $community_id]

if {$subcomm_p} {

    form create parent_users_form

    element create parent_users_form selected_users \
        -label "&nbsp;" \
        -datatype text \
        -widget checkbox \
        -optional

    set parent_user_list [dotlrn_community::list_possible_subcomm_users -subcomm_id $community_id]
    set n_parent_users [llength $parent_user_list]

    if {[form is_valid parent_users_form]} {
        set selected_users [element get_values parent_users_form selected_users]
	set user_ids_to_email [list]
        foreach selected_user $selected_users {
            dotlrn_community::add_user -rel_type $parent_user_role($selected_user) $community_id $selected_user
	    lappend user_ids_to_email $selected_user
        }
	if {[llength $user_ids_to_email]} {
	    set return_url [export_vars -base member-email-confirm {{user_id $user_ids_to_email} community_id}]
	} else {
	    set return_url [ns_conn url]
	}
        ad_returnredirect $return_url
    }

    set selected_users_options [list]

    foreach user $parent_user_list {
        lappend selected_users_options [list "<table width=\"100%\" border=\"0\"><tr><td width=\"15%\" align=\"center\"><input type=\"radio\" name=\"parent_user_role.[ns_set get $user user_id]\" value=\"dotlrn_member_rel\" checked></td><td width=\"15%\" align=\"center\"><input type=\"radio\" name=\"parent_user_role.[ns_set get $user user_id]\" value=\"dotlrn_admin_rel\"></td><td>[ns_set get $user last_name], [ns_set get $user first_names] ([ns_set get $user email])</td></tr></table>" [ns_set get $user user_id]]
    }

    element set_properties parent_users_form selected_users -options $selected_users_options

}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

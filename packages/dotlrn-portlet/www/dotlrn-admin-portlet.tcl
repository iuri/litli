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


# www/dotlrn-admin-portlet.tcl
ad_page_contract {
    The display logic for the dotlrn admin portlet. This shows the
    "Group Administration" section of the group admin page.

    @author Arjun Sanyal (arjun@openforce.net)
    @author Ben Adida (ben@openforce)
    @cvs_id $Id: dotlrn-admin-portlet.tcl,v 1.19.2.1 2015/09/11 11:41:00 gustafn Exp $
} -properties {
}

# get some basics
array set config $cf
set community_id $config(community_id)
set dotlrn_admin_p [dotlrn::admin_p]
set dotlrn_admin_url "[dotlrn::get_url]/admin"
set sub_pretty_name [parameter::get -localize -parameter subcommunities_pretty_name]
set sub_pretty_plural [parameter::get -localize -parameter subcommunities_pretty_plural]
set admin_pretty_name [parameter::get -localize -parameter dotlrn_admin_pretty_name]
set subcommunity_p [dotlrn_community::subcommunity_p -community_id $community_id]

#The community_type is dotlrn_club for "communties" and the subject name for classes.
set comm_type [dotlrn_community::get_community_type_from_community_id $community_id]

#Checking group admin parameters
set manage_membership_p [parameter::get_from_package_key \
                                    -package_key dotlrn-portlet \
			            -parameter AllowManageMembership]

set enrollment_policy_p [parameter::get_from_package_key \
			            -package_key dotlrn-portlet \
			            -parameter AllowChangeEnrollmentPolicy]

set customize_portal_layout_p [parameter::get_from_package_key \
                                    -package_key dotlrn-portlet \
				    -parameter AllowCustomizePortalLayout]

set create_limited_user_p [parameter::get_from_package_key \
                                   -package_key dotlrn-portlet \
			           -parameter AllowCreateLimitedUsersInCommunity]

set create_guest_user_p [parameter::get_from_package_key \
                                   -package_key dotlrn-portlet \
			           -parameter AllowCreateGuestUsersInCommunity]  

set manage_applets_p [parameter::get_from_package_key \
                                   -package_key dotlrn-portlet \
			           -parameter AllowManageApplets]

if {$comm_type != [dotlrn_class::community_type]} {
    set club_p 1
} else {
    set club_p 0
    set term_name "[dotlrn_class::get_term_name -class_instance_id $community_id] [dotlrn_class::get_term_year -class_instance_id $community_id]"
}

set members_rel_id [dotlrn_community::get_members_rel_id -community_id $community_id]
set members_can_spam_p [permission::permission_p -party_id $members_rel_id -object_id $community_id -privilege dotlrn_spam_community]

# get the community info
db_1row select_community_info {}

# get Guest policy info
set guests_can_view_private_data_p [dotlrn_privacy::guests_can_view_private_data_p -object_id $community_id]

# get the subcomm info
set rows [dotlrn_community::get_subcomm_info_list -community_id $community_id]
template::util::list_of_ns_sets_to_multirow -rows $rows -var_name subgroups

# get member email notification
db_0or1row member_email {
    select
      enabled_p as member_email_enabled_p
    from
      dotlrn_member_emails
    where
      community_id = :community_id and
      type = 'on join'
}

set referer [ns_conn url]

set limited_user_add_url [export_vars -base user-add {{type student} {can_browse_p 0} {read_private_data_p t}}]
set club_limited_user_add_url [export_vars -base user-add {{type student} {can_browse_p 0} {read_private_data_p f}}]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

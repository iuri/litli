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
    Search for a new user for dotLRN

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-11-04
    @version $Id: member-add-2.tcl,v 1.16.4.2 2017/01/26 11:46:02 gustafn Exp $
} -query {
    user_id:naturalnum,notnull
    {referer "one-community-admin"}
} -properties {
    roles:multirow
}

#prevent to add new student, only admins can do this.
# parameter  AllowManageMembership 

set doc(title) [_ dotlrn.Add_A_Member]
set context [list [list "one-community-admin" [_ dotlrn.Admin]] $doc(title)]

set allowed_to_add_student [parameter::get_from_package_key \
                                       -package_key dotlrn-portlet \
				       -parameter AllowManageMembership]

set dotlrn_admin [dotlrn::admin_p]
 
set community_id [dotlrn_community::get_community_id]

dotlrn::require_user_admin_community -community_id $community_id

# Get user information
db_1row select_user_info {
    select first_names,
           last_name,
           email
    from dotlrn_users
    where user_id = :user_id
}

set community_name [dotlrn_community::get_community_name $community_id]

# See if the user is already in the group
set member_p [dotlrn_community::member_p $community_id $user_id]

if {$member_p} {
    set existing_role [dotlrn_community::get_role_pretty_name -community_id $community_id -rel_type [db_string select_role {}]]
    if {$existing_role eq ""} {
	set existing_role "member"
    }
}
            
# Depending on the community_type, we have allowable rel_types
set rel_types [dotlrn_community::get_roles -community_id $community_id]

template::multirow create roles rel_type pretty_name

foreach role $rel_types {
    template::multirow append roles [lindex $role 0] [lindex $role 2]
}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

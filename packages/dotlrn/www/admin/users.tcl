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
    Displays the admin users page

    @author yon (yon@openforce.net)
    @creation-date 2002-01-30
    @version $Id: users.tcl,v 1.23.4.1 2015/09/11 11:40:55 gustafn Exp $
} -query {
    {type "pending"}
} -properties {
    context_bar:onevalue
    control_bar:onevalue
    n_users:onevalue
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set context_bar [_ dotlrn.Users]

set dotlrn_roles [db_list_of_lists select_dotlrn_roles {
    select dotlrn_user_types.type,
           dotlrn_user_types.pretty_name || ' (' || (select count(*)
                                                     from dotlrn_users
                                                     where dotlrn_users.type = dotlrn_user_types.type) || ')',
           ''
    from dotlrn_user_types
    order by dotlrn_user_types.pretty_name
}]

# The roles are stored as message keys in the database so we need to localize them
# on the fly here
set dotlrn_roles_localized [list]
foreach role_pair $dotlrn_roles {
    lappend dotlrn_roles_localized [list [lindex $role_pair 0] [lang::util::localize [lindex $role_pair 1]]]
}

set n_pending_users [db_string select_non_dotlrn_users_count {}]
lappend dotlrn_roles_localized [list pending "[_ dotlrn.Pending] ($n_pending_users)" {}]

set n_deactivated_users [db_string select_deactivated_users_count {}]
lappend dotlrn_roles_localized [list deactivated "[_ dotlrn.Deactivated] ($n_deactivated_users)" {}]

set control_bar [ad_dimensional [list [list type "[_ dotlrn.User_Type]:" $type $dotlrn_roles_localized]]]

if {$type eq "deactivated"} {
    set n_users $n_deactivated_users
} elseif {$type eq "pending"} {
    set n_users $n_pending_users
} else {
    set n_users [db_string select_dotlrn_users_count {}]
}
set referer [ad_return_url]
set add_user_url [export_vars -base "../user-add" {{add_membership_p f} {dotlrn_interactive_p 1} referer}]
ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

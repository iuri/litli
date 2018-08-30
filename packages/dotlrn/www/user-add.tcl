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

# dotlrn/www/user-add.tcl

ad_page_contract {
    adding a user by an administrator

    @author yon (yon@openforce.net)
    @creation-date 2002-01-19
    @version $Id: user-add.tcl,v 1.35.4.2 2017/01/26 11:46:02 gustafn Exp $
} -query {
    {type student}
    {can_browse_p:boolean 0}
    {read_private_data_p:boolean f}
    {add_membership_p:boolean t}
    {dotlrn_interactive_p:boolean 0}
    {referer members}
} -properties {
    context_bar:onevalue
}

#prevent this page from being called when it is not allowed
# i.e.   AllowCreateGuestUsersInCommunity 0
dotlrn_portlet::is_allowed -parameter guestuser
dotlrn_portlet::is_allowed -parameter limiteduser

# Set read_private_data_p and can_browse_p to me the most restrictive defaults.

set current_user_id [auth::require_login]
set community_id [dotlrn_community::get_community_id]

# If can_browse_p is 1, this means the new user would be able to join 
# all communities. 
    
if {$community_id ne ""} {
    dotlrn::require_user_admin_community -community_id [dotlrn_community::get_community_id]
    set context [list [list "one-community-admin" [_ dotlrn.Admin]] [_ dotlrn.Add_User]]
    set community_p 1
} else {
    dotlrn::require_admin
    set context [list [list users [_ dotlrn.Users]] [_ dotlrn.Add_User]]
    set community_p 0
}

# Export dotlrn-specific vars in the next_url
set next_url [export_vars -base user-add-2 {type can_browse_p read_private_data_p add_membership_p dotlrn_interactive_p referer}]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

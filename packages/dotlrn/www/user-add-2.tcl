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
    Processes a new user created by an admin

    @author yon (yon@openforce.net)
    @creation-date 2002-01-20
    @version $Id: user-add-2.tcl,v 1.16.2.2 2017/01/26 11:46:02 gustafn Exp $
} -query {
    user_id:naturalnum,notnull
    password
    {referer "/acs-admin/users"}
    type
    can_browse_p:boolean
    read_private_data_p:boolean
    dotlrn_interactive_p:boolean
    add_membership_p:boolean
} -properties {
    context_bar:onevalue
    export_vars:onevalue
    system_name:onevalue
    system_url:onevalue
    first_names:onevalue
    last_name:onevalue
    email:onevalue
    id:onevalue
    password:onevalue
    administration_name:onevalue
}

#prevent this page from being called when it is not allowed
# i.e.   AllowCreateGuestUsersInCommunity 0
dotlrn_portlet::is_allowed -parameter guestuser
dotlrn_portlet::is_allowed -parameter limiteduser

# Get user info
acs_user::get -user_id $user_id -array user
# easier to work with scalar vars than array
foreach var_name [array names user] {
    set $var_name $user($var_name)
}

set dotlrn_user_p [dotlrn::user_p -user_id $user_id]

if {!$dotlrn_user_p} {
    db_transaction {
        # can this user read private data?
        dotlrn_privacy::set_user_is_non_guest -user_id $user_id -value $read_private_data_p

        if {!${dotlrn_interactive_p}} {
            # make the user a dotLRN user
            dotlrn::user_add -type $type -can_browse\=$can_browse_p -user_id $user_id
        }
    }
}

set redirect [export_vars -base user-add-2 {user_id password referer type can_browse_p read_private_data_p dotlrn_interactive_p add_membership_p}]
if { $add_membership_p == "t" && $referer eq "/acs-admin/users" } {
    set redirect "one-community-admin"
} else {
    set redirect $referer
}

# Don't redirect back to the user-new-2 page if we've already been there
if {${dotlrn_interactive_p} && !$dotlrn_user_p} {
    # set redirect "../${redirect}"
    ad_returnredirect [export_vars -base admin/user-new-2 {user_id {referer $redirect}}]
    ad_script_abort
} elseif {$add_membership_p == "t"} {
    ad_returnredirect [export_vars -base member-add-2 {user_id {referer $redirect}}]
    ad_script_abort
}

set context_bar [list [list "one-community-admin" [_ dotlrn.Admin]] [_ dotlrn.Add_User]]

set admin_user_id [ad_conn user_id]
set administration_name [db_string select_admin_name {
    select first_names || ' ' || last_name
    from persons
    where person_id = :admin_user_id
}]

set system_name [ad_system_name]
set export_vars [export_vars -form {email referer type can_browse_p read_private_data_p dotlrn_interactive_p add_membership_p}]
set system_url [parameter::get -package_id [ad_acs_kernel_id] -parameter SystemURL -default ""]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

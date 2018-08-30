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

# dotlrn/www/admin/users-delete.tcl

ad_page_contract {
    Nuke a set of users.

    @author yon (yon@openforce.net)
    @creation-date 2002-02-14
    @version $Id: users-delete.tcl,v 1.8.10.1 2015/09/11 11:40:54 gustafn Exp $
} -query {
    users
    {referer "users-search"}
} -properties {
    context_bar:onevalue
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set context_bar [list [list users [_ dotlrn.Users]] [list users-search [_ dotlrn.User_Search]] [_ dotlrn.Nuke_Users]]

form create confirm_delete

element create confirm_delete users \
    -label "&nbsp;" \
    -datatype text \
    -widget hidden \
    -value $users

element create confirm_delete referer \
    -label "&nbsp;" \
    -datatype text \
    -widget hidden \
    -value $referer

if {[form is_valid confirm_delete]} {
    form get_values confirm_delete \
        users

    dotlrn::remove_users_completely -users $users

    ad_returnredirect $referer
    ad_script_abort
}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

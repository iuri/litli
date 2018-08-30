
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
    Edit a dotLRN user

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-12-10
    @version $Id: user-edit.tcl,v 1.23.10.2 2017/01/26 11:46:02 gustafn Exp $
} -query {
    {return_url:localurl "[dotlrn::get_admin_url]/users"}
    user_id:naturalnum,notnull
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set context_bar [list [list users [_ dotlrn.Users]] [_ dotlrn.Edit]]
set dotlrn_package_id [dotlrn::get_package_id]

db_1row select_user_info {}
set can_browse_p [dotlrn::user_can_browse_p -user_id $user_id]

form create edit_user

element create edit_user user_id \
    -label "[_ dotlrn.User_ID_1]" \
    -datatype integer \
    -widget hidden \
    -value $user_id

element create edit_user id \
    -label [_ dotlrn.ID_1] \
    -datatype text \
    -widget text \
    -html {size 30} \
    -value $id \
    -optional

element create edit_user type \
    -label "[_ dotlrn.User_Type]" \
    -datatype text \
    -widget select \
    -options [dotlrn::get_user_types_as_options] \
    -value $type

element create edit_user can_browse_p \
    -label "[_ dotlrn.Access_Level]" \
    -datatype text \
    -widget select \
    -options [list [list [_ dotlrn.Full] 1] [list [_ dotlrn.Limited] 0]] \
    -value $can_browse_p

element create edit_user guest_p \
    -label "[_ dotlrn.Guest_1]" \
    -datatype text \
    -widget select \
    -options [list [list [_ dotlrn.No] f] [list [_ dotlrn.Yes] t]] \
    -value $guest_p

element create edit_user return_url \
    -label "[_ dotlrn.Return_URL]" \
    -datatype text \
    -widget hidden \
    -value $return_url

if {[form is_valid edit_user]} {
    form get_values edit_user \
        user_id id type can_browse_p guest_p return_url

    db_transaction {
        # remove the user
        dotlrn::user_remove -user_id $user_id

        # add the user
        dotlrn::user_add \
            -id $id \
            -type $type \
            -can_browse\=$can_browse_p \
            -user_id $user_id

        # Update permissions
        dotlrn_privacy::set_user_guest_p \
            -user_id $user_id \
            -value $guest_p
    }

    # redirect
    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

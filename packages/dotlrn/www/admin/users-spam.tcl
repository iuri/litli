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

# dotlrn/www/admin/users-spam.tcl

ad_page_contract {
    Spam a set of users.

    @author yon (yon@openforce.net)
    @creation-date 2002-02-14
    @version $Id: users-spam.tcl,v 1.7.8.2 2017/04/21 20:45:16 gustafn Exp $
} -query {
    users
    {referer "users-search"}
} -properties {
    context_bar:onevalue
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set context_bar [list [list users [_ dotlrn.Users]] [list users-search [_ dotlrn.User_Search]] [_ dotlrn.Spam_Users]]

set sender_id [ad_conn user_id]

db_1row select_sender_info {
    select parties.email as sender_email,
           persons.first_names as sender_first_names,
           persons.last_name as sender_last_name
    from parties,
         persons
    where parties.party_id = :sender_id
    and persons.person_id = :sender_id
}

form create spam_message

element create spam_message users \
    -label "&nbsp;" \
    -datatype text \
    -widget hidden \
    -value $users

element create spam_message from \
    -label [_ dotlrn.From] \
    -datatype text \
    -widget text \
    -html {size 60} \
    -value $sender_email

element create spam_message subject \
    -label [_ dotlrn.Subject] \
    -datatype text \
    -widget text \
    -html {size 60}

element create spam_message message \
    -label [_ dotlrn.Message] \
    -datatype text \
    -widget textarea \
    -html {rows 10 cols 80}

element create spam_message referer \
    -label [_ dotlrn.Referer] \
    -datatype text \
    -widget hidden \
    -value $referer

if {[form is_valid spam_message]} {
    form get_values spam_message \
        users from subject message referer

    # YON: should redirect and close the connection here so that the user
    #      doesn't have to wait for the emails to get sent out.

    set message_values [list]
    lappend message_values [list {<sender_email>} $from]

    spam::send \
        -recipients $users \
        -from $from \
        -real_from $sender_email \
        -subject $subject \
        -message $message \
        -message_values $message_values

    ad_returnredirect $referer
    ad_script_abort
}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

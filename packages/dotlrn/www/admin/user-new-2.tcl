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
    Create a dotLRN user

    @author Ben Adida (ben@openforce.net)
    @creation-date 2001-11-04
    @version $Id: user-new-2.tcl,v 1.36.4.2 2015/09/11 11:40:53 gustafn Exp $
} -query {
    user_id:naturalnum
    {referer "[dotlrn::get_admin_url]/users" }
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set context_bar [list [list users [_ dotlrn.Users]] [_ dotlrn.New]]

db_1row select_user_info {
    select email,
    first_names,
    last_name
    from registered_users
    where user_id = :user_id
}

form create add_user

element create add_user user_id \
    -label "[_ dotlrn.User_ID_1]" \
    -datatype integer \
    -widget hidden \
    -value $user_id

element create add_user id \
    -label [_ dotlrn.ID_1] \
    -datatype text \
    -widget text \
    -html {size 30} \
    -value $email \
    -optional

element create add_user type \
    -label "[_ dotlrn.User_Type]" \
    -datatype text \
    -widget select \
    -options [dotlrn::get_user_types_as_options]

element create add_user can_browse_p \
    -label "[_ dotlrn.Access_Level]" \
    -datatype text \
    -widget select \
    -options [list [list "[_ dotlrn.Full_Access]" 1] [list "[_ dotlrn.Limited_Access]" 0]]

element create add_user guest_p \
    -label "[_ dotlrn.Guest_1]" \
    -datatype text \
    -widget select \
    -options [list [list [_ dotlrn.No] f] [list [_ dotlrn.Yes] t]]

element create add_user referer \
    -label [_ dotlrn.Referer] \
    -datatype text \
    -widget hidden \
    -value $referer


if {[form is_valid add_user]} {

    form get_values add_user \
        user_id id type can_browse_p guest_p referer

    set subject "Your [ad_system_name] membership has been approved"
    set message "Your [ad_system_name] membership has been approved. Please return to [ad_url] to log into [ad_system_name]."

    set email_from [parameter::get -package_id [ad_acs_kernel_id] -parameter SystemOwner]

    db_transaction {

        dotlrn::user_add \
            -id $id \
            -type $type \
            -can_browse\=$can_browse_p \
            -user_id $user_id

        dotlrn_privacy::set_user_guest_p \
            -user_id $user_id \
            -value $guest_p
    }
    
    
    if {[catch {acs_mail_lite::send -send_immediately -to_addr $email -from_addr $email_from -subject $subject -body $message} errmsg]} {
        
        ns_log Error "Error sending email from user-new-2.tcl" $errmsg
        ad_return_error \
            "Error sending mail" \
            "There was an error sending email to $email."
    } else {

        set admin_subject "The following email was just sent from [ad_system_name]"

        set admin_message "The following email was just sent from [ad_system_name]

Sent by: $email_from
Sent to: $email
Subject: $subject
Message: $message"


        if {[catch {acs_mail_lite::send -send_immediately -to_addr $email_from -from_addr $email_from -subject $admin_subject -body $admin_message} errmsg]} {
            
            ns_log Error "Error sending email from user-new-2.tcl" $errmsg
            ad_return_error \
                "Error sending mail" \
                "There was an error sending email to $email."
        }

    }

    ad_returnredirect $referer
    ad_script_abort
}

set context_bar [list [list users [_ dotlrn.Users]] [_ dotlrn.New]]

ad_return_template




# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

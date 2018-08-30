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
    Process the upload

    @author ben (ben@openforce.net)
    @creation-date 2002-03-05
    @version $Id: users-bulk-upload-2.tcl,v 1.25.2.2 2016/09/12 11:16:15 gustafn Exp $
}

set context [list [list users [_ dotlrn.Users]] [_ dotlrn.Bulk_Upload]]

# Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

# get location of the file
set file_location [ns_queryget users_csv_file.tmpfile]

# Prepare stuff
set headers {first_names last_name email username}

set admin_user_id [ad_conn user_id]
set admin_email [db_string select_admin_email {
    select email
    from parties
    where party_id = :admin_user_id
}]

append body "[_ dotlrn.Bulk_Uploading]<p>"

set list_of_user_ids [list]
set list_of_addresses_and_passwords [list]

set fail_p 0

# Do the stuff
# We can't do this too generically, so we'll just do the CSV stuff right here
db_transaction {

    oacs_util::csv_foreach -file $file_location -array_name row {

        # First make sure the required data is there
        if { ![info exists row(email)] || ![info exists row(first_names)] || ![info exists row(last_name)] } {
            append body [_ dotlrn.datafile_must]
            db_abort_transaction
            return
        }

        ns_log Debug "%%% $row(email)"

        # We need to insert the ACS user
        if {![info exists row(password)] || $row(password) eq ""} {

            # We need to insert the ACS user
            set password [ad_generate_random_string]
        } else {
            set password $row(password)
        }
 
        # Check if this user already exists
        set user_id [party::get_by_email -email $row(email)]
        if { $user_id ne "" } {
            append body [_ dotlrn.user_email_already_exists [list user_email $row(email)]]
            lappend list_of_user_ids $user_id
        } else {

            if {![info exists row(type)] || $row(type) eq ""} {
                set row(type) student
            }
            
            if {![info exists row(access_level)] || $row(access_level) eq ""} {
                set row(access_level) full
            }
            
            if {![info exists row(guest)] || $row(guest) eq ""} {
                set row(guest) f
            }

            if {![info exists row(username)] || $row(username) eq ""} {
                set row(username) $row(email)
            }
            
            if {![info exists row(notify)] || $row(notify) eq ""} {
                set row(notify) f
	    }
	
	    set user_id [db_nextval acs_object_id_seq]

            ns_log Debug "%%% $user_id"
	
	    auth::create_user \
		-user_id $user_id \
		-username "$row(username)" \
		-email $row(email) \
		-first_names $row(first_names) \
		-last_name $row(last_name) \
		-password $password
            
            lappend list_of_user_ids $user_id

            ns_log Debug "%%% $row(username)...$row(access_level)...$row(type)"

            # Now we make them a dotLRN user
            switch -exact $row(access_level) {
                limited {
                    dotlrn::user_add -user_id $user_id -id $row(username) -type $row(type)
                }
                full -
                default {
                    dotlrn::user_add -user_id $user_id -id $row(username) -type $row(type) -can_browse
                }
            }
            
            # Set the privacy
            dotlrn_privacy::set_user_guest_p -user_id $user_id -value $row(guest)

            append body [_ dotlrn.user_email_created [list user_email $row(email)]]
            set msg_subst_list [list system_name [ad_system_name] \
                                     system_url [parameter::get -package_id [ad_acs_kernel_id] -parameter SystemURL] \
                                     user_email $row(email) \
                                     user_password $password]
            set message [_ dotlrn.user_add_confirm_email_body $msg_subst_list] 
            set subject [_ dotlrn.user_add_confirm_email_subject $msg_subst_list] 

            # Send note to new user
            if { $row(notify) == "t" } {
                # Send note to new user
                if {[catch {acs_mail_lite::send -send_immediately -to_addr $row(email) -from_addr $admin_email -subject $subject -body $message} errmsg]} {
                    append body [_ dotlrn.lt_emailing_this_user_fa]
                set fail_p 1
                } else {
                    lappend list_of_addresses_and_passwords $row(email) $password
                }
            } else {
                append body [_ dotlrn.No_notification_requested]
            }
        }

        append body "<br>\n"
        unset row
        
    }
} on_error  {
    ns_log Error "The database choked while trying to create the last user in the list above! The transaction has been aborted, no users have been entered, and no e-mail notifications have been sent.\n
$errmsg"
    append body [_ dotlrn.database_choked]
    ad_script_abort
}

if {$fail_p} {
    append body "<p>[_ dotlrn.lt_Some_of_the_emails_fa]<p>"
}

append body  "<FORM method=post action=users-add-to-community>
<INPUT TYPE=hidden name=users value=\"$list_of_user_ids\">
<INPUT TYPE=hidden name=referer values=users>
[_ dotlrn.lt_You_may_now_choose_to] <INPUT TYPE=submit value=\"[_ dotlrn.lt_Add_These_Users_To_A_]\"></FORM><p>"
append body "[_ dotlrn.or_return_to] <a href=\"users\">[_ dotlrn.User_Management]</a>."

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

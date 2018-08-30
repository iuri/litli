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

    @author Timo Hentschel (timo@timohentschel.de)
    @creation-date 2004-09-30
    @version $Id: 
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set context_bar [list [list users [_ dotlrn.Users]] [_ dotlrn.Bulk_Approve]]

set pending_user_count [db_string count_pending_users {}]

set hours [expr {int($pending_user_count / 120)}]
set minutes [expr {int($pending_user_count / 2) % 60}]

set browse_options [list [list "[_ dotlrn.Full_Access]" 1] [list "[_ dotlrn.Limited_Access]" 0]]
set guest_options [list [list [_ dotlrn.No] f] [list [_ dotlrn.Yes] t]]

ad_form -name bulk_approve -action users-bulk-approve -form {

    {type:text(select) {label "[_ dotlrn.User_Type]"} {options [dotlrn::get_user_types_as_options]}}
    {can_browse_p:text(select) {label "[_ dotlrn.Access_Level]"} {options $browse_options}}
    {guest_p:text(select) {label "[_ dotlrn.Guest_1]"} {options $guest_options}}

} -on_submit {

    set title [_ dotlrn.Bulk_Approving]
    set context $context_bar

    ad_return_top_of_page [ad_parse_template \
                               -params [list context title] \
                               [template::streaming_template]]

    set subject "Your [ad_system_name] membership has been approved"
    set message "Your [ad_system_name] membership has been approved. Please return to [ad_url] to log into [ad_system_name]."
    set email_from [parameter::get -package_id [ad_acs_kernel_id] -parameter SystemOwner]

    set pending_users [db_list get_all_pending_users {}]

    set i 0
    foreach user_id $pending_users {
	incr i
	set email [party::email -party_id $user_id]
	ns_write "$i, $email : ..."

	# approve user in dotlrn
	if {[catch {
	    db_transaction {
		acs_user::change_state -user_id $user_id -state approved

		dotlrn::user_add \
		    -id $email \
		    -type $type \
		    -can_browse\=$can_browse_p \
		    -user_id $user_id

		dotlrn_privacy::set_user_guest_p \
		    -user_id $user_id \
		    -value $guest_p
	    }
	} errmsg]} {
	    ns_log Error "Database update failed on user-new-2.tcl" $errmsg
	    ns_write "Database Update Failed<br>"
	} else {

	    # notify user of approval
	    if {[catch {acs_mail_lite::send -send_immediately -to_addr $email -from_addr $email_from -subject $subject -body $message} errmsg]} {
	    
		ns_log Error "Error sending email from users-bulk-approve" $errmsg
		ns_write "Error sending mail<br>"
	    } else {
		ns_write "Ok<br>"
	    }
	}
    }

} -after_submit {
    ns_write "<br><br><a href='users'>Return</a>"
    ad_script_abort
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

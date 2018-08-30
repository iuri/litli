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
    Sends email confirmation to user after they've been created

    @author yon (yon@openforce.net)
    @creation-date 2002-01-20
    @version $Id: user-add-3.tcl,v 1.13.4.2 2015/09/18 08:05:10 gustafn Exp $
} -query {
    email
    message
    {referer "/acs-admin/users"}
}

#prevent this page from being called when it is not allowed
# i.e.   AllowCreateGuestUsersInCommunity 0
dotlrn_portlet::is_allowed -parameter guestuser
dotlrn_portlet::is_allowed -parameter limiteduser

set admin_user_id [ad_conn user_id]
set admin_email [db_string select_admin_email {
    select email
    from parties
    where party_id = :admin_user_id
}]

set msg_subst_values [list system_name [ad_system_name] system_url [parameter::get -parameter SystemUrl]]
set email_subject [_ dotlrn.user_add_confirm_email_subject $msg_subst_values]
if {[catch {acs_mail_lite::send -send_immediately -to_addr $email -from_addr $admin_email -subject $email_subject -body $message} errmsg]} {
    ad_return_error "[_ dotlrn.Mail_Failed]" "[_ dotlrn.lt_The_system_was_unable]
<pre>
[ns_quotehtml $errmsg]
</pre>"
    ad_script_abort
}

ad_returnredirect $referer


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

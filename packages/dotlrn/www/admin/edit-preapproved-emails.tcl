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

# dotlrn/www/admin/edit-preapproved-emails.tcl

ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date 2002-03-05
    @version $Id: edit-preapproved-emails.tcl,v 1.10.10.1 2015/09/11 11:40:52 gustafn Exp $
} -query {
    {referer [dotlrn::get_admin_url]}
} -properties {
    context_bar:onevalue
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

form create edit_emails

element create edit_emails emails \
    -label "[_ dotlrn.lt_Pre-approved_Email_Se]" \
    -datatype text \
    -widget text \
    -html {size 50} \
    -value [parameter::get -parameter auto_dotlrn_user_email_patterns]

element create edit_emails referer \
    -label [_ dotlrn.Referer] \
    -datatype text \
    -widget hidden \
    -value $referer

if {[form is_valid edit_emails]} {
    form get_values edit_emails \
        emails referer

    parameter::set_value -parameter auto_dotlrn_user_email_patterns -value $emails

    ad_returnredirect $referer
    ad_script_abort
}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

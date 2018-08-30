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

# dotlrn/tcl/spam-procs.tcl

ad_library {

    Spam support procedures.

    @author yon (yon@openforce.net)
    @creation-date 2002-02-13
    @cvs-id $Id: spam-procs.tcl,v 1.10.2.3 2017/04/21 20:45:16 gustafn Exp $

}

namespace eval spam {

    ad_proc -public interpolate {
        {-values:required}
        {-text:required}
    } {
        Interpolates a set of values into a string.

        @param values a list of tuples, each one consisting of a target string
                      and the value it is to be replaced with.
        @param text the string that is to be interpolated

        @return the interpolated string
    } {
        foreach tuple $values {
            regsub -all [lindex $tuple 0] $text [lindex $tuple 1] text
        }

        return $text
    }

    ad_proc -public send {
        {-recipients:required}
        {-from:required}
        {-real_from:required}
        {-subject:required}
        {-message:required}
        {-message_values:required}
    } {
        Send a spam to a set of users.

        @param recipients a list of party_id's; the recipients.
        @param from email address to set as "From"
        @param real_from real address of the sender to use in case of
                            errors.
        @param subject the subject of the email
        @param message the body of the email
        @param message_values a list of tuples of key/value pairs to
                              interpolate into the email
    } {

        set subject [interpolate -values $message_values -text $subject]
        set message [interpolate -values $message_values -text $message]

        # loop through all the recipients and send them the spam
        set errors ""
        db_foreach select_recipient_info {} {
            # replace some values in the subject and the message
            set values [list]
            lappend values [list \{email\} $email]
            lappend values [list \{first_names\} $first_names]
            lappend values [list \{last_name\} $last_name]
            lappend values [list \{from\} $from]

            set subject [interpolate -values $values -text $subject]
            set message [interpolate -values $values -text $message]

            # send the email
            if {[catch {acs_mail_lite::send -send_immediately -to_addr $email -from_addr $from -subject $subject -body $message} errmsg]} {
                append errors "
<p>
Failed to deliver to $email because:
    [ns_quotehtml $errmsg]
</p>
            "
            }
        }

        # if there were any errors sending the emails, then send an email to the
        # sender letting them know.
        if {$errors ne ""} {
            set error_subject "There were errors with this spam"
            set error_message "
<p>
There were errors with this spam.
</p>

<p>
The attempted message was:
</p>

<p>
<table width=\"50%\">
<tr>
    <th align=\"left\">[_ dotlrn.emacs_subject]</th>
    <td align=\"left\">$subject</td>
</tr>
<tr>
    <th align=\"left\">[_ dotlrn.email_message]</th>
    <td align=\"left\">$message</td>
</tr>
</table>
</p>

<p>
The errors were:
</p>

<p>
$errors
</p>
            "

            if {[catch {acs_mail_lite::send -send_immediately -to_addr $real_from -from_addr $real_from -subject $error_subject -body $error_message} errmsg]} {
                ad_return_error $error_subject $error_message
                ad_script_abort
            }
        }
    }

}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

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

# dotlrn/www/spam-2.tcl

ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date 2002-05-13
    @version $Id: spam-2.tcl,v 1.10.4.2 2015/09/18 08:05:10 gustafn Exp $
} -query {
} -properties {
    subject:onevalue
    message:onevalue
    format:onevalue
    spam_name:onevalue
    context_bar:onevalue
    community_id:onevalue
    portal_id:onevalue
}

form get_values spam_message subject message format

if {$format eq "html"} {
    set preview_message "$message"
} elseif {$format eq "pre"} {
    set preview_message [ad_text_to_html $message]
} else {
    set preview_message [ns_quotehtml $message]
}

set context [list [list $referer Admin] "[_ dotlrn.Spam_Community]"]
set community_id [dotlrn_community::get_community_id]
set portal_id [dotlrn_community::get_portal_id -community_id $community_id]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

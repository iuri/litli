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

# dotlrn/www/admin/site-wide-admin-toggle.tcl

ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date Jan 12, 2002
    @version $Id: site-wide-admin-toggle.tcl,v 1.14.2.2 2017/01/26 11:46:02 gustafn Exp $
} -query {
    user_id:naturalnum,notnull
    value
    {referer "users"}
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

if { ![acs_user::site_wide_admin_p] } {
    ns_log notice "user has tried to site-wide-admin-toggle  without permission"
    ad_return_forbidden \
               "Permission Denied" \
               "<p>
	            [_ acs-admin.lt_You_dont_have_permiss]
               </p>"
    return
}

set object_id [acs_magic_object "security_context_root"]
if {$value eq "grant"} {
    permission::grant -party_id $user_id -object_id $object_id -privilege admin
} elseif {$value eq "revoke"} {
    permission::revoke -party_id $user_id -object_id $object_id -privilege admin
}

util_memoize_flush_regexp $user_id
ad_returnredirect $referer



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

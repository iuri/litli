#
#  Copyright (C) 2004 MIT
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
    Change the privacy policy of a dotLRN community.

    @author yon (aegrumet@alum.mit.edu)
    @creation-date 2004-02-17
    @version $Id: privacy-policy-toggle.tcl,v 1.4.4.2 2017/01/26 11:46:02 gustafn Exp $
} -query {
    {community_id:integer ""}
    policy:notnull
    {referer "one-community-admin"}
} -validate {
    policy_ck -requires {policy:notnull} {
        if {$policy ni {yes no}} {
            ad_complain [_ dotlrn.prv_policy_must_be_one_of]
        }
    }
}

if {$community_id eq ""} {
    set community_id [dotlrn_community::get_community_id]
}

#Only dotlrn-wide admins should be able to set privacy policies,
#per discussion with Dee.  -AG
dotlrn::require_admin

if {$policy eq "yes"} {
    dotlrn_privacy::grant_read_private_data_to_guests -object_id $community_id
} else {
    dotlrn_privacy::revoke_read_private_data_from_guests -object_id $community_id
}

ad_returnredirect $referer


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

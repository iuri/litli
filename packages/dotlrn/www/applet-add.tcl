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
    Add an applet to a community

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-10-08
    @version $Id: applet-add.tcl,v 1.10.6.1 2015/09/11 11:40:41 gustafn Exp $
} -query {
    applet_key
    {referer "applets"}
}

#prevent this page from being called when it is not allowed
# i.e.   AllowManageApplets 0
dotlrn_portlet::is_allowed -parameter manageapplets

set community_id [dotlrn_community::get_community_id]

# Check access
dotlrn::require_user_admin_community -user_id [ad_conn user_id] -community_id $community_id

# Add the applet
dotlrn_community::add_applet_to_community $community_id $applet_key

ad_returnredirect $referer


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

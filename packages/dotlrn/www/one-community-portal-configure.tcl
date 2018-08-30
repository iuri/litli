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

    Displays a configuration page for COMMUNITY'S portal ONLY!
    This page is restricted to admins of the community.

    User portals are configured by the configure.tcl page.

    @author Arjun Sanyal (arjun@openforce.net)
    @version $Id: one-community-portal-configure.tcl,v 1.10.8.1 2015/09/11 11:40:45 gustafn Exp $
} -query {
    {referer "one-community-admin"}
}

#prevent this page from being called when it is not allowed
# i.e.   AllowCustomizePortalLayout 0
dotlrn_portlet::is_allowed -parameter cplayout

set community_id [dotlrn_community::get_community_id]

dotlrn::require_user_admin_community \
    -user_id [ad_conn user_id] \
    -community_id $community_id

set portal_id  [dotlrn_community::get_portal_id] 

# we are in a community
set community_name [dotlrn_community::get_community_name $community_id]
set context [list \
                 [list "one-community-admin" [_ dotlrn.Admin]] \
                 [_ dotlrn.Customize_Layout]]
set rendered_page [portal::configure \
    -allow_theme_change_p 1 \
    [dotlrn_community::get_portal_id] \
    $referer
]

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

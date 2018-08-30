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
    Manage the Applets for this community

    @author yon (yon@openforce.net)
    @creation-date 2002-01-19
    @version $Id: applets.tcl,v 1.19.4.1 2015/09/11 11:40:41 gustafn Exp $
} -query {
}

#prevent this page from being called when it is not allowed
# i.e.   AllowManageApplets 0
dotlrn_portlet::is_allowed -parameter manageapplets

set community_id [dotlrn_community::get_community_id]
set user_id [ad_conn user_id]
set portal_id [dotlrn_community::get_portal_id -community_id $community_id]

set context [list [list "one-community-admin" [_ dotlrn.Admin]] [_ dotlrn.Manage_Applets]]


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

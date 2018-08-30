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

    My account page for a user.

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-11-10
    @version $Id: communities.tcl,v 1.12.4.1 2015/09/11 11:40:41 gustafn Exp $

} -query {
} -properties {
    title:onevalue
    admin_p:onevalue
    admin_url:onevalue
    referer:onevalue
}

set portal_id [dotlrn::get_portal_id -user_id [ad_conn user_id]]
set dotlrn_url [dotlrn::get_url] 
# Make sure user is logged in
set user_id [auth::require_login]
set portlet_title [_ dotlrn.Communities]
set title [_ dotlrn.Communities]
set context [list [_ dotlrn.Communities]]
set admin_p [dotlrn::admin_p]
set admin_url "[dotlrn::get_url]/admin"
set cockpit_url "[dotlrn::get_url]/admin/cockpit"
set referer [ns_conn url]
set admin_pretty_name [parameter::get -localize -parameter dotlrn_admin_pretty_name]
set system_owner [ad_system_owner]

set pvt_home [ad_pvt_home]
set pvt_home_name [ad_pvt_home_name]


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

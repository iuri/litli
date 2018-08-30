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
    Search for a new user for dotLRN

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-11-04
    @version $Id: member-add.tcl,v 1.13.6.1 2015/09/11 11:40:44 gustafn Exp $
} -query {
    search_text
    {referer "one-community-admin"}
}

set search_text [string trim $search_text]
set community_id [dotlrn_community::get_community_id]

# Just search
db_multirow -extend {member_add_url} users select_users {} {
    set member_add_url [export_vars -base "member-add-2" { user_id referer }]
}

set context [list [list "one-community-admin" [_ dotlrn.Admin]] [_ dotlrn.New_User]]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

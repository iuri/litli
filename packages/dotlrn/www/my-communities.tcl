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

# dotlrn/www/my-communities.tcl

ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date Dec 07, 2001
    @version $Id: my-communities.tcl,v 1.11.4.1 2015/09/11 11:40:45 gustafn Exp $
} -query {
} -properties {
    communities:multirow
}

set user_id [auth::require_login]
set user_can_browse_p [dotlrn::user_can_browse_p -user_id $user_id]

if {![info exists referer]} {
    set referer "my-communities"
}

db_multirow communities select_my_communities {} {
    set role_pretty_name [dotlrn_community::get_role_pretty_name -community_id $community_id -rel_type $rel_type]
}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

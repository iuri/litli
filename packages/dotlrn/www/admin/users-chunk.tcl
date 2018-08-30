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
    @author yon (yon@openforce.net)
    @creation-date 2002-01-30
    @version $Id: users-chunk.tcl,v 1.12.4.1 2015/09/11 11:40:54 gustafn Exp $
} -query {
    {section ""}
} -properties {
    user_id:onevalue
}

set oacs_site_wide_admin_p [acs_user::site_wide_admin_p]

if {![info exists referer] || $referer eq ""} {
    set referer "[dotlrn::get_admin_url]/users"
}

template::multirow extend users state_change_url nuke_url swa_grant_url swa_revoke_url

template::multirow foreach users {
    set return_url "[dotlrn::get_admin_url]/user-new-2?user_id=$user_id&referer=$referer"
    set state_change_url [export_vars -base "/acs-admin/users/member-state-change" {{member_state approved} user_id return_url}] 
    set nuke_url [export_vars -base user-nuke {user_id referer}]
    set swa_grant_url [export_vars -base site-wide-admin-toggle {{value grant} user_id referer}]
    set swa_revoke_url [export_vars -base site-wide-admin-toggle {{value revoke} user_id referer}]
}

set user_id [ad_conn user_id]

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

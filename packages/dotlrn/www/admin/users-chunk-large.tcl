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
    @version $Id: users-chunk-large.tcl,v 1.14.4.1 2015/09/11 11:40:54 gustafn Exp $
} -query {
    {search_text ""}
} -properties {
    user_id:onevalue
    users:multirow
}

if {![info exists type] || $type eq ""} {
    set type admin
}

if {![info exists referer] || $referer eq ""} {
    set referer "[dotlrn::get_admin_url]/users"
}

set user_id [ad_conn user_id]

form create user_search

element create user_search search_text \
    -label [_ dotlrn.Search] \
    -datatype text \
    -widget text \
    -value $search_text

element create user_search type \
    -label [_ dotlrn.Type] \
    -datatype text \
    -widget hidden \
    -value $type

element create user_search referer \
    -label [_ dotlrn.Referer] \
    -datatype text \
    -widget hidden \
    -value $referer

if {[form is_valid user_search]} {
    form get_values user_search search_text referer

    set user_id [ad_conn user_id]
    set dotlrn_package_id [dotlrn::get_package_id]
    set root_object_id [acs_magic_object security_context_root]
    set i 1

    if {$type eq "deactivated"} {
        db_multirow users select_deactivated_users {} {
            set users:${i}(access_level) Limited
            incr i
        }
    } elseif {$type eq "pending"} {
        db_multirow users select_non_dotlrn_users {} {
            set users:${i}(access_level) N/A
            incr i
        }
    } else {
        db_multirow users select_dotlrn_users {} {
            if {[dotlrn::user_can_browse_p -user_id $user_id]} {
                set users:${i}(access_level) Full
            } else {
                set users:${i}(access_level) Limited
            }
            incr i
        }
    }
} else {
    multirow create users dummy
}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

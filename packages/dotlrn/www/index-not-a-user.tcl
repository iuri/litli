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

# dotlrn/www/index-not-a-user.tcl

ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date Dec 11, 2001
    @version $Id: index-not-a-user.tcl,v 1.18.4.1 2015/09/11 11:40:44 gustafn Exp $
}

if { [dotlrn::user_p -user_id [ad_conn user_id]] } {
    # Already a user
    ad_returnredirect .
    ad_script_abort
} 

if { [dotlrn::admin_p] } {
    set return_url [export_vars -base "[dotlrn::get_admin_url]/user-new-2" { { user_id {[ad_conn user_id]} } { referer "[dotlrn::get_url]/"} }]
    set self_approve_url [export_vars -base "[apm_package_url_from_key "acs-admin"]users/member-state-change" { { user_id {[ad_conn user_id]} } { member_state approved} return_url }]
    ad_returnredirect $self_approve_url
    ad_script_abort
}

set auto_add_p [parameter::get -parameter AutoAddUsersP -package_id [dotlrn::get_package_id] -default 0]

if { [ad_conn user_id] != 0 && $auto_add_p } {
    # If auto-adding, check if we're auto-adding for this authority
    set auth_add_auths [split [parameter::get \
                                   -parameter AutoAddAuthorities \
                                   -package_id [dotlrn::get_package_id] \
                                   -default {}] ","]

    # A star is enough
    if {"*" ni $auth_add_auths} {
        # No star
        set authority_id [acs_user::get_element -user_id [ad_conn user_id] -element authority_id]
        set authority_short_name [auth::authority::get_element -authority_id $authority_id -element short_name]

        # If not a star, then this user's authority needs to be named
        if {$authority_short_name ni $auth_add_auths} {
            # Nope, authority not listed, either
            set auto_add_p 0
        }
    }
}

if { $auto_add_p } {
    set user_id [auth::require_login]

    set type [parameter::get \
                  -parameter AutoUserType \
                  -package_id [dotlrn::get_package_id] \
                  -default "student"]
    
    set can_browse_p [parameter::get \
                          -parameter AutoUserAccessLevel \
                          -package_id [dotlrn::get_package_id] \
                          -default 1]
    
    set read_private_data_p [parameter::get \
                                 -parameter AutoUserReadPrivateDataP \
                                 -package_id [dotlrn::get_package_id] \
                                 -default 1]

    db_transaction {
        dotlrn::user_add \
            -type $type \
            -can_browse=$can_browse_p \
            -user_id $user_id
        
        dotlrn_privacy::set_user_is_non_guest \
            -user_id $user_id \
            -value $read_private_data_p
    }

    ad_returnredirect .
    ad_script_abort
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

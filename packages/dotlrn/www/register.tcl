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
    register

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-10-06
    @version $Id: register.tcl,v 1.17.4.5 2017/04/21 20:45:16 gustafn Exp $
} -query {
    {user_id:integer ""}
    {community_id:integer ""}
    {referer "./"}
}

if { ![parameter::get -parameter SelfRegistrationP -package_id [dotlrn::get_package_id] -default 1] } {
    set redirect_to [parameter::get -parameter SelfRegistrationRedirectTo -package_id [dotlrn::get_package_id] -default ""]

    if { $redirect_to ne "" } {
	ad_returnredirect $redirect_to
    } else {
	ad_returnredirect "not-allowed"
    }
    ad_script_abort
}

auth::require_login

if {$community_id eq ""} {
    set community_id [dotlrn_community::get_community_id]
}

if {$user_id eq ""} {
    set user_id [ad_conn user_id]
} else {
    dotlrn::require_user_admin_community -community_id $community_id
}

set join_policy [db_string select_join_policy {
    select join_policy
    from dotlrn_communities_full
    where community_id = :community_id
}]


# Check to see if the user is member already.
# This should prevent most double clicks, leaving
# the catch below to trap the rest.

if { [dotlrn_community::member_p $community_id $user_id] || 
     ($join_policy eq "needs approval" 
      && [dotlrn_community::member_pending_p -community_id $community_id -user_id $user_id]
      )
 } {
    ad_returnredirect $referer
    ad_script_abort
}


if {[catch {
    switch -exact $join_policy {
        "open" {
            dotlrn_community::add_user -member_state approved $community_id $user_id
	    dotlrn_community::send_member_email -community_id $community_id -to_user $user_id
        }
        "needs approval" {
            dotlrn_community::add_user -member_state "needs approval" $community_id $user_id
            
            
            # Following the same process as spam.tcl to email
            # admins in bulk.
            
            set segment_id [db_string select_admin_rel_segment_id {}]
            set community_name [dotlrn_community::get_community_name $community_id]
            set community_url "[parameter::get -package_id [ad_acs_kernel_id] -parameter SystemURL][dotlrn_community::get_community_url $community_id]"
            
            set query [db_map bulk_mail_query]

            set full_name [acs_user::get_element -user_id $user_id -element name]
            set email [party::email -party_id $user_id]
            set subject "$full_name ($email) has requested to join $community_name."
            
            set message "$full_name ($email) has requested to join $community_name.
            
Visit this link to approve or reject this request:
$community_url/members

        "

            set package_id [site_node_apm_integration::get_child_package_id \
                                -package_id [dotlrn_community::get_package_id $community_id] \
                                -package_key [bulk_mail::package_key]]

            bulk_mail::new \
                    -package_id $package_id \
                    -from_addr [ad_system_owner] \
                    -subject $subject \
                    -message $message \
                    -query $query

        }
    }
} errmsg]} {

    # Check to see if they are already a member 
    # (in which case this was likely a double click)
        
    if {[dotlrn_community::member_p $community_id $user_id]} {
        ad_returnredirect $referer
        ad_script_abort
    } else {
        ns_log Error "register.tcl failed: $errmsg\n$::errorInfo"
        
        ad_return_error "Error adding user to community"  "An error occurred while trying to add a user to a community.  This error has been logged."
    }
}

ad_returnredirect $referer

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

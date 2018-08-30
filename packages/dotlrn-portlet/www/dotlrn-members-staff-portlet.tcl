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

# copied from dotlrn/www/members-chunk.tcl

ad_page_contract {
    @author yon (yon@milliped.com)
    @creation-date Jan 08, 2002
    @version $Id: dotlrn-members-staff-portlet.tcl,v 1.13.2.1 2015/09/11 11:41:00 gustafn Exp $
} -query {
} -properties {
    users:multirow
}

array set config $cf	

set user_id [ad_conn user_id]
set referer [ad_conn url]
set community_id $config(community_id)
set return_url [ad_return_url]

if { $community_id ne "0" } {

    set admin_p [dotlrn::user_can_admin_community_p -user_id $user_id -community_id $community_id]
    set read_private_data_p [dotlrn::user_can_read_private_data_p -user_id $user_id -object_id $community_id]

    # get all the users in a list of ns_sets
    set all_users_list [dotlrn_community::list_users $community_id]

    set n_profs 0
    set n_tas 0 
    set n_cas 0 

    # count how many of some types
    foreach one_user_set $all_users_list {
        if {[ns_set get $one_user_set rel_type] eq "dotlrn_instructor_rel"} {
            incr n_profs
        } elseif {[ns_set get $one_user_set rel_type] eq "dotlrn_ta_rel"} {
            incr n_tas
        } elseif {[ns_set get $one_user_set rel_type] eq "dotlrn_ca_rel"} {
            incr n_cas
        }
    }

   # stuff into a multirow
   template::util::list_of_ns_sets_to_multirow \
       -rows $all_users_list \
       -var_name "users"

   # Used in en_US version of some messages in adp
   set instructor_role_pretty_plural [dotlrn_community::get_role_pretty_plural -community_id $community_id \
                                                                            -rel_type dotlrn_instructor_rel]
   set teaching_assistant_role_pretty_plural [dotlrn_community::get_role_pretty_plural -community_id $community_id \
                                                                                     -rel_type dotlrn_ta_rel]
   set course_assistant_role_pretty_plural [dotlrn_community::get_role_pretty_plural -community_id $community_id \
                                                                                  -rel_type dotlrn_ca_rel]
}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

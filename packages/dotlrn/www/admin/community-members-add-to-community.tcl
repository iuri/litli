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
    Add a members of one community to another

    @author yon (yon@openforce.net)
    @creation-date 2002-02-10
    @param source_community_id The community_id for the source community.  The members of the source community will be added to the target community the user selects.
    @param referer The url for the administration page of the source community.
    @version $Id: community-members-add-to-community.tcl,v 1.6.4.2 2017/04/21 20:45:16 gustafn Exp $
} -query {
    source_community_id:integer
    referer 
} -properties {
    context_bar:onevalue
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set community_name [db_string select_community_info {}]
set users [dotlrn_community::list_users $source_community_id]

set context_bar [list [list $referer $community_name]  "[_ dotlrn.lt_Add_Members_to_Anothe]"]

form create select_community

element create select_community source_community_id \
    -label "&nbsp;" \
    -datatype text \
    -widget hidden \
    -value $source_community_id

element create select_community referer \
        -label "[_ dotlrn.Referer]" \
        -datatype text \
        -widget hidden \
        -value $referer

set communities [db_list_of_lists select_all_communities {
    select dotlrn_communities.pretty_name,
           dotlrn_communities.community_id
    from dotlrn_communities
    where dotlrn_communities.portal_id is not NULL
    order by dotlrn_communities.pretty_name,
             dotlrn_communities.community_id
}]

if {[llength $communities]} {
    element create select_community community_id \
        -label "[_ dotlrn.Add_users_to]" \
        -datatype text \
        -widget select \
        -options "{{} {}} $communities"
} else {
    element create select_community community_id \
        -label "[_ dotlrn.No_groups_to_add_to]" \
        -datatype text \
        -widget hidden \
        -value ""
}

if {[form is_valid select_community]} {
    form get_values select_community \
        source_community_id community_id

    if {$community_id ne ""} {
        db_transaction {
            foreach user $users {
		set user_id [ns_set get $user user_id]
		if {![dotlrn_community::member_p $community_id $user_id]} {
                    # now we know user isn't an approved member of the new community
                    if {![dotlrn_community::member_pending_p -community_id $community_id -user_id $user_id]} {

                        # they aren't awaiting approval either, so we can go ahead and create them
                        if {[catch {
                            # There is still a danger that a double
                            # click will cause a failure.
                            dotlrn_community::add_user $community_id $user_id
                        } errmsg]} {
                            if {[dotlrn_community::member_p $community_id $user_id]} {
                                # assume this was a double click
                                ad_returnredirect $referer
                                ad_script_abort
                            } else {
                                ns_log Error "community-members-add-to_community.tcl failed: $errmsg"
                                ReturnHeaders
                                ad_return_error "[_ dotlrn.lt_Error_adding_user_to_]"  "[_ dotlrn.lt_An_error_occurred_whil]"
                            }
                        }
                    } else {
                        # they are already there and awaiting approval, so just approve them.
                        dotlrn_community::membership_approve -user_id $user_id -community_id $community_id
                    }
		}
            }
        }
    }

    ad_returnredirect $referer
    ad_script_abort
}

set estimated_number_of_seconds [expr {[llength $users] * 3}]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

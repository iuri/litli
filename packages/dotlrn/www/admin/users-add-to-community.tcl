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
    Add a set of users to a community

    @author yon (yon@openforce.net)
    @creation-date 2002-02-10
    @version $Id: users-add-to-community.tcl,v 1.17.4.1 2015/09/11 11:40:53 gustafn Exp $
} -query {
    users
    {referer "users-search"}
} -properties {
    context_bar:onevalue
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set context_bar [list [list users [_ dotlrn.Users]] [list users-search [_ dotlrn.User_Search]] [_ dotlrn.Add_Users_to_Group]]

form create select_community -html {action select_community} -cancel_url $referer
element create select_community users \
    -label "&nbsp;" \
    -datatype text \
    -widget hidden \
    -value $users

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
        users community_id


     if {$community_id ne ""} {
        db_transaction {
            foreach user $users {
                dotlrn_community::add_user $community_id $user
            }
        }
     }
    set message "Users added to community. "

    ad_returnredirect [export_vars \
			   -base ../member-email-confirm \
			   {{user_id $users} {return_url $referer} community_id}]

    ad_script_abort
}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

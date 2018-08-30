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
    Add the new user

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-11-04
    @version $Id: member-add-3.tcl,v 1.14.6.2 2017/01/26 11:46:02 gustafn Exp $
} -query {
    user_id:naturalnum,multiple,notnull
    rel_type
    {referer "one-community-admin"}
}

set community_id [dotlrn_community::get_community_id]
# See if the user is already in the group

foreach member_id $user_id {
    set member_p [dotlrn_community::member_p $community_id $member_id]

    set skip_p 0
    if {$member_p} {
        # get the rel_info
        db_1row get_rel_info ""

        # if new rel type is same as old then
        # no sense in doing anything
        if {$rel_type eq $old_rel_type} {
            set skip_p 1
        }

        if {!$skip_p} {
            # this is just a change rel
            # so we do not want to call remove_user
            # as that removes subgroup rels as well
            relation_remove $rel_id
            util_memoize_flush "dotlrn_community::list_users_not_cached -rel_type $rel_type -community_id $community_id"
            set change_rel_p 1
        }
    } else {
        # if the user is not a member
        # then we could not possibly be
        # changing the rel_type so set to 0
        set change_rel_p 0
    }

    # Add the relation
    if {!$skip_p} {
        if {$change_rel_p} {
            # if this is just a change rel then
            # no need to call add_user as the user
            # has already been added before and
            # add_user_to_community should have
            # taken care of everything
            set extra_vars [ns_set create]
                ns_set put $extra_vars user_id $member_id
                ns_set put $extra_vars community_id $community_id
            ns_set put $extra_vars class_instance_id $community_id

            relation_add \
                -member_state "approved" \
                -extra_vars $extra_vars \
                $rel_type \
                $community_id \
                $member_id
            util_memoize_flush "dotlrn_community::list_users_not_cached -rel_type $rel_type -community_id $community_id"
        } else {
            dotlrn_community::add_user -rel_type $rel_type $community_id $member_id
        }
    }
}
ad_returnredirect $referer

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

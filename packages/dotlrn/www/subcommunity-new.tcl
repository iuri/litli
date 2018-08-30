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
    create a new subcommunity (aka subgroup)

    @author arjun (arjun@openforce.net)
    @creation-date 2001-02-12
    @version $Id: subcommunity-new.tcl,v 1.26.4.1 2015/09/11 11:40:47 gustafn Exp $
} -query {
    {referer "one-community-admin"}
} -properties {
    title:onevalue
}

set user_id [ad_conn user_id]
set parent_community_id [dotlrn_community::get_community_id]
dotlrn::require_user_admin_community -user_id $user_id -community_id $parent_community_id
set title "[_ dotlrn.New] [parameter::get -localize -parameter subcommunities_pretty_name]"
set context [list [list "one-community-admin" [_ dotlrn.Admin]] $title]
set portal_id [dotlrn_community::get_portal_id -community_id $parent_community_id]

# set the join policy widget to default to
# the same as it's parent
if {[dotlrn_community::open_p -community_id $parent_community_id]} {
    set join_policy_list [list [list [_ dotlrn.Open] open] [list [_ dotlrn.Closed] closed] [list [_ dotlrn.Needs_Approval] "needs approval"]]
} elseif {[dotlrn_community::needs_approval_p -community_id $parent_community_id]} {
    set join_policy_list [list [list [_ dotlrn.Needs_Approval] "needs approval"] [list [_ dotlrn.Open] open] [list [_ dotlrn.Closed] closed]]
} else {
    set join_policy_list [list [list [_ dotlrn.Closed] closed] [list [_ dotlrn.Needs_Approval] "needs approval"] [list [_ dotlrn.Open] open]]
}

form create add_subcomm

element create add_subcomm pretty_name \
    -label [_ dotlrn.Name] \
    -datatype text \
    -widget text \
    -html {size 40}

element create add_subcomm description \
    -label [_ dotlrn.Description] \
    -datatype text \
    -widget text \
    -html {size 40} \
    -optional

element create add_subcomm join_policy \
    -label "[_ dotlrn.Join_Policy]" \
    -datatype text \
    -widget select \
    -options $join_policy_list

element create add_subcomm referer \
    -label [_ dotlrn.Referer] \
    -datatype text \
    -widget hidden \
    -value $referer

if {[form is_valid add_subcomm]} {
    form get_values add_subcomm \
        pretty_name description join_policy referer

    # we set some extra vars based on the community_type of the parent
    set parent_type [dotlrn_community::get_community_type_from_community_id $parent_community_id]

    set extra_vars [ns_set create]
    ns_set put $extra_vars join_policy $join_policy

    if {$parent_type ne [dotlrn_club::community_type] &&
        $parent_type ne "dotlrn_community" } {
            # we want to make a subgroup of a class instance
            # get the term_id, since the subgroup should not
            # outlive the class
            set term_id [dotlrn_class::get_term_id -class_instance_id $parent_community_id]
            ns_set put $extra_vars term_id $term_id
    }

    db_transaction {
        set subcomm_id [dotlrn_community::new \
            -parent_community_id $parent_community_id \
            -description $description \
            -community_type dotlrn_community \
            -pretty_name $pretty_name \
            -extra_vars $extra_vars \
        ]

        # let admins of the parent comm, be admins of the subcomm
        set parent_admin_segment_id [dotlrn_community::get_rel_segment_id \
            -community_id $parent_community_id \
            -rel_type dotlrn_admin_rel \
        ]

        permission::grant \
            -party_id $parent_admin_segment_id \
            -object_id $subcomm_id \
            -privilege admin

        # for a subcomm of a "class instance" set the start and end dates
        if {$parent_type ne [dotlrn_club::community_type] &&
            $parent_type ne "dotlrn_community" } {

            dotlrn_community::set_active_dates \
                -community_id $subcomm_id \
                -start_date [dotlrn_term::get_start_date -term_id $term_id] \
                -end_date [dotlrn_term::get_end_date -term_id $term_id]

        }
    }

    # redirect to the member page of the new sub comm (for adding)
    ad_returnredirect "[dotlrn_community::get_community_key -community_id $subcomm_id]/members?referer=$referer"
    ad_script_abort
}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

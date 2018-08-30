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
    shows User A what User B has contributed to the community

    @author yon (yon@openforce.net)
    @creation-date 2002-01-22
    @version $Id: community-member.tcl,v 1.20.2.2 2016/05/20 20:17:34 gustafn Exp $
} {
    user_id:naturalnum,notnull
    {community_id:naturalnum ""}
    {return_url:localurl ""}
} -properties {
    portal_id:onevalue
    member_state:onevalue
    first_names:onevalue
    last_name:onevalue
    email:onevalue
    inline_portrait_state:onevalue
    portrait_export_vars:onevalue
    width:onevalue
    height:onevalue
    system_name:onevalue
    pretty_creation_date:onevalue
    show_intranet_info_p:onevalue
    show_email_p:onevalue
    url:onevalue
    bio:onevalue
    verified_user_id:onevalue
    folder_id:onevalue
    user_contributions:multirow
}

if {[dotlrn_community::get_community_id] != $community_id} {
    ad_returnredirect [export_vars -base "[dotlrn_community::get_community_url $community_id]community-member" {user_id community_id}]
}

auth::require_login

acs_user::get -user_id $user_id -array user -include_bio

foreach name {first_names last_name} {
    set $name $user($name)
}

if { $return_url eq "" } {
    set return_url [ad_return_url]
}

set context [list [_ dotlrn.Community_member]]
set system_name [ad_system_name]
set pretty_creation_date [lc_time_fmt $user(creation_date) "%q"]
set pretty_email [email_image::get_user_email -user_id $user_id -transparent 1 -return_url $return_url]

set login_export_vars "return_url=[ns_urlencode [acs_community_member_url -user_id $user_id]]"

# Portrait

set portrait_p [db_0or1row get_item_id {
    select c.live_revision, c.item_id,
           cr.description as caption
    from acs_rels a, cr_items c, cr_revisions cr
    where a.object_id_two = c.item_id
      and a.object_id_one = :user_id
      and a.rel_type = 'user_portrait_rel'
      and cr.revision_id = c.live_revision}]

if { $portrait_p } {
    set img_src [export_vars -base "[subsite::get_element -element url]shared/portrait-bits.tcl" { user_id item_id {size thumbnail}}]
    set portrait_url [export_vars -base "[subsite::get_element -element url]shared/portrait" { user_id return_url }]
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

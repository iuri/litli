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
    @version $Id: dotlrn-members-portlet.tcl,v 1.16.4.1 2015/09/11 11:41:00 gustafn Exp $
} -query {
} -properties {
    users:multirow
}

array set config $cf	

set user_id [ad_conn user_id]
set referer [ad_conn url]
set community_id $config(community_id)
set return_url [ad_return_url]

set admin_p [dotlrn::user_can_admin_community_p -user_id $user_id -community_id $community_id]
set read_private_data_p [dotlrn::user_can_read_private_data_p -user_id $user_id -object_id $community_id]
set spam_p [dotlrn::user_can_spam_community_p -user_id [ad_conn user_id] -community_id $community_id]
# Get all users for this community, including role
template::util::list_of_ns_sets_to_multirow \
    -rows [dotlrn_community::list_users $community_id] \
    -var_name "users"

template::multirow extend users community_member_url name

template::multirow foreach users { 
    set role [dotlrn_community::get_role_pretty_name -community_id $community_id -rel_type $rel_type]
    set community_member_url [acs_community_member_url -user_id $user_id]
    set email [email_image::get_user_email -user_id $user_id -return_url $return_url]
    set name "$first_names $last_name"
}

template::list::create \
    -name users \
    -multirow users \
    -caption "\#dotlrn-portlet.members_portlet_pretty_name\#" \
    -html {summary "\#dotlrn-portlet.members_portlet_pretty_name\#"} \
    -elements {
        bio {
            display_template {
      <if @users.portrait_p@ true or @users.bio_p@ true>
        <a href="@users.community_member_url@"  title="#acs-subsite.lt_User_has_portrait_title#"><img src="/resources/acs-subsite/profile-16.png" height="16" width="16" alt="#acs-subsite.Profile#" title="#acs-subsite.lt_User_has_portrait_title#" style="border:0"></a>
      </if>
            }
            label {}
        }
        name {
            link_url_col community_member_url
            link_html {title "#acs-subsite.lt_User_has_portrait_title#"}
            label {#dotlrn.Name#}
        }
        email {
            display_template {@users.email;noquote@}
            label {#dotlrn.Email#}
            link_html {title "\#dotlrn.Email"}
        }
        role {
            label {#dotlrn.Role#}
        }
    }

set spam_url [export_vars -base spam-recipients {community_id referer}]
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

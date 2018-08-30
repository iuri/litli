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
    Displays the personal home page

    @author Ben Adida (ben@openforce.net)
    @creation-date 2001-08-20
    @version $Id: index.tcl,v 1.48.4.2 2017/01/26 08:53:27 gustafn Exp $
} -query {
    {filter ""}
    {page_num:naturalnum,notnull 0}
}

# Used to keep track of navigation links
ad_set_client_property dotlrn page_num $page_num

if {[parameter::get -parameter community_type_level_p] == 1} {
    ad_returnredirect "one-community-type"
    ad_script_abort
} elseif {[parameter::get -parameter community_level_p] == 1} {
    ad_returnredirect "one-community?page_num=$page_num"
    ad_script_abort
}

set user_id [auth::require_login]

if {![dotlrn::user_p -user_id $user_id]} {
    ad_returnredirect "index-not-a-user"
    ad_script_abort
}    

if {![dotlrn::user_can_browse_p -user_id $user_id]} {

    set communities [dotlrn_community::get_all_communities_by_user $user_id]

    if {[llength $communities] == 1} {
        ad_returnredirect [ns_set get [lindex $communities 0] url]
        ad_script_abort
    }

}

set portal_id [dotlrn::get_portal_id -user_id $user_id]
set title [db_string get_title {
    select pretty_name
    from portal_pages
    where portal_id = :portal_id
    and sort_key = :page_num
} -default ""]
if { $page_num ne 0 } {
    set context [list [lang::util::localize $title]]
}

set rendered_page [dotlrn::render_page -page_num $page_num -hide_links_p t $portal_id]

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

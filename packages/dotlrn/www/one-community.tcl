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
    Displays a community

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @author arjun (arjun@openforce.net)
    @creation-date 2001-10-04
    @version $Id: one-community.tcl,v 1.36.8.2 2017/01/26 08:53:27 gustafn Exp $
} -query {
    {page_num:naturalnum,notnull 0}
}

ns_log Notice "Running TCL script one-community"

# Check that this is a community type
if {[parameter::get -parameter community_level_p] != 1} {
    ad_returnredirect "./"
    ad_script_abort
}

# Get basic information
set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set admin_p [dotlrn::user_can_admin_community_p \
        -user_id $user_id \
        -community_id $community_id
]

set title [dotlrn_community::get_community_name $community_id]

# Check that this user is a member
if {![dotlrn_community::member_p $community_id $user_id] && !$admin_p} {

    set portal_id [dotlrn_community::get_non_member_portal_id \
        -community_id $community_id
    ]

} else {

    set portal_id [dotlrn_community::get_portal_id \
        -community_id $community_id
    ]
}

set page_id [portal::get_page_id -portal_id $portal_id -sort_key $page_num]
set page_name [portal::get_page_pretty_name -page_id $page_id]
if { $page_num ne 0} {
    set context [list [lang::util::localize $page_name]]
}

set rendered_page [dotlrn::render_page \
    -hide_links_p t \
    -page_num $page_num \
    $portal_id 
]

ad_return_template 


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

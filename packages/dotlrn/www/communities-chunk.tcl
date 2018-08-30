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

# dotlrn/www/communities-chunk.tcl

ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date Dec 07, 2001
    @version $Id: communities-chunk.tcl,v 1.13.4.1 2015/09/11 11:40:41 gustafn Exp $
} -query {
    {filter "select_all_memberships"}
} -properties {
    n_communities:onevalue
    communities:multirow
}

if {![info exists community_type]} {
    set community_type ""
}

set user_id [ad_conn user_id]

if {$community_type ne ""} {
    set n_communities [db_string select_all_communities_count_by_type {}]
} else {
    set n_communities [db_string select_all_communities_count {}]
}

set filter_bar [ad_dimensional [list [list filter "[_ dotlrn.Memberships_1]" select_all_memberships \
        {
            {select_all_memberships current {}}
            {select_all_non_memberships join {}}
        }]]]

if {$community_type ne ""} {
    append filter "_by_type"
}

db_multirow -extend {query referer} communities $filter {} {
    if {(![info exists referer] || $referer eq "")} {
	set referer "./"
    }
    set query $filter
}


template::list::create \
    -name communities \
    -multirow communities \
    -elements {
        pretty_name {
	    label "\#dotlrn.clubs_pretty_plural\#"
	    link_url_eval {$url}
	}
	member_p {
	    label "\#dotlrn.Actions\#"
	    display_template {
		<if @communities.member_p@ eq 0>
		   <center>
		   <include src="/packages/dotlrn/www/register-link" url="register?community_id=@communities.community_id@&referer=@communities.referer@">
                   </center>
		</if>
		<else>
		   <center>
		   <include src="/packages/dotlrn/www/deregister-link" url="deregister?community_id=@communities.community_id@&referer=@communities.referer@">
		   </center>
		</else>
	    }
	}
    } 

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

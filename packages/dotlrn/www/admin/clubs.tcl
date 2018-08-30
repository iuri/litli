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

# dotlrn/www/admin/clubs.tcl

ad_page_contract {
    displays dotLRN clubs admin page

    @author yon (yon@openforce.net)
    @creation-date 2001-12-03
    @version $Id: clubs.tcl,v 1.19.2.3 2017/01/26 11:46:02 gustafn Exp $
} -query {
    {orderby:token "pretty_name,asc"}
    page:naturalnum,optional
} -properties {
    title:onevalue
    context_bar:onevalue
    clubs:multirow
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set title [parameter::get -localize -parameter clubs_pretty_plural]
set context_bar [list $title]

# Some of the en_US messages in the adp use these variables
set clubs_pretty_name [parameter::get -localize -parameter clubs_pretty_name]
set clubs_pretty_plural [parameter::get -localize -parameter clubs_pretty_plural]

set actions [list "[_ dotlrn.new_community]" "club-new"]

template::list::create \
    -name clubs \
    -multirow clubs \
    -actions $actions \
    -key community_id \
    -page_flush_p t \
    -page_size 50 \
    -page_query_name clubs_pagination \
    -elements {
        pretty_name {
            label "[_ dotlrn.community_header_name]"
        orderby_asc {pretty_name asc}
        orderby_desc {pretty_name desc}
            link_url_col url
        }
        description {
            label "[_ dotlrn.Description]"
        }
        n_members {
            label "[_ dotlrn.Members]"
        orderby_asc {n_members asc}
        orderby_desc {n_members desc}
        }
        actions {
            label "[_ dotlrn.Actions]"
            display_template {
                <a href="@clubs.url@one-community-admin" class="button"><span>#dotlrn.Administer#</span></a>
            }
        }
    
    }

db_multirow clubs select_clubs {} {
    set description [ns_quotehtml $description]
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

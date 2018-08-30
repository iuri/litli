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

# dotlrn/www/admin/club.tcl

ad_page_contract {
    displays single dotLRN club page

    @author yon (yon@openforce.net)
    @creation-date 2001-12-03
    @version $Id: club.tcl,v 1.16.10.2 2015/09/18 08:05:10 gustafn Exp $
} -query {
    club_id:naturalnum,notnull
} -errors {
    club_id:naturalnum,notnull {must provide a valid club_id}
} -properties {
    context_bar:onevalue
    pretty_name:onevalue
    description:onevalue
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

db_1row select_club {}

set description [ns_quotehtml $description]

set context_bar [list [list clubs [parameter::get -localize -parameter clubs_pretty_plural]] $pretty_name]

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

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

# dotlrn/www/admin/add-instructor-2.tcl

ad_page_contract {
    @author yon (yon@openforce.net)
    @creation-date Jan 10, 2002
    @version $Id: add-instructor-2.tcl,v 1.11.2.1 2015/09/11 11:40:48 gustafn Exp $
} -query {
    community_id:naturalnum,notnull
    {search_text ""}
    {referer ""}
} -properties {
    users:multirow
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set context_bar [list [_ dotlrn.Add_a_Professor]]

# LARS 2003-10-21: We should probably limit this in some way, so you can't get 30000 hits.

db_multirow users select_users {}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

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
    Displays single dotLRN class page

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-11-07
    @version $Id: department.tcl,v 1.16.4.2 2015/09/18 08:05:10 gustafn Exp $
} -query {
    {department_key ""}
    {page ""}
} -properties {
    pretty_name:onevalue
    external_url:onevalue
    description:onevalue
    classes:multirow
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

if {$department_key eq ""} {
    ad_returnredirect "[dotlrn::get_admin_url]/classes"
    ad_script_abort
}

# Get information about that class
if {![db_0or1row select_departments_info {}]} {
    ad_returnredirect departments
    ad_script_abort
}

set description [ns_quotehtml $description]

set context_bar [list [list departments [parameter::get -localize -parameter departments_pretty_plural]] $pretty_name]
set referer "[ns_conn url]?[ns_conn query]"

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

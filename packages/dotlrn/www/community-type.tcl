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
    Displays a community type

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-10-04
} -query {
}

# Check that this is a community type
if {[parameter::get -parameter community_type_level_p] != 1} {
    ad_returnredirect "./"
    ad_script_abort
}

set user_id [ad_conn user_id]

# What community type are we at?
set community_type [dotlrn_community::get_community_type]

# Load some community type info
db_1row select_community_type_info {}

set context_bar [_ dotlrn.View]

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

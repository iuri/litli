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
    deregister-confirm

    @author Tracy Adams (teadams@alum.mit.edu)
    @creation-date 2002-29-08
    @version $Id: deregister-confirm.tcl,v 1.6.2.2 2017/01/26 11:46:02 gustafn Exp $ 
} -query {
    {user_id:naturalnum,multiple,notnull}
    {community_id:integer ""}
    {referer ""}
}

auth::require_login

set time_per_user 15
set num_users_display_limit 99

set num_users [llength $user_id]
set num_seconds [expr {$time_per_user*$num_users}]
set num_minutes [expr {$num_seconds/60}]

# Note: This query will not work (in Oracle) 
# if num_users_display_limit is over 100. 

if {$num_users < $num_users_display_limit} {
    db_multirow users_pending_drop select_users_pending_drop {}
}

set hidden_user_ids ""

foreach member_id $user_id {
    append hidden_user_ids "<input type=hidden name=user_id value=\"$member_id\">"
}

ad_return_template







# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

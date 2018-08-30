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
    deregister

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-10-06
    @version $Id: deregister.tcl,v 1.10.4.3 2017/04/21 20:45:16 gustafn Exp $
} -query {
    {user_id:multiple,integer ""}
    {community_id:integer ""}
    {referer "./"}
}


# This page was modified to allow more that one user to be dropped at a time.
# This one done so there is one consistent way of dropping members.
#
# The parameter "user_id" was kept so that other entry points (both current
# and those that might occur in the future from OpenACS and other changes)
# wouldn't break.  This does have the unfortunate consequence that the name
# user_id is not intuative when it is a list of many user_ids. (teadams@alum.mit.edu)

auth::require_login

if {$community_id eq ""} {
    set community_id [dotlrn_community::get_community_id]
}

if {$user_id eq ""} {
    set user_id [ad_conn user_id]
} else {
    dotlrn::require_user_admin_community -community_id $community_id
}

foreach member_id $user_id {
 
    # This is catch most double clicks.
    # The catch will take care of cases where the double click is too fast.

    if {[dotlrn_community::member_p $community_id $member_id]} {
	if {[catch {
	    dotlrn_community::remove_user $community_id $member_id
	} errmsg]} {

	    if {![dotlrn_community::member_p $community_id $user_id]} {
		# assume this was a double click
		ad_returnredirect $referer
		ad_script_abort
	    } else {
		ns_log Error "deregister.tcl failed: $errmsg"
		ReturnHeaders
		ad_return_error "[_ dotlrn.lt_Error_removing_user_c]"  "[_ dotlrn.lt_An_error_occurred_whil_1]"
	    }
	}
    }
}

ad_returnredirect $referer


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

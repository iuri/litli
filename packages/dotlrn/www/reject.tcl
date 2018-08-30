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
    reject

    @author yon (yon@openforce.net)
    @creation-date 2002-03-15
    @version $Id: reject.tcl,v 1.9.4.2 2017/01/26 11:46:02 gustafn Exp $
} -query {
    {user_id:integer,multiple ""}
    {community_id:integer ""}
    {referer "./"}
}

auth::require_login

if {$community_id eq ""} {
    set community_id [dotlrn_community::get_community_id]
}

foreach uid $user_id {
    if {$uid eq ""} {
	    set uid [ad_conn user_id]
    } else {
	    dotlrn::require_user_admin_community -community_id $community_id
    }
    
    dotlrn_community::membership_reject -community_id $community_id -user_id $uid
}
ad_returnredirect $referer


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

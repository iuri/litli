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
    Add an applet to a community

    @author Ben Adida (ben@openforce.net)
    @creation-date 2001-10-08
} -query {
    community_id:naturalnum,notnull
    applet_key
}

# Check access
dotlrn::require_user_admin_community -user_id [ad_conn user_id] -community_id $community_id

# Add the applet
dotlrn_community::remove_applet $community_id $applet_key

# Get back to where you once belonged
ad_returnredirect community-applets?community_id=$community_id


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

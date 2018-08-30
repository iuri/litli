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
    Web log controls for user control panel

    @author Caroline Meeks (cmeeks@mit.edu)
    @creation-date 2002-09-13
    @version $Id: weblog-control-panel.tcl,v 1.5.4.1 2015/09/11 11:40:48 gustafn Exp $
}

set user_id [auth::require_login]


set dotlrn_package_id [dotlrn::get_package_id]

set weblog_package_id [site_node_apm_integration::get_child_package_id  -package_key "forums"]

set weblog_url "[dotlrn_community::get_url -package_id $weblog_package_id]/forum-view"
db_multirow weblogs weblogs {select name, forum_id, to_char(o.last_modified, 'Mon DD, YYYY') as lastest_post from forums_forums_enabled f, acs_objects o where o.object_id = forum_id and o.creation_user = :user_id and f.package_id = :weblog_package_id}


ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

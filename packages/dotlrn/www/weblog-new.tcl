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
    Create a user weblog

    @author Caroline Meeks (cmeeks@mit.edu)
    @creation-date 2002-09-12
    @version $Id: weblog-new.tcl,v 1.6.4.2 2017/04/21 20:45:16 gustafn Exp $
} -query {
    {referer "control-panel"}
} -validate {
    
}

set user_id [auth::require_login]

set weblog_package_id [site_node_apm_integration::get_child_package_id  -package_key "forums"]
set existing_forum_ids [db_list weblog_forum_id {select forum_id from forums_forums_enabled f, acs_objects o where o.object_id = forum_id and o.creation_user = :user_id and f.package_id = :weblog_package_id}]

if {![llength $existing_forum_ids]} {
    #No existing weblog lets make them one.

    set user_name [acs_user::get_element -user_id $user_id -element name]
    set name "[_ dotlrn.lt_Web_Log_for_user_name]"
    set charter "[_ dotlrn.Public_Web_Log]"
    set presentation_type "weblog"
    set posting_policy "open"
    set new_threads_p 0


    db_transaction {
	set forum_id [forum::new -name $name \
		-charter $charter \
		-presentation_type $presentation_type \
		-posting_policy $posting_policy \
		-package_id $weblog_package_id \
		]


	#Only this user can create new threads.
	forum::new_questions_deny -forum_id $forum_id
	forum::new_questions_allow -forum_id $forum_id -party_id $user_id

	#Everyone should be subscribed to their weblog!

	notification::request::new -object_id $forum_id \
		-type_id [notification::type::get_type_id -short_name "forums_forum_notif"] \
		-user_id $user_id \
		-interval_id [notification::get_interval_id -name "instant"] \
		-delivery_method_id [notification::get_delivery_method_id -name "email"]
    }
} else {
    set forum_id [lindex $existing_forum_ids 0]
    #Probably a double click, send them to their first existing enabled weblog.
}

ad_returnredirect "[dotlrn_community::get_url -package_id $weblog_package_id]/forum-view?forum_id=$forum_id"







# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

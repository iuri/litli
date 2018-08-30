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
    
    Subscribe group members to a forum and set autosubscription mode
    
    @author Don Baccus (dhogaza@pacifier.com)
    @cvs_id $Id: subscribe-members.tcl,v 1.5.2.2 2016/05/20 20:17:34 gustafn Exp $
} {
    forum_id:naturalnum,notnull
    community_id:naturalnum,notnull
    return_url:localurl,notnull
}

set users [dotlrn_community::list_users $community_id]

# Precompute these items rather than repeat them for each user

set type_id  [notification::type::get_type_id -short_name forums_forum_notif]
set interval_id [notification::get_interval_id -name instant]
set delivery_method_id [notification::get_delivery_method_id -name email]

db_transaction {

    foreach user $users {
        # Add notification for this user if they're not already subscribed for an instant alert
        set user_id [ns_set get $user user_id]
        if {[notification::request::get_request_id -user_id $user_id -type_id $type_id -object_id $forum_id] eq ""} {
            notification::request::new -type_id $type_id -user_id $user_id -object_id $forum_id -interval_id $interval_id \
                -delivery_method_id $delivery_method_id
        }
    }

    # Now flip the forum's autosubscription flag so new users will get autosubscribed.
    db_dml update_autosubscribe_p {}

}

ad_returnredirect $return_url

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

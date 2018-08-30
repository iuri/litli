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
    Figure out if ds and monitoring exists and lists the active users

    @author Nima Mazloumi (mazloumi@uni-mannheim.d)
    @creation-date 2004-08-09
    @version $Id: cockpit.tcl,v 1.1.1.1 2005/04/29 10:57:31 ecwork Exp $
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set admin_pretty_name [parameter::get -localize -parameter dotlrn_admin_pretty_name]

# Does Developer support exists
set ds_exists_p 0
set ds_url "/ds/"

if { [site_node::exists_p -url "/ds"] } {
   set ds_exists_p 1
} else {
   set url [site_node::get_package_url -package_key "acs-developer-support"]
   if { $url ne "" } {
       set ds_exists_p 1
   }
}

# Does monitoring exists
set monitor_exists_p 0
set monitor_url "/monitor/"

if { [site_node::exists_p -url "/monitor"] } {
   set monitor_exists_p 1
} else {
   set monitor_url [site_node::get_package_url -package_key "monitoring"]
   if { $monitor_url ne "" } {
       set monitor_exists_p 1
   }
}

# Who is currently online
set whos_online_interval [whos_online::interval]

template::list::create \
    -name online_users \
    -multirow online_users \
    -elements {
        name {
            label "[_ dotlrn.Name]"
            html { align left }
            link_url_col url
        }
        online_time_pretty {
            label "[_ dotlrn.Minutes]"
            html { align right }
        }
        username {
            label "[_ dotlrn.Email_1]"
            link_url_col email
            html { align left nowrap }
        }
        user_id {
            label "[_ dotlrn.User_ID_1]"
            link_url_col id_url
            html { align right }
        }
    }


set users [list]

set count 0

foreach user_id [whos_online::user_ids] {
    acs_user::get -user_id $user_id -array user

    set first_request_minutes [expr {[whos_online::seconds_since_first_request $user_id] / 60}]
    lappend users [list \
                       "$user(first_names) $user(last_name)" \
                       [acs_community_member_url -user_id $user_id] \
                       "$first_request_minutes" \
                       "$user(username)" \
                       "mailto:$user(email)" \
                       "$user(user_id)" \
                       "/acs-admin/users/one?user_id=$user(user_id)" ]
    incr count
}


set users [lsort -index 0 $users]

multirow create online_users name url online_time_pretty username email user_id id_url

foreach elm $users {
    multirow append online_users \
        [lindex $elm 0] \
        [lindex $elm 1] \
        [lindex $elm 2] \
        [lindex $elm 3] \
        [lindex $elm 4] \
        [lindex $elm 5] \
        [lindex $elm 6]
}

ad_return_template
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

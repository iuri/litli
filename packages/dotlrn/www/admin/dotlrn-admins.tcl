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
    Displays Administrators dotLRN admin page

    @author Hector Amado (hr_amado@galileo.edu)
    @creation-date 2004-06-28
    @cvs-id $Id: dotlrn-admins.tcl,v 1.9.4.1 2015/09/11 11:40:51 gustafn Exp $
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set context_bar "[_ dotlrn.Administrators]"
set referer [ns_conn url]

set dotlrn_admins_group [db_string group_id_from_name "
            select group_id from groups where group_name='dotlrn-admin'" -default ""]

set admin_id [ad_conn user_id]

set elements [list user \
		  [list label "[_ dotlrn.User]"\
                   link_url_col user_url ] \
                   remove \
                  [list label "[_ dotlrn.Remove]" \
                   link_url_col remove_url \
		       display_template { <if @dotlrn_admins.no_auto_remove@ true><center><img src="/resources/acs-subsite/Delete16.gif" width="16" height="16" border="0"></center></if> } \
                       sub_class narrow ] \
		  ]

set multirow_name dotlrn_admins
set actions ""

template::list::create \
     -name dotlrn_admins \
     -multirow $multirow_name \
     -actions $actions \
    -no_data "[_ dotlrn.No_dotlrn-admins]" \
     -elements $elements

db_multirow \
    -extend {
       user
       remove_url
       user_url
       no_auto_remove 
    } dotlrn_admins dotlrn_admins_select {} {
        append user $last_name ", " $first_names " (" $email " )"
	set remove_url [export_vars -base "admin-remove" {user_id}]
        set user_url [export_vars -base "user" {user_id}] 
       if { $user_id == $admin_id } {
            set no_auto_remove 0
	} else {
            set no_auto_remove 1
	}  
 }

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

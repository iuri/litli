#
#  Copyright (C) 2004 University of Valencia
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
    The display logic for the chat portlet

    @author agustin (Agustin.Lopez@uv.es)
    @creation-date 2004-10-10
    @version $Id: chat-portlet.tcl,v 0.1 2004/10/10

} -properties {
    context:onevalue
    user_id:onevalue
    room_create_p:onevalue
    rooms:multirow
}

array set config $cf
set shaded_p $config(shaded_p)
set list_of_package_ids $config(package_id)
set sep_package_ids [join $list_of_package_ids ", "]
set chat_url "[ad_conn package_url]/chat/"

set user_id [ad_conn user_id]
set community_id [dotlrn_community::get_community_id]
set room_create_p [permission::permission_p -object_id $user_id -privilege chat_room_create]
set default_mode [parameter::get -parameter DefaultClient -default "ajax"]
set num_rooms 0

if { $community_id eq 0 } {
	set query_name "rooms_list_all"
} else {
	set query_name "rooms_list"
}
db_multirow -extend { can_see_p room_enter_url room_html_url html_text } rooms $query_name {} {
	set can_see_p 0
	if { $user_p || $admin_p } {
		set can_see_p 1
		set num_rooms [expr {$num_rooms + 1}]
	}   
    set room_enter_url [export_vars -base "${base_url}room-enter" {room_id {client $default_mode}}]
    set room_html_url [export_vars -base "${base_url}room-enter" {room_id {client html}}]
    set html_text [_ chat.html_client_msg]
}

template::list::create -name chat_rooms -multirow rooms \
    -no_data [_ chat.There_are_no_rooms_available] \
    -filters {can_see_p {default_value 1}} \
    -elements {
        pretty_name {
            label "[_ chat.Room_name]"
            link_url_col room_enter_url
            link_html {title "[_ chat.Enter_rooms_pretty_name]"}
        }
        description {
            label "[_ chat.Description]"
        }
        html_mode {
            label "[_ chat-portlet.html_mode]"
            link_url_col room_html_url
            display_col html_text
            link_html {title "[_ chat.Enter_html_pretty_name]"}
        }
    }

ad_return_template

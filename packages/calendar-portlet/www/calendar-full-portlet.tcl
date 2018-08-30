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

# www/calendar-full-portlet.tcl
ad_page_contract {
    The display logic for the calendar portlet

    @author Arjun Sanyal (arjun@openforce.net)
    @cvs_id $Id: calendar-full-portlet.tcl,v 1.41.2.3 2017/02/13 10:55:46 gustafn Exp $
} {
    {view ""}
    {page_num:naturalnum ""}
    {date ""}
    {period_days:naturalnum,optional}
    {julian_date ""}
} -properties {
    
} -validate {
    valid_date -requires { date } {
        if {$date ne "" } {
            if {[catch {set date [clock format [clock scan $date] -format "%Y-%m-%d"]} err]} {
                ad_complain "Your input ($date) was not valid. It has to be in the form YYYY-MM-DD."
            }
        }
    }
}

# get stuff out of the config array
array set config $cf
if {$view eq ""} {
    set view $config(default_view)
}
set list_of_calendar_ids $config(calendar_id)

set ad_conn_url [ad_conn url]
set calendar_url [ad_conn package_url]calendar/

set scoped_p $config(scoped_p)
if {$scoped_p == "t"} {
    set show_calendar_name_p 1
} else {
    set show_calendar_name_p 0
}

# Styles for calendar
template::head::add_css -href "/resources/calendar/calendar.css"
template::head::add_css -alternate -href "/resources/calendar/calendar-hc.css" -title "highContrast"

# set the period_days for calendar's list view, therefore we need
# to check which instance of calendar is currently displayed
if {[apm_package_installed_p dotlrn]} {
    set site_node [site_node::get_node_id_from_object_id -object_id [ad_conn package_id]]
    set dotlrn_package_id [site_node::closest_ancestor_package -node_id $site_node -package_key dotlrn -include_self]
    set community_id [db_string get_community_id {select community_id from dotlrn_communities_all where package_id=:dotlrn_package_id} -default [db_null]]
} else {
    set community_id ""
}

set calendar_id [lindex $list_of_calendar_ids 0]
db_0or1row select_calendar_package_id {select package_id from calendars where calendar_id=:calendar_id}
if { ![info exists period_days] } {
    if { ([info exists community_id] && $community_id ne "") } {
        set period_days [parameter::get -package_id $package_id -parameter ListView_DefaultPeriodDays -default 31]
    } else {
        foreach calendar $list_of_calendar_ids {
            # returns 1 if calendar_id is user's personal calendar
            if { [calendar::personal_p -calendar_id $calendar] } {
                db_0or1row select_calendar_package_id {select package_id from calendars where calendar_id=:calendar}
                set period_days [parameter::get -package_id $package_id -parameter ListView_DefaultPeriodDays -default 31]
                break
            }
        }
    }
}

if {[llength $list_of_calendar_ids] > 1} {
    set force_calendar_id [calendar::have_private_p -return_id 1 -calendar_id_list $list_of_calendar_ids -party_id [ad_conn user_id]]
} else {
    set force_calendar_id [lindex $list_of_calendar_ids 0]
}

# permissions
set create_p [permission::permission_p -object_id $force_calendar_id -privilege cal_item_create]
set edit_p [permission::permission_p -object_id $force_calendar_id -privilege cal_item_edit]
set admin_p [permission::permission_p -object_id $force_calendar_id -privilege calendar_admin]

if {$view eq ""} {
    set view $config(default_view)
}

# set up some vars
if {$date eq ""} {
    if {$julian_date eq ""} {
        set date [dt_sysdate]
    } else {
        set date [db_string select_from_julian "select to_date(:julian_date ,'J') from dual"]
    }
}

# global variables
set current_date $date
set date_format "YYYY-MM-DD HH24:MI"
set return_url "[ns_conn url]?[ns_conn query]"

set add_item_url [export_vars -base "calendar/cal-item-new" {{date $current_date} {time_p 1} return_url}]

if {$view eq "list"} {
    set sort_by [ns_queryget sort_by]


    set start_date [ns_fmttime [expr [ns_time]] "%Y-%m-%d 00:00"]
    set end_date [ns_fmttime [expr {[ns_time] + 60*60*24*$period_days}] "%Y-%m-%d 00:00"]

}

set export [ns_queryget export]

if { [lsearch [list csv vcalendar] $export] != -1 } {
    set user_id [ad_conn user_id]
    set package_id [ad_conn package_id]
    if {$view eq "list"} {
        calendar::export::$export -calendar_id_list $list_of_calendar_ids -view $view -date $date -start_date $start_date -end_date $end_date $user_id $package_id
    } else {
        calendar::export::$export -calendar_id_list $list_of_calendar_ids -view $view -date $date $user_id $package_id
    }
    ad_script_abort
} else {
    ad_return_template 
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

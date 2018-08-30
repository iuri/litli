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

# www/calendar-portlet.tcl
ad_page_contract {
    The display logic for the calendar portlet

    @author Arjun Sanyal (arjun@openforce.net)
    @cvs_id $Id: calendar-portlet.tcl,v 1.35.2.3 2017/02/13 10:55:46 gustafn Exp $
} {
    {view ""}
    {page_num:naturalnum ""}
    {date ""}
    {period_days:naturalnum,optional}
    {julian_date ""}
} -properties {
    
}  -validate {
    valid_date -requires { date } {
        if {$date ne "" } {
            if {[catch {set date [clock format [clock scan $date] -format "%Y-%m-%d"]} err]} {
                ad_complain "Your input ($date) was not valid. It has to be in the form YYYY-MM-DD."
            }
        }
    }
}

set return_url "[ns_conn url]?[ns_conn query]"
set period_days [parameter::get -parameter ListView_DefaultPeriodDays -default 30]

# get stuff out of the config array
array set config $cf
set view $config(default_view)
set list_of_calendar_ids $config(calendar_id)
set calendar_url [ad_conn package_url]calendar/

set scoped_p $config(scoped_p)

if {$scoped_p == "t"} {
    set show_calendar_name_p 1
} else {
    set show_calendar_name_p 0
}

if {[llength $list_of_calendar_ids] > 1} {
    set force_calendar_id [calendar::have_private_p -return_id 1 -calendar_id_list $list_of_calendar_ids -party_id [ad_conn user_id]]
} else {
    set force_calendar_id [lindex $list_of_calendar_ids 0]
}

# set up some vars
set date [ns_queryget date]
if {$date eq ""} {
    set date [dt_sysdate]
}
set current_date $date
set date_format "YYYY-MM-DD HH24:MI"

if {$view eq "list"} {
    set sort_by [ns_queryget sort_by]

    set thirty_days [expr {60*60*24*30}]

    set start_date [ns_fmttime [expr {[ns_time] - $thirty_days}] "%Y-%m-%d 00:00"]
    set end_date [ns_fmttime [expr {[ns_time] + $thirty_days}] "%Y-%m-%d 00:00"]

}

template::head::add_css -href "/resources/calendar/calendar.css"
template::head::add_css -alternate -href "/resources/calendar/calendar-hc.css" -title "highContrast"

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

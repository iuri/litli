
# /packages/calendar/www/cal-item-create.tcl

ad_page_contract {
    
    Creation of new recurrence for cal item
    
    @author Ben Adida (ben@openforce.net)
    @creation-date 10 Mar 2002
    @cvs-id $Id: cal-item-create-recurrence.tcl,v 1.9.2.4 2017/04/22 12:25:25 gustafn Exp $
} {
    cal_item_id:naturalnum,notnull
    {return_url:localurl "./"}
    {days_of_week:multiple ""}
} 


auth::require_login
permission::require_permission -object_id $cal_item_id -privilege cal_item_write

calendar::item::get -cal_item_id $cal_item_id -array cal_item

set dow_string ""
foreach dow {
    {"#calendar.Sunday#" 0} {"#calendar.Monday#" 1} {"#calendar.Tuesday#" 2} 
    {"#calendar.Wednesday#" 3} {"#calendar.Thursday#" 4} {"#calendar.Friday#" 5}
    {"#calendar.Saturday#" 6}
} {
        if {[lindex $dow 1] == $cal_item(day_of_week) - 1} {
                set checked_html "CHECKED"
        } else {
                set checked_html ""
        }

    set dow_string "$dow_string <INPUT TYPE=checkbox name=days_of_week value=[lindex $dow 1] $checked_html id=\"cal_item:elements:interval_type:days_of_week:[lindex $dow 1]\" >[lindex $dow 0] &nbsp;\n"
}

set recurrence_options [list \
                            [list [_ calendar.day_s] day] \
                            [list "$dow_string [_ calendar.of_the_week]" week] \
                            [list "[_ calendar.day] $cal_item(day_of_month) [_ calendar.of_the_month]" month_by_date] \
                            [list "[_ calendar.same] $cal_item(pretty_day_of_week) [_ calendar.of_the_month]" month_by_day] \
                            [list [_ calendar.year] year]]



ad_form -name cal_item  -export {return_url} -form {
    {cal_item_id:key}

    {every_n:integer,optional
        {label "[_ calendar.Repeat_every]"}
        {value 1}
        {html {size 4}} 
    }

    {interval_type:text(radio)
        {label ""}
        {options $recurrence_options}
    }

    {recur_until:date
        {label "[_ calendar.lt_Repeat_this_event_unt]"}
        {format "YYYY MM DD"}
        {after_html {<input type="button" id="cal-item-recur-until" style="height:23px; width:23px; background: url('/resources/acs-templating/calendar.gif');"> \[<b>[_ calendar.y-m-d]</b>\]} 
        }
        
    }

    {submit:text(submit) {label "[_ calendar.Add_Recurrence]"}}

} -validate {
    {recur_until
        {
            [calendar::item::dates_valid_p -start_date $cal_item(start_date) -end_date [calendar::to_sql_datetime -date $recur_until -time "" -time_p 0]]
        }
       {[_ calendar.start_time_before_end_time]}
    }
} -edit_data {

    # To support green calendar
    #set recur_until [split $recur_until "-"]
    #lappend recur_until ""
    #lappend recur_until ""
    #lappend recur_until ""
    #lappend recur_until "DD MONTH YYYY"
    #set recur_until "[template::util::date::get_property day $recur_until] [template::util::date::get_property long_month_name $recur_until] [template::util::date::get_property year $recur_until]"

    calendar::item::add_recurrence \
        -cal_item_id $cal_item_id \
        -interval_type $interval_type \
        -every_n $every_n \
        -days_of_week $days_of_week \
        -recur_until [calendar::to_sql_datetime -date $recur_until -time "" -time_p 0]
} -edit_request {
    #set aux [template::util::date::from_ansi $cal_item(start_date)]
    #set recur_until [lindex $aux 0]
    #append recur_until "-"
    #append recur_until [lindex $aux 1]
    #append recur_until "-"
    #append recur_until [lindex $aux 2]
    set recur_until [calendar::from_sql_datetime -sql_date $cal_item(start_date)  -format "YYY-MM-DD"]
    set interval_type week
} -after_submit {
    ad_returnredirect $return_url
    ad_script_abort
} -has_submit 1

template::add_event_listener \
    -id cal-item-recur-until \
    -script {showCalendarWithDateWidget('recur_until', 'y-m-d');}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

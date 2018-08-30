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

    edit a term

    @author yon (yon@openforce.net)
    @author Don Baccus (dhogaza@pacifier.com)

    @creation-date 2002-03-14
    @version $Id: term-edit.tcl,v 1.14.2.2 2016/10/14 17:59:24 gustafn Exp $

} -query {
    term_id:naturalnum,notnull
} -properties {
    context_bar:onevalue
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

if {![db_0or1row select_term_info {}]} {
    ad_return_complaint 1 "<li>[_ dotlrn.Invalid] term_key $term_id</li>"
    ad_script_abort
}

set referer [export_vars -base term {term_id}]
set context_bar [list [list terms [_ dotlrn.Terms]] [list $referer "$term_name $term_year"] [_ dotlrn.Edit]]

ad_form -name edit_term -export term_pretty_name -select_query_name select_term_info -form {

    term_id:key

    {term_name:text               {label "[_ dotlrn.Term_eg_Spring_Fall]"}
                                  {html {size 30}}}

    {term_year:text               {label "[_ dotlrn.lt_Year_eg_2003_20032004]"}
                                  {html {size 9 maxlength 9}}}

    {start_date:text(text)
	{label "[_ dotlrn.Start_Date]"}
	#{format {[lc_get formbuilder_date_format]}}
        {html {id start_date}}
        {after_html {<input type="reset" id="start_date-control" value=" ... "> \[<b>yyyy-mm-dd </b>\]
        }}
    }

    {end_date:text(text)
	{label "[_ dotlrn.End_Date]"}
	#{format {[lc_get formbuilder_date_format]}}
	{html {id end_date}}
        {after_html {<input type="reset" id="end_date-control" value=" ... "> \[<b>yyyy-mm-dd </b>\]
        }}
    }
    
} -validate {
    {start_date
        { [template::util::date::compare $start_date $end_date] <= 0 }
        "The term must start before it ends"
    }
    {end_date
        { [template::util::date::compare [template::util::date::from_ansi [clock format [clock seconds] -format "%Y-%m-%d"]] $end_date] <= 0 }
        "The term must end in the future"
    }
} -edit_data {

    # Setting the right format to send to the procedures
    # dotlrn_term::start_end_dates_to_term_year  and
    # dotlrn_term::new

    set start_date [split $start_date "-"]
    lappend start_date "" "" "" "MONTH DD YYYY"
    
    set end_date [split $end_date "-"]
    lappend end_date "" "" "" "MONTH DD YYYY"

    dotlrn_term::edit \
        -term_id $term_id \
        -term_name $term_name \
        -term_year [string trim $term_year] \
        -start_date $start_date \
        -end_date $end_date

    ad_returnredirect $referer
    ad_script_abort
} -on_request {
    template::add_event_listener -id start_date-control -script {showCalendar('start_date', 'yyyy-mm-dd');}
    template::add_event_listener -id end_date-control   -script {showCalendar('end_date', 'yyyy-mm-dd');}
}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

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

# dotlrn/tcl/term-procs.tcl

ad_library {
    @author yon (yon@openforce.net)
    @creation-date Dec 12, 2001
    @cvs-id $Id: term-procs.tcl,v 1.13.2.2 2017/04/21 20:45:16 gustafn Exp $
}

namespace eval dotlrn_term {

    ad_proc -private get_date_format {} {
        get default date format
    } {
        return "YYYY MM DD"
    }

    ad_proc -public new {
        {-term_name:required}
        {-term_year:required}
        {-start_date:required}
        {-end_date:required}
    } {
        create a new term
    } {
        set start_date "[template::util::date::get_property year $start_date] [template::util::date::get_property month $start_date] [template::util::date::get_property day $start_date]"
        set end_date "[template::util::date::get_property year $end_date] [template::util::date::get_property month $end_date] [template::util::date::get_property day $end_date]"
        set date_format [get_date_format]
        set term_id [db_nextval acs_object_id_seq]

        db_dml insert_term {}
    }

    ad_proc -public edit {
        {-term_id:required}
        {-term_name:required}
        {-term_year:required}
        {-start_date:required}
        {-end_date:required}
    } {
        edit a term
    } {
        set start_date "[template::util::date::get_property year $start_date] [template::util::date::get_property month $start_date] [template::util::date::get_property day $start_date]"
        set end_date "[template::util::date::get_property year $end_date] [template::util::date::get_property month $end_date] [template::util::date::get_property day $end_date]"
        set date_format [get_date_format]

        db_dml update_term {}
    }

    ad_proc -public get_term_name {
        {-term_id:required}
    } {
        get the term name for this term object
    } {
        return [db_string get_term_name {}]
    }

    ad_proc -public get_term_year {
        {-term_id:required}
    } {
        get the term year for this term object
    } {
        return [db_string get_term_year {}]
    }

    ad_proc -public get_term_info {
        {-term_id:required}
        {-term_name_var "term_name"}
        {-term_year_var "term_year"}
    } {
        get the term name and year for this term object
    } {
        db_1row get_term_info {}
        upvar 1 $term_name $term_name_var $term_year $term_year_var
    }

    ad_proc -public get_start_date {
        {-term_id:required}
    } {
        get the start date of this term
    } {
        set date_format [get_date_format]
        db_1row get_start_date {}

        return [template::util::date::create $year $month $day "" "" "" $date_format]
    }

    ad_proc -public get_end_date {
        {-term_id:required}
    } {
        get the end date of this term
    } {
        set date_format [get_date_format]
        db_1row get_end_date {}

        return [template::util::date::create $year $month $day "" "" "" $date_format]

    }

    ad_proc -public start_end_dates_to_term_year {
        {-start_date:required}
        {-end_date:required}
    } {
        generate a "term year" string from the start and end dates
        a "term year" is either a 4-digit year like "2002" or 
        two different 4-digit year separated by a / like "2002/2004"
    } {
        set start_year [template::util::date::get_property year $start_date]
        set end_year [template::util::date::get_property year $end_date]

        if {$start_year ne $end_year } {
            return "$start_year/$end_year"
        }
        
        return $start_year
    }

    ad_proc -public get_future_terms_as_options {
    } {
        get future term info in a list of lists for a html select option widget
    } {
        return [db_list_of_lists get_future_terms_select {}]
    }

}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

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
    Create a New Class Instance

    @author Ben Adida (ben@openforce.net)
    @creation-date 2001-10-05
    @version $Id: class-instance-new.tcl,v 1.34.2.1 2015/09/11 11:40:49 gustafn Exp $
} -query {
    class_key:notnull
    {referer ""}
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set join_options [list [list [_ dotlrn.Open] open] [list "[_ dotlrn.Needs_Approval]" "needs approval"] [list [_ dotlrn.Closed] closed]]
set term_options [db_list_of_lists select_terms_for_select_widget {}]

ad_form -name add_class_instance -form {

    {term:integer(select)
	{label "#dotlrn.Term#"}
	{options $term_options}
	{help_text "[_ dotlrn.Term_help]"}
    }

    {pretty_name:text(text),optional
	{label "#dotlrn.Name#"}
	{html {size 60 maxlength 100}}
	{help_text "[_ dotlrn.Name_help]"}
    }

    {description:text(textarea),optional
	{label "#dotlrn.Description#"}
	{html {rows 5 cols 60}}
	{help_text "[_ dotlrn.lt_do_not_use_p_tags]"}
    }	
    
    {active_start_date:date(date),to_sql(ansi),from_sql(ansi),optional
	{label "#dotlrn.Start_date#"}
	{help_text "[_ dotlrn.Start_date_help]"}
    }

    {active_end_date:date(date),to_sql(ansi),from_sql(ansi),optional
	{label "#dotlrn.End_date#"}
	{help_text "[_ dotlrn.End_date_help]"}
    }
    
    {join_policy:text(select)
	{label "#dotlrn.Join_Policy#"}
	{options $join_options}
	{help_text "[_ dotlrn.Join_Policy_help]"}
    }

    {class_key:text(hidden)
	{label "[parameter::get -localize -parameter classes_pretty_name] [_ dotlrn.Key]"}
	{value $class_key}
    }

    {add_instructor:text(radio)
	{label "[_ dotlrn.Add_Professor]"}
	{options {{"[_ dotlrn.Yes]" 1} {"[_ dotlrn.No]" 0}}}
	{value 1}
	{help_text "[_ dotlrn.Add_Professor_help]"}
    }
	
    {class_instance_key:text(text),optional
	{label "[_ dotlrn.Class_instance_key]"}
	{html {size 60}}
	{help_text "[_ dotlrn.Class_instance_key_help]"}
    }
	
    {referer:text(hidden)
	{label "[_ dotlrn.Referer]"}
	{value "$referer"}
    }

} -on_request {
    if {![db_0or1row select_class_info {}]} {
	set pretty_name ""
	set description ""
    }
} -on_submit {

    set class_instance_id [dotlrn_class::new_instance \
        -class_instance_key $class_instance_key \
        -class_key $class_key \
        -term_id $term \
        -pretty_name $pretty_name \
        -description $description \
        -join_policy $join_policy \
    ]

    # Update the time
    # This should go into the dotlrn_club::new procedure and the dotlrn_community::new
    # But this would involve too much code changes at the moment, so we stick with this for 
    # the time being :-) MS (openacs@sussdorff.de)

    db_dml update_community_info {}

    if {$referer eq ""} {
        set referer [export_vars -base [dotlrn::get_admin_url]/class {class_key}]
    }

    if {${add_instructor}} {
        set community_id $class_instance_id 
        ad_returnredirect [export_vars -base add-instructor {community_id referer}]
        ad_script_abort
    }

    ad_returnredirect $referer
    ad_script_abort
}

# Used by en_US version of new_class_instance message
set class_instances_pretty_name [parameter::get -localize -parameter class_instances_pretty_name]

set context_bar [list \
                     [list classes [parameter::get -localize -parameter classes_pretty_plural]] \
                     [list "class?class_key=$class_key" $pretty_name] \
                     [_ dotlrn.new_class_instance]]

set class_name $pretty_name

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

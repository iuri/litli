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
    create a new club - input form

    @author yon (yon@openforce.net)
    @creation-date 2001-12-03
    @version $Id: club-new.tcl,v 1.22.6.1 2015/09/11 11:40:50 gustafn Exp $
} -query {
    {referer "clubs"}
} -properties {
    title:onevalue
    context_bar:onevalue
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set join_options [list [list [_ dotlrn.Open] open] [list "[_ dotlrn.Needs_Approval]" "needs approval"] [list [_ dotlrn.Closed] closed]]

ad_form -name add_club -form {
    
    {pretty_name:text(text)
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
    {referer:text(hidden)
	{label "[_ dotlrn.Referer]"}
	{value "$referer"}
    }

} -on_submit {

    set key [dotlrn_club::new \
        -description $description \
        -pretty_name $pretty_name \
        -join_policy $join_policy]

    # Update the time
    # This should go into the dotlrn_club::new procedure and the dotlrn_community::new
    # But this would involve too much code changes at the moment, so we stick with this for 
    # the time being :-) MS (openacs@sussdorff.de)

    db_dml update_community_info {update dotlrn_communities_all
	set active_start_date = :active_start_date,
	active_end_date = :active_end_date
	where community_id = :key
    }

    ad_returnredirect $referer
    ad_script_abort
}


set clubs_pretty_name [parameter::get -localize -parameter clubs_pretty_name]
set title "[_ dotlrn.new_community]"
set context_bar [list [list clubs [parameter::get -localize -parameter clubs_pretty_plural]] $title]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

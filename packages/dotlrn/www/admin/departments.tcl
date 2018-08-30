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
    Displays dotLRN departments admin page

    @author yon (yon@openforce.net)
    @creation-date 2002-01-20
    @version $Id: departments.tcl,v 1.13.2.2 2017/01/26 11:46:02 gustafn Exp $
} -query {
    {keyword ""}
    {orderby:token "department_name,asc"}
    page:naturalnum,optional
} -properties {
    title:onevalue
    context_bar:onevalue
    departments:multirow
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set title [parameter::get -localize -parameter departments_pretty_plural]
set context_bar [parameter::get -localize -parameter departments_pretty_plural]
set referer departments
set can_create [dotlrn_class::can_create]
set departments_pretty_name [parameter::get -localize -parameter departments_pretty_name]
set departments_pretty_plural [parameter::get -localize -parameter departments_pretty_plural]
set classes_pretty_name [parameter::get -localize -parameter classes_pretty_name]

set actions [list "[_ dotlrn.new_department]" "[export_vars -base "department-new" -url { referer }]"]

if { $keyword ne "" } {
    set keyword_clause [db_map departments_keyword]
} {
    set keyword_clause [db_map departments_without_keyword]
}

template::list::create \
    -filters { keyword {} } \
    -name departments \
    -multirow departments \
    -actions $actions \
    -pass_properties { can_create {} referer {} } \
    -key department_key \
    -page_size 50 \
    -page_flush_p t \
    -page_query_name departments_pagination \
    -elements {
        department_name {
            label "[_ dotlrn.department_name]"
	    orderby_asc {department_name asc}
	    orderby_desc {department_name desc}	
	    link_url_eval {[export_vars -base "department" { department_key }]}
	}
        actions {
            label "[_ dotlrn.Actions]"
	    display_template {
		<if @can_create@>
		\[
		<a href="class-new?department_key=@departments.department_key@&referer=department?department_key=@departments.department_key@">[_ dotlrn.new_class_1]</a>
		</if>
		<if @departments.n_classes@ eq 0>
		|
		<a href="department-delete?department_key=@departments.department_key@&pretty_name=@departments.department_name@&referer=departments">[_ dotlrn.Delete]</a>
		</if>
		\]
	    }
        }
    }



db_multirow departments select_departments {}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

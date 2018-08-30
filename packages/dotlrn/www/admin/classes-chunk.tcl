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
    Displays dotLRN classes admin page

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-11-04
    @version $Id: classes-chunk.tcl,v 1.13.4.3 2016/11/08 13:56:02 gustafn Exp $
} -query {
} -properties {
    classes:multirow
}


if {![info exists department_key] || $department_key eq ""} {
    set department_key ""
}

set departments [db_list_of_lists select_departments_for_select_widget {
    select dotlrn_departments_full.pretty_name,
           dotlrn_departments_full.department_key
    from dotlrn_departments_full
    order by dotlrn_departments_full.pretty_name,
             dotlrn_departments_full.department_key
}]
set departments [linsert $departments 0 [list [_ dotlrn.All] ""]]

form create department_form  -has_submit 1

element create department_form department_key \
    -label [_ dotlrn.Department] \
    -datatype text \
    -widget select \
    -options $departments \
    -html {id department_form-department_key} \
    -value $department_key

template::add_event_listener -id "department_form-department_key" -event change -script {document.department_form.submit();}

if {[form is_valid department_form]} {
    form get_values department_form department_key
}

if {![info exists referer] || $referer eq ""} {
    set referer "classes"
}



set query select_classes
set page_query select_classes_paginator
if {$department_key ne ""} {
    set query select_classes_by_department
    set page_query select_classes_by_department_paginator
}

if { ([info exists keyword] && $keyword ne "") } {
    set keyword_clause [db_map classes_keyword]
} else {
    set keyword_clause ""
}

set can_create [dotlrn_class::can_create]
set can_instantiate [dotlrn_class::can_instantiate]

# Used in the en_US versions of some of the messages in the adp
set classes_pretty_name [parameter::get -localize -parameter classes_pretty_name]
set classes_pretty_plural [parameter::get -localize -parameter classes_pretty_plural]
set class_instances_pretty_name [parameter::get -localize -parameter class_instances_pretty_name]

set actions ""

if { $can_create } {
    set actions [list "[_ dotlrn.new_class_1]" "[export_vars -base "class-new" -url { department_key referer }]" "[_ dotlrn.new_class_1]"]
}

template::list::create \
    -name classes \
    -multirow classes \
    -actions $actions \
    -pass_properties { can_instantiate {} } \
    -filters { department_key {} keyword {} } \
    -key class_key \
    -page_size 50 \
    -page_flush_p t \
    -page_query_name $page_query \
    -elements {
        department_name {
            label "[parameter::get -localize -parameter departments_pretty_name]"
	    orderby_asc {department_name asc}
	    orderby_desc {department_name desc}
            link_url_eval {[export_vars -base "department" { department_key }]}
        }
	pretty_name {
	    label "[_ dotlrn.class_name]"
	    orderby_asc {pretty_name asc}
	    orderby_desc {pretty_name desc}
            link_url_eval {[export_vars -base "class" { class_key }]}
        }
        n_instances {
	    label "[parameter::get -localize -parameter class_instances_pretty_plural]"
	    orderby_asc {n_instances asc}
	    orderby_desc {n_instances desc}
        }
        actions {
            label "[_ dotlrn.Actions]"
	    display_template {
		<if @can_instantiate@>
		<small>\[
            <a href="class-instance-new?class_key=@classes.class_key@&amp;referer=$referer" title="[_ dotlrn.new_class_instance]">[_ dotlrn.new_class_instance]</a>
		       \]</small>
		</if>
        <if @classes.n_instances@ eq 0>
		<small>\[
            <a href="class-delete?class_key=@classes.class_key@" title="[_ dotlrn.lt_Delete_class]">[_ dotlrn.lt_Delete_class]</a>
		       \]</small>
        </if>
	    }
        }
    }

db_multirow classes $query {}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

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
    Displays class instances of a term

    @author yon (yon@openforce.net)
    @creation-date 2002-03-07
    @version $Id: term.tcl,v 1.19.2.5 2017/01/26 11:46:02 gustafn Exp $
} -query {
    term_id:integer,notnull
    {department_key ""}
    {orderby:token "department_name,asc"}
    page:naturalnum,optional
    {keyword ""}
    {referer "terms"}
} -properties {
    classes:multirow
}

ns_log Notice "Running script term.tcl"
#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set departments [db_list_of_lists select_departments_for_select_widget {
    select dotlrn_departments_full.pretty_name,
           dotlrn_departments_full.department_key
    from dotlrn_departments_full
    order by dotlrn_departments_full.pretty_name,
             dotlrn_departments_full.department_key
}]
set departments [linsert $departments 0 {All ""}]

form create department_form  -has_submit 1

element create department_form department_key \
    -label "[_ dotlrn.Department]" \
    -datatype text \
    -widget select \
    -options $departments \
    -html {id department_form-department_key} \
    -value $department_key

element create department_form term_id \
    -label "[_ dotlrn.Term_ID]" \
    -datatype integer \
    -widget hidden \
    -value $term_id

if {[form is_valid department_form]} {
    form get_values department_form department_key term_id
}


ns_log Notice "FLAG1"

set terms [db_list_of_lists select_terms_for_select_widget {
    select dotlrn_terms.term_name || ' ' || dotlrn_terms.term_year,
           dotlrn_terms.term_id
    from dotlrn_terms
    order by dotlrn_terms.start_date,
             dotlrn_terms.end_date
}]
set terms [linsert $terms 0 {All -1}]

ns_log Notice "FLAG2"

form create term_form -has_submit 1

element create term_form term_id \
    -label "[_ dotlrn.Term]" \
    -datatype integer \
    -widget select \
    -options $terms \
    -html {id term_form-term_id} \
    -value $term_id

element create term_form department_key \
    -label "[_ dotlrn.Department]" \
    -datatype text \
    -widget hidden \
    -value $department_key

if {[form is_valid term_form]} {
    form get_values term_form term_id department_key

    if {$term_id != -1} {
        ad_returnredirect [export_vars -base term {term_id department_key}]
        ad_script_abort
    }
}

template::add_event_listener -id "term_form-term_id" -event change -script {document.term_form.submit();}
template::add_event_listener -id "department_form-department_key" -event change -script {document.department_form.submit();}


ns_log Notice "FLAG3"

set query "select_classes"
set paginator_query "select_classes_paginator"
if {$term_id == -1} {
    set query "select_all_classes"
    set paginator_query "select_all_classes_paginator"
}

if {$department_key ne ""} {
    append query "_by_department"
    append paginator_query "_by_department"
}

if { $keyword ne "" } {
    set keyword_clause [db_map select_all_instances_keyword]
} else {
    set keyword_clause [db_map select_all_instances_without_keyword]
}
if {$term_id == -1} {
    set title "[_ dotlrn.All_Terms]"
    set context_bar [list [list terms [_ dotlrn.Terms]] "[_ dotlrn.All_Terms]"]
} else {
    if {[db_0or1row select_term_info {}]} {
        set title "$term_name $term_year ($start_date - $end_date)"
        set context_bar [list [list terms [_ dotlrn.Terms]] "$term_name $term_year"]
    } else {
        set title "[_ dotlrn.Unknown_Term]"
        set context_bar [list [list terms [_ dotlrn.Terms]] "[_ dotlrn.Unknown_Term]"]
    }
}

# Used by the en_US version of the no_class_instances message in the adp
set class_instances_pretty_plural [parameter::get -localize -parameter class_instances_pretty_plural]

set elements [list department_name \
		  [list label "[parameter::get -localize -parameter departments_pretty_name]" \
		       orderby_asc {department_name asc, class_name asc, pretty_name asc} \
		       orderby_desc {department_name desc, class_name desc, pretty_name desc} \
		       link_url_eval {[export_vars -base "department" { department_key }]}] \
		  class_name \
		  [list label "[parameter::get -localize -parameter classes_pretty_name]" \
		       orderby_asc {class_name asc, pretty_name asc} \
		       orderby_desc {class_name desc, pretty_name desc} \
		       link_url_eval {[export_vars -base "class" { class_key }]}] \
		 ]

if { $term_id == -1 } {
    lappend elements term_name \
	[list label "[_ dotlrn.term]" \
	     orderby_asc {term_name asc, pretty_name asc} \
	     orderby_desc {term_name desc, pretty_name desc}]
}

ns_log Notice "FLAG4"

lappend elements pretty_name \
    [list label "[parameter::get -localize -parameter class_instances_pretty_name]" \
	 link_url_col url \
	 orderby_asc {pretty_name asc} \
	 orderby_desc {pretty_name desc}]
lappend elements n_members \
    [list label "[_ dotlrn.members]"]
lappend elements action \
    [list label "[_ dotlrn.Actions]" \
	 display_template {
	     <center>
	     <small>
	     <a href="@classes.url@one-community-admin">[_ dotlrn.administer_link]</a>
	     </small>
	     </center>
	 }]

ns_log Notice "FLAG5"
ns_log Notice "PQ \n$paginator_query"
ns_log Notice "ELEM \n $elements"
ns_log Notice "$query"

template::list::create \
    -name classes \
    -multirow classes \
    -filters { department_key {} term_id {} keyword {} } \
    -key class_key \
    -page_size 50 \
    -page_flush_p t \
    -page_query_name $paginator_query \
    -elements $elements

db_multirow classes $query {}

ns_log Notice "FLAG999"


set term_edit_url [export_vars -base term-edit {term_id referer}]
ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

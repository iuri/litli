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
    Displays single dotLRN class page

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-11-07
    @version $Id: class.tcl,v 1.21.4.4 2017/01/26 11:46:02 gustafn Exp $
} -query {
    class_key:notnull
    {term_id:integer -1}
    {orderby:token "term_name,asc"}
    {keyword ""}
} -properties {
    pretty_name:onevalue
    description:onevalue
    class_instances:multirow
    can_instantiate:onevalue
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

# Get information about that class
if {![db_0or1row select_class_info {}]} {
    ad_returnredirect classes
    ad_script_abort
}

set description [ns_quotehtml $description]

set terms [db_list_of_lists select_terms_for_select_widget {}]
set terms [linsert $terms 0 {All -1}]

form create term_form \
    -has_submit 1

element create term_form term_id \
    -label [_ dotlrn.Term] \
    -datatype integer \
    -widget select \
    -options $terms \
    -html {class auto-term-form-submit} \
    -value $term_id

element create term_form class_key \
    -label "[_ dotlrn.Class_Key]" \
    -datatype text \
    -widget hidden \
    -value $class_key

template::add_event_listener -CSSclass auto-term-form-submit -event change -script {document.term_form.submit();}

if {[form is_valid term_form]} {
    form get_values term_form term_id class_key
}

set query select_class_instances
set page_query select_class_instances_paginator
if {$term_id == -1} {
    set query select_all_class_instances
    set page_query select_all_class_instances_paginator
}

if { $keyword ne "" } {
    set keyword_clause [db_map class_instances_keyword]
} else {
    set keyword_clause ""
}

set can_instantiate [dotlrn_class::can_instantiate]

set context_bar [list [list classes [parameter::get -localize -parameter classes_pretty_plural]] $pretty_name]
set referer "[ns_conn url]?[ns_conn query]"

# Used by some en_US messages on the adp page
set classes_pretty_name [parameter::get -localize -parameter classes_pretty_name]
set class_instances_pretty_name [parameter::get -localize -parameter class_instances_pretty_name]
set class_instances_pretty_plural [parameter::get -localize -parameter class_instances_pretty_plural]

template::list::create \
    -name class_instances \
    -multirow class_instances \
    -filters { term_id {} class_key {} keyword {} } \
    -key class_key \
    -page_size 50 \
    -page_flush_p t \
    -page_query_name $page_query \
    -elements {
        term_name {
	    display_template { @class_instances.term_name@&nbsp;@class_instances.term_year@ }
            label "[_ dotlrn.term]"
	    orderby_asc {term_name asc}
	    orderby_desc {term_name desc}
            link_url_eval {[export_vars -base "term" { term_id }]}
        }
	pretty_name {
	    label "[_ dotlrn.class_name_header]"
	    orderby_asc {pretty_name asc}
	    orderby_desc {pretty_name desc}
            link_url_col url
        }
        n_members {
	    label "[_ dotlrn.members]"
	    orderby_asc {n_members asc}
	    orderby_desc {n_members desc}
        }
        actions {
            label "[_ dotlrn.actions]"
	    display_template {
		<small>
		<a href="@class_instances.url@one-community-admin">[_ dotlrn.administer_link]</a> 
		</small>
	    }
        }
    }

db_multirow class_instances $query {}

set class_edit_url [export_vars -base class-edit {class_key referer}]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

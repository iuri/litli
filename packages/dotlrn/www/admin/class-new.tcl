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
    Create a New Class - input form

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-08-20
    @version $Id: class-new.tcl,v 1.20.4.1 2015/09/11 11:40:50 gustafn Exp $
} -query {
    {department_key ""}
    {referer classes}
} -properties {
    title:onevalue
    context_bar:onevalue
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

# Used in en_US title
set classes_pretty_name [parameter::get -localize -parameter classes_pretty_name]
set title "[_ dotlrn.new_class_1]"
set context_bar [list [list classes [parameter::get -localize -parameter classes_pretty_plural]] [_ dotlrn.new_class_navbar_name]]

form create add_class

element create add_class department_key \
    -label [parameter::get -localize -parameter departments_pretty_name] \
    -datatype text \
    -widget select \
    -options [dotlrn_department::select_as_list] \
    -value $department_key

element create add_class pretty_name \
    -label [_ dotlrn.Name] \
    -datatype text \
    -widget text \
    -html {size 60 maxlength 100}

element create add_class description \
    -label [_ dotlrn.Description] \
    -datatype text \
    -widget textarea \
    -html {rows 5 cols 60} \
    -optional

element create add_class subject_key \
    -label [_ dotlrn.Subject_key] \
    -datatype text \
    -widget text \
    -html {size 60 maxlength 100} \
    -optional

element create add_class referer \
    -label [_ dotlrn.Referer] \
    -datatype text \
    -widget hidden \
    -value $referer

if {[form is_valid add_class]} {
    form get_values add_class \
        department_key pretty_name description referer subject_key

    # If we do not provide a special subject_key make use of the pretty_name instead
    if {$subject_key eq ""} {
	set subject_key $department_key.[dotlrn::generate_key -name $pretty_name]
    }

    set class_key [dotlrn_class::new \
        -class_key $subject_key \
        -department_key $department_key \
        -pretty_name $pretty_name \
        -description $description]

    ad_returnredirect $referer
    ad_script_abort
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

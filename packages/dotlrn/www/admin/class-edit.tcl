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
    edit a class

    @author yon (yon@openforce.net)
    @creation-date 2001-03-14
    @version $Id: class-edit.tcl,v 1.14.8.1 2015/09/11 11:40:49 gustafn Exp $
} -query {
    class_key:notnull
    {referer classes}
} -properties {
    title:onevalue
    context_bar:onevalue
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

if {![db_0or1row select_class_info {}]} {
    ad_return_complaint 1 "<li>[_ dotlrn.Invalid] class_key $class_key</li>"
    ad_script_abort
}

set title "[_ dotlrn.Edit] [parameter::get -localize -parameter classes_pretty_name] $pretty_name"
set context_bar [list [list classes [parameter::get -localize -parameter classes_pretty_plural]] [_ dotlrn.Edit]]

form create edit_class

element create edit_class class_key \
    -label "[_ dotlrn.lt_Class_Key_a_short_nam]" \
    -datatype text \
    -widget hidden \
    -value $class_key

element create edit_class pretty_name \
    -label [_ dotlrn.Name] \
    -datatype text \
    -widget text \
    -html {size 60 maxlength 100}

element create edit_class description \
    -label [_ dotlrn.Description] \
    -datatype text \
    -widget textarea \
    -html {rows 5 cols 60} \
    -optional

element create edit_class referer \
    -label [_ dotlrn.Referer] \
    -datatype text \
    -widget hidden \
    -value $referer

if {[form is_request edit_class]} {
    element set_properties edit_class pretty_name -value $pretty_name
    element set_properties edit_class description -value $description
}

if {[form is_valid edit_class]} {
    form get_values edit_class \
        class_key pretty_name description referer

    db_dml update_community_type {}

    # renaming package
    set package_id [db_string get_package_id {}]
    apm_package_rename -instance_name $pretty_name -package_id $package_id

    ad_returnredirect $referer
    ad_script_abort
}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

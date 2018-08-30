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
    edit a department

    @author yon (yon@openforce.net)
    @creation-date 2001-03-14
    @version $Id: department-edit.tcl,v 1.13.8.1 2015/09/11 11:40:51 gustafn Exp $
} -query {
    department_key:notnull
    {referer "departments"}
} -properties {
    title:onevalue
    context_bar:onevalue
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

if {![db_0or1row select_department_info {}]} {
    ad_return_complaint 1 "<li>[_ dotlrn.Invalid] department_key $department_key</li>"
    ad_script_abort
}

set title "[_ dotlrn.Edit] [parameter::get -localize -parameter departments_pretty_name] $pretty_name"
set context_bar [list [list departments [parameter::get -localize -parameter departments_pretty_plural]] [_ dotlrn.Edit]]

form create edit_department

element create edit_department department_key \
    -label "[parameter::get -localize -parameter departments_pretty_name] [_ dotlrn.lt_Key_a_short_name_no_s]" \
    -datatype text \
    -widget hidden \
    -value $department_key

element create edit_department pretty_name \
    -label "[_ dotlrn.Name]" \
    -datatype text \
    -widget text \
    -html {size 60 maxlength 100}

element create edit_department description \
    -label "[_ dotlrn.Description]" \
    -datatype text \
    -widget textarea \
    -html {rows 5 cols 60} \
    -optional

element create edit_department external_url \
    -label "[_ dotlrn.External_URL]" \
    -datatype text \
    -widget text \
    -html {size 60} \
    -optional

element create edit_department referer \
    -label "[_ dotlrn.Referer]" \
    -datatype text \
    -widget hidden \
    -value $referer

if {[form is_request edit_department]} {
    element set_properties edit_department pretty_name -value $pretty_name
    element set_properties edit_department description -value $description
    element set_properties edit_department external_url -value $external_url
}

if {[form is_valid edit_department]} {
    form get_values edit_department \
        department_key pretty_name description external_url referer

    db_transaction {
        db_dml update_department {}
        db_dml update_community_type {}

        # renaming package 
        set package_id [db_string get_package_id {}]
        apm_package_rename -instance_name $pretty_name -package_id $package_id

    }

    ad_returnredirect $referer
    ad_script_abort
}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

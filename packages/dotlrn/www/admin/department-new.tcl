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
    create a new department

    @author yon (yon@openforce.net)
    @creation-date 2001-01-20
    @version $Id: department-new.tcl,v 1.12.8.1 2015/09/11 11:40:51 gustafn Exp $
} -query {
    {referer "departments"}
} -properties {
    title:onevalue
    context_bar:onevalue
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set title "[_ dotlrn.New] [parameter::get -localize -parameter departments_pretty_name]"
set context_bar [list [list departments [parameter::get -localize -parameter departments_pretty_plural]] [_ dotlrn.New]]

form create add_department

element create add_department pretty_name \
    -label "[_ dotlrn.Name]" \
    -datatype text \
    -widget text \
    -html {size 60 maxlength 100}

element create add_department description \
    -label "[_ dotlrn.Description]" \
    -datatype text \
    -widget textarea \
    -html {rows 5 cols 60} \
    -optional

element create add_department external_url \
    -label "[_ dotlrn.External_URL]" \
    -datatype text \
    -widget text \
    -html {size 60} \
    -optional

element create add_department department_key \
    -label "[_ dotlrn.Department_key]" \
    -datatype text \
    -widget text \
    -html {size 60} \
    -optional

element create add_department referer \
    -label "[_ dotlrn.Referer]" \
    -datatype text \
    -widget hidden \
    -value $referer

if {[form is_valid add_department]} {
    form get_values add_department \
         pretty_name description external_url referer department_key

    set department_key [dotlrn_department::new \
        -department_key $department_key \
        -pretty_name $pretty_name \
        -description $description \
        -external_url $external_url]

    ad_returnredirect $referer
    ad_script_abort
}

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

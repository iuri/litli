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

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

ad_page_contract {
    delete an empty department

    @author arjun (arjun@openforce.net)
    @version $Id: department-delete.tcl,v 1.7.4.1 2015/09/11 11:40:51 gustafn Exp $
} -query {
    {referer "departments"}
    {department_key:notnull}
    {pretty_name:notnull}
} -properties {
    title:onevalue
    context_bar:onevalue
}

set departments_pretty_name [parameter::get -localize -parameter departments_pretty_name]
set title "[_ dotlrn.Delete_Empty]"
set context_bar [list [list departments [parameter::get -localize -parameter departments_pretty_plural]] Delete]

form create delete_department

# this is lame, but the button hack is not ready yet
set yes_label "[_ dotlrn.Yes_delete] $pretty_name"
set no_label "[_ dotlrn.No_dont_delete_it]"

element create delete_department no_button \
    -label $no_label \
    -datatype text \
    -widget submit \
    -value "1"

element create delete_department yes_button \
    -label $yes_label  \
    -datatype text \
    -widget submit

element create delete_department department_key \
    -datatype text \
    -widget hidden \
    -value $department_key

element create delete_department pretty_name \
    -datatype text \
    -widget hidden \
    -value $pretty_name

element create delete_department referer \
    -label "[_ dotlrn.Referer]" \
    -datatype text \
    -widget hidden \
    -value $referer

if {[form is_valid delete_department]} {
    form get_values delete_department department_key pretty_name referer no_button yes_button

    if {$yes_button eq $yes_label} {

        db_transaction {
            set subcomm_id [dotlrn_department::delete \
                -department_key $department_key
            ]
        }
    }

    ad_returnredirect "$referer"
    ad_script_abort
} 

ad_return_template


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

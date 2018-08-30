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
} {
    class_key:notnull
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

# Get information about that class
if {![db_0or1row select_class_info {}]} {
    ad_returnredirect classes
    ad_script_abort
}

ad_form -name delete_class -form {
    {class_key:text(hidden)}
} -on_request {
    ad_set_form_values class_key
} -on_submit {
    #here's where we actually do the delete.
    dotlrn_class::delete -class_key $class_key
} -after_submit {
    ad_returnredirect [export_vars -base classes {department_key}]
    ad_script_abort
} -cancel_url [export_vars -base classes {department_key}]


set title "[_ dotlrn.Delete_Empty_Class]"
set context_bar [list [[export_vars -base classes {department_key}] [parameter::get -localize -parameter classes_pretty_plural]] Delete]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

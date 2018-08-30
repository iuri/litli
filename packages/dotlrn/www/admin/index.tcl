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
    Displays main dotLRN admin page

    @author Ben Adida (ben@openforce.net)
    @creation-date 2001-11-04
}

#Pages in this directory are only runnable by dotlrn-wide admins.
dotlrn::require_admin 

set oacs_site_wide_admin_p [acs_user::site_wide_admin_p]

set admin_pretty_name [_ dotlrn.Administration]
set context_bar {}

# Some en_US messages reuse these configurable pretty names
set class_instances_pretty_plural [parameter::get -localize -parameter class_instances_pretty_plural]
set clubs_pretty_plural [parameter::get -localize -parameter clubs_pretty_plural]
set departments_pretty_plural [parameter::get -localize -parameter departments_pretty_plural]
set subjects_pretty_plural [parameter::get -localize -parameter classes_pretty_plural]

set parameters_url [export_vars -base /shared/parameters { { package_id {[dotlrn::get_package_id]} } { return_url [ad_return_url] } }] 

set parameters_d_url [export_vars -base /shared/parameters { { package_id {[apm_package_id_from_key dotlrn-portlet]} } { return_url [ad_return_url] } }]

if { ![parameter::get -localize -package_id [dotlrn::get_package_id] -parameter dotlrn_toolbar_enabled_p -default 1] } {
    set dotlrn_toolbar_action [_ dotlrn.show_lrn_toolbar]
    set action "show"
} else {
    set dotlrn_toolbar_action [_ dotlrn.hide_lrn_toolbar]
    set action "hide"
}

set return_url [ad_conn url]

set toolbar_actions_url [export_vars -base toolbar-actions {action return_url}]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

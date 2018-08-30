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
    The display logic for the static admin portlet
    
    @author arjun (arjun@openforce)
    @author Ben Adida (ben@openforce)    
    @cvs_id $Id: static-admin-portlet.tcl,v 1.21.2.2 2016/05/21 11:00:39 gustafn Exp $
} {
    {package_id:naturalnum,optional ""}
    {template_portal_id:naturalnum,optional ""}
    {referer:optional ""}
    {return_url:localurl,optional ""}
}

if { $package_id eq "" } {
    set package_id [dotlrn_community::get_community_id]
}

# DRB: when previewing from the portals package no community is defined, we don't
# want to portlet to bomb in this case.

if { $package_id ne "" } {

    if {$template_portal_id eq ""} {
        set template_portal_id [dotlrn_community::get_portal_id]
    }

    if {$return_url ne ""} {
        set referer $return_url
    }

    if {$referer eq ""} {
        set referer [ad_conn url]
    }

    set element_pretty_name [parameter::get \
                                 -parameter static_admin_portlet_element_pretty_name \
                                 -default [_ static-portlet.admin_portlet_element_pretty_name]]

    set applet_url "[dotlrn_applet::get_url]/[static_portlet::my_package_key]"

    set create_url [export_vars -base $applet_url/element {{portal_id $template_portal_id} package_id referer}]

    db_multirow -extend edit_url content select_content {
        select content_id,
               pretty_name
        from static_portal_content
        where package_id = :package_id
    } {
        set class_instances_pretty_name [_ dotlrn.class_instances_pretty_name]
        set pretty_name [lang::util::localize $pretty_name]

        set edit_url [export_vars -base $applet_url/element {{portal_id $template_portal_id} {content_id $content_id} referer}]
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

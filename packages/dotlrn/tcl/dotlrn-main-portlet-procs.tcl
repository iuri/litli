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

ad_library {

    The "dotlrn main" portlet shows a list of the classes and communities that
    the user is a member of on the user's workspace portal. Not to be confused
    with the "dotlrn" portlet that shows the subgroups of the current community
    and is only on community portals.

    @author ben@openforce.net, arjun@openforce.net
    @cvs-id $Id: dotlrn-main-portlet-procs.tcl,v 1.29.2.1 2015/09/11 11:40:39 gustafn Exp $

}

namespace eval dotlrn_main_portlet {

    ad_proc -private get_my_name {
    } {
        return "dotlrn_main_portlet"
    }

    ad_proc -public get_pretty_name {
    } {
        return [parameter::get -package_id [dotlrn::get_package_id] -parameter dotlrn_main_portlet_pretty_name]
    }

    ad_proc -public link {
    } {
        return ""
    }

    ad_proc -public add_self_to_page {
        {-portal_id:required}
    } {
        @return new element_id
    } {
        # we use "portal::add_element" here since there is no
        # configuration necessary for this portlet (no params)
        return [portal::add_element \
            -force_region [parameter::get -parameter dotlrn_main_portlet_region] \
            -pretty_name [get_pretty_name] \
            -portal_id $portal_id \
            -portlet_name [get_my_name] \
        ]
    }

    ad_proc -public remove_self_from_page {
        portal_id
    } {
        Removes the dotlrn main PE from the portal
    } {
        portal::remove_element \
                -portal_id $portal_id \
                -datasource_name [get_my_name]
    }

    ad_proc -public show {
        cf
    } {
    } {
        portal::show_proc_helper \
                -template_src "dotlrn-main-portlet" \
                -package_key "dotlrn" \
                -config_list $cf
    }

}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

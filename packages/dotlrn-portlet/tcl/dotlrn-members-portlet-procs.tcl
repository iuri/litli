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

    Procedures to support the dotlrn "members" portlet

    @author arjun@openforce.net
    @cvs-id $Id: dotlrn-members-portlet-procs.tcl,v 1.12.20.2 2017/06/30 17:49:13 gustafn Exp $

}

namespace eval dotlrn_members_portlet {

    ad_proc -private get_my_name {
    } {
        return "dotlrn_members_portlet"
    }

    ad_proc -private my_package_key {
    } {
        return "dotlrn-portlet"
    }


    ad_proc -public get_pretty_name {
    } {
        return "#dotlrn-portlet.members_portlet_pretty_name#"
    }

    ad_proc -public link {
    } {
	return ""
    }

    ad_proc -public add_self_to_page {
	{-portal_id:required}
        {-page_name ""}
	{-community_id:required}
    } {
        Adds the dotlrn "members" portlet to the given portal.
        Pass along the community_id
    } {
        return [portal::add_element_parameters \
                    -pretty_name [get_pretty_name] \
                    -portal_id $portal_id \
                    -page_name $page_name \
                    -portlet_name [get_my_name] \
                    -key "community_id" \
                    -value $community_id
        ]
    }

    ad_proc -public remove_self_from_page {
        {-portal_id:required}
    } {
	Removes the dotlrn "members"  PE from the given portal
    } {
        portal::remove_element \
            -portal_id $portal_id \
            -portlet_name [get_my_name]
    }

    ad_proc -public show {
	 cf
    } {
    } {
        portal::show_proc_helper \
            -package_key [my_package_key] \
            -config_list $cf \
            -template_src "dotlrn-members-portlet"
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

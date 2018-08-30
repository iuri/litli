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

    Procedures to supports the dotlrn "members staff" portlet aka "Staff List"

    @author arjun@openforce.net
    @cvs-id $Id: dotlrn-members-staff-portlet-procs.tcl,v 1.10.20.1 2015/09/11 11:41:00 gustafn Exp $
}

namespace eval dotlrn_members_staff_portlet {

    ad_proc -private get_my_name {
    } {
        return "dotlrn_members_staff_portlet"
    }

    ad_proc -private my_package_key {
    } {
        return "dotlrn-portlet"
    }

    ad_proc -public get_pretty_name {
    } {
	return "#dotlrn-portlet.members_staff_portlet_pretty_name#"
    }

    ad_proc -public link {
    } {
	return ""
    }

    ad_proc -public add_self_to_page {
	{-portal_id:required}
	{-community_id:required}
    } {
        Add the "dotlrn members staff" portlet to the page
    } {
        set force_region [parameter::get_from_package_key \
                              -package_key [my_package_key] \
                              -parameter "dotlrn_members_staff_portlet_force_region"
        ]

        return [portal::add_element_parameters \
                    -portal_id $portal_id \
                    -pretty_name [get_pretty_name] \
                    -portlet_name [get_my_name] \
                    -force_region $force_region \
                    -key "community_id" \
                    -value $community_id
        ]
    }

    ad_proc -public remove_self_from_page {
        {-portal_id:required}
    } {
	Removes the PE from the given page
    } {
        portal::remove_element \
            -portal_id $portal_id \
            -portlet_name [get_my_name]
    }

    ad_proc -public show {
	 cf
    } {
	 Call the template to display

	 @param cf A config array
    } {
        portal::show_proc_helper \
            -package_key [my_package_key] \
            -config_list $cf \
            -template_src "dotlrn-members-staff-portlet"
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

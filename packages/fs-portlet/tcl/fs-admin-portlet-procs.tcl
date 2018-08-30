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

    Procedures to support the file-storage admin portlet

    @creation-date 2004-07-07
    @author Tracy Adams (teadams@mit.edu)
    @cvs-id $Id: fs-admin-portlet-procs.tcl,v 1.7 2018/07/11 14:59:50 antoniop Exp $

}

namespace eval fs_admin_portlet {

    ad_proc -private get_my_name {
    } {
        return "fs_admin_portlet"
    }

    ad_proc -public get_pretty_name {
    } {
        Get pretty name.
    } {
        return "#fs-portlet.lt_File_Storage_Administ#"
    }

    ad_proc -private my_package_key {
    } {
        return "fs-portlet"
    }

    ad_proc -public link {
    } {
        Get link. This is currently empty.
    } {
        return ""
    }

    ad_proc -public add_self_to_page {
        {-portal_id:required}
        {-package_id:required}
    } {
        Adds a fs admin PE to the given admin portal. There should
        only ever be one of these portals on an admin page with only
        one fs_package_id.

        @param portal_id The page to add self to
        @param package_id the id of the faq package

        @return element_id The new element's id
    } {
	#ns_log Warning "adding fs admin portlet to page - [get_my_name]"
        return [portal::add_element_parameters \
            -portal_id $portal_id \
            -portlet_name [get_my_name] \
            -key package_id \
            -value $package_id
        ]
    }

    ad_proc -public remove_self_from_page {
        portal_id
    } {
        Removes fs admin PE from the given portal.
    } {
        portal::remove_element -portal_id $portal_id -portlet_name [get_my_name]
    }

    ad_proc -public show {
	cf
    } {
	Shows the file-storage admin portlet.
    } {
	portal::show_proc_helper \
            -package_key [my_package_key] \
            -config_list $cf \
            -template_src "fs-admin-portlet"
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

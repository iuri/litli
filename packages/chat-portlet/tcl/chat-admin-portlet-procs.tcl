#
#  Copyright (C) 2004 University of Valencia
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

    Procedures to support the chat admin portlet

    @author agustin (Agustin.Lopez@uv.es)
    @creation-date 2004-10-10
    @version $Id: chat-admin-portlet-procs.tcl,v 0.1 2004/10/10

}

namespace eval chat_admin_portlet {

    ad_proc -private get_my_name {
    } {
        return "chat_admin_portlet"
    }

    ad_proc -public get_pretty_name {
    } {
        return "#chat-portlet.admin_pretty_name#"
    }

    ad_proc -private my_package_key {
    } {
        return "chat-portlet"
    }

    ad_proc -public link {
    } {
        return ""
    }

    ad_proc -public add_self_to_page {
        {-portal_id:required}
        {-page_name ""}
        {-package_id:required}
    } {
        Adds a chat admin PE to the given portal

        @param portal_id The page to add self to
        @param package_id The package_id of the chat package

        @return element_id The new element's id
    } {
        return [portal::add_element_parameters \
            -portal_id $portal_id \
            -portlet_name [get_my_name] \
            -key package_id \
            -value $package_id
        ]
    }

    ad_proc -public remove_self_from_page {
        {-portal_id:required}
    } {
          Removes a chat admin PE from the given page
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
            -template_src "chat-admin-portlet"

    }

}

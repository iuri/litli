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

    A portlet to show the _contents_ of a fs folder in a list. 
    Used for the "handouts", "assignments", etc. portlets 

    @author Arjun Sanyal (arjun@openforce.net)
    @cvs-id $Id: fs-contents-portlet-procs.tcl,v 1.4.2.1 2015/09/12 11:06:32 gustafn Exp $

}

namespace eval fs_contents_portlet {

    ad_proc -private my_package_key {
    } {
        return "fs-contents-portlet"
    }

    ad_proc -private get_my_name {
    } {
        return fs_contents_portlet
    }

    ad_proc -public get_pretty_name {
        We want the pretty_name to be passed in from the applet. 
    } {
        error
    }

    ad_proc -public link {
    } {
        return ""
    }

    ad_proc -public add_self_to_page {
        {-portal_id:required}
        {-pretty_name:required}
        {-folder_id:required}
        {-param_action:required}
        {-page_name ""}
        {-hide_p ""}
    } {
        Adds a fs PE to the given page. If there's already and fs pe,
        it appends the values to the pe's params.

        @param portal_id The page to add self to
        @param folder_id The folder to show

        @return element_id The new element's id
    } {
        db_transaction {
            # Generate the element, don't use add_element_parameters here, 
            # since it dosen't do the right thing for multiple elements with
            # the same datasource on a page. so we just use the more low level
            # portal::add_element
            set element_id [portal::add_element \
                -portal_id $portal_id \
                -pretty_name $pretty_name \
                -page_name $page_name \
                -portlet_name [get_my_name]
            ]
            
            portal::set_element_param $element_id folder_id $folder_id

            if {$hide_p ne ""} {
                portal::configure_element -noconn 1 $element_id hide "" 
            }
        }

        return $element_id
    }

    ad_proc -public remove_self_from_page {
        {-portal_id:required}
        {-package_id:required}
        {-folder_id:required}
    } {
          Removes a fs PE from the given page
    } {
        set extra_params [list package_id $package_id]

        portal::remove_element_parameters \
            -portal_id $portal_id \
            -portlet_name [get_my_name] \
            -value $folder_id \
            -key folder_id \
            -extra_params $extra_params
    }

    ad_proc -public show {
         cf
    } {
        Note: we use the fs_portlet's pk here
    } {
        portal::show_proc_helper \
            -package_key [fs_portlet::my_package_key] \
            -config_list $cf \
            -template_src fs-contents-portlet
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

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

    Procedures to support the file-storage portlet

    @creation-date September 30 2001
    @author Arjun Sanyal (arjun@openforce.net)
    @cvs-id $Id: fs-portlet-procs.tcl,v 1.43.2.1 2015/09/12 11:06:32 gustafn Exp $

}

namespace eval fs_portlet {

    ad_proc -private my_package_key {
    } {
        return "fs-portlet"
    }

    ad_proc -private get_my_name {
    } {
        return fs_portlet
    }

    ad_proc -public get_pretty_name {
    } {
        return [parameter::get_from_package_key -package_key [my_package_key] -parameter pretty_name]
    }

    ad_proc -public link {
    } {
        return ""
    }

    ad_proc -public add_self_to_page {
        {-portal_id:required}
        {-page_name ""}
        {-package_id:required}
        {-folder_id:required}
        {-extra_params ""}
        {-force_region ""}
        {-param_action:required}
    } {
        Adds a fs PE to the given page. If there's already and fs pe,
        it appends the values to the pe's params.

        @param portal_id The page to add self to
        @param folder_id The folder to show

        @return element_id The new element's id
    } {
        if {$extra_params eq ""} {
            set extra_params [list]
        }

        # it seems to me that package_id is not needed. 
        # that allows for dotlrn-fs to be cleaned up
        # however, we do need the rest of theextra_params
        lappend extra_params [list package_id $package_id]

        return [portal::add_element_parameters \
            -portal_id $portal_id \
            -page_name $page_name \
            -pretty_name [get_pretty_name] \
            -portlet_name [get_my_name] \
            -force_region $force_region \
            -param_action $param_action \
            -value $folder_id \
            -key folder_id \
            -extra_params [eval concat $extra_params] 
        ]
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
    } {
        portal::show_proc_helper \
            -package_key [my_package_key] \
            -config_list $cf
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

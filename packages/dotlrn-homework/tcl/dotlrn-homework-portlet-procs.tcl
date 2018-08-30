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

    Procedures to support the homework portlet

    @author Don Baccus (dhogaza@pacifier.com)

}

namespace eval dotlrn_homework_portlet {

    ad_proc -private my_package_key {
    } {
        return "dotlrn-homework"
    }

    ad_proc -private get_my_name {
    } {
        return dotlrn_homework_portlet
    }

    ad_proc -public get_pretty_name {
    } {
        return "#dotlrn-homework.pretty_name#"
    }

    ad_proc -public link {
    } {
        return ""
    }

    ad_proc -public add_portlet {
        {-portal_id:required}
    } {

        Adds a porlet.
        @param portal_id The page to add portlet.
    } {
        set args [ns_set create]
        ns_set put $args package_id 0
        ns_set put $args page_name ""
        ns_set put $args folder_id 0
        ns_set put $args param_action "overwrite"

        add_portlet_helper $portal_id $args        
    }

    
    ad_proc -public remove_portlet {
        {-portal_id:required}
    } {
        Remove portlet
        @param portal_id The page from remove portlet.
    } {
        ad_return_complaint 1  "[applet_key] remove_portlet not implemented!"
    }
    
    ad_proc -public add_portlet_helper {
        portal_id
        args
    } {
        This does the call to add portlet to the given portal. Params for the portlet are set by the callers.
    } {
        add_self_to_page -portal_id $portal_id \
            -page_name [ns_set get $args page_name] \
            -package_id [ns_set get $args package_id] \
            -folder_id [ns_set get $args folder_id] \
            -param_action [ns_set get $args param_action]
    }

    ad_proc -public add_self_to_page {
        {-portal_id:required}
        {-page_name ""}
        {-package_id:required}
        {-folder_id:required}
        {-param_action:required}
    } {
        Adds a homework PE to the given page. 

        @param portal_id The page to add self to
        @param folder_id The homework folder to associate with this portlet
        @return element_id The new element's id

    } {
        return [portal::add_element_parameters \
            -portal_id $portal_id \
            -page_name $page_name \
            -pretty_name [get_pretty_name] \
            -portlet_name [get_my_name] \
            -param_action $param_action \
            -value $folder_id \
            -key folder_id \
            -extra_params [list package_id $package_id]
        ]
    }

    ad_proc -public remove_self_from_page {
        {-portal_id:required}
        {-package_id:required}
        {-folder_id:required}
    } {
          Removes a homework PE from the given page
    } {
        portal::remove_element_parameters \
            -portal_id $portal_id \
            -portlet_name [get_my_name] \
            -value $folder_id \
            -key folder_id \
            -extra_params [list package_id $package_id]
    }

    ad_proc -public show {
         cf
    } {
    } {

        portal::show_proc_helper \
            -package_key [my_package_key] \
            -config_list $cf \
            -template_src "dotlrn-homework-portlet"

    }

}

namespace eval dotlrn_homework_admin_portlet {

    ad_proc -private my_package_key {
    } {
        return "dotlrn-homework"
    }

    ad_proc -private get_my_name {
    } {
        return dotlrn_homework_admin_portlet
    }

    ad_proc -public get_pretty_name {
    } {
        return "#dotlrn-homework.homework_pretty_admin#"
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
        {-param_action:required}
    } {
        Adds a homework PE to the given page. 

        @param portal_id The page to add self to
        @param folder_id The homework folder to associate with this portlet
        @return element_id The new element's id

    } {
        return [portal::add_element_parameters \
            -portal_id $portal_id \
            -page_name $page_name \
            -pretty_name [get_pretty_name] \
            -portlet_name [get_my_name] \
            -param_action $param_action \
            -value $folder_id \
            -key folder_id \
            -extra_params [list package_id $package_id]
        ]
    }

    ad_proc -public remove_self_from_page {
        {-portal_id:required}
        {-package_id:required}
        {-folder_id:required}
    } {
          Removes a homework PE from the given page
    } {
        portal::remove_element_parameters \
            -portal_id $portal_id \
            -portlet_name [get_my_name] \
            -value $folder_id \
            -key folder_id \
            -extra_params [list package_id $package_id]
    }

    ad_proc -public show {
         cf
    } {
    } {
        portal::show_proc_helper \
            -package_key [my_package_key] \
            -config_list $cf \
            -template_src "dotlrn-homework-admin-portlet"

    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

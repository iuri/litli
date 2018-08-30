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

    Procedures to support the FAQ portlet

    @author Arjun Sanyal (arjun@openforce.net)
    @creation-date September 30 2001
    @cvs-id $Id: faq-portlet-procs.tcl,v 1.33.2.1 2015/09/12 11:06:16 gustafn Exp $

}

namespace eval faq_portlet {

    ad_proc -private get_my_name {
    } {
        return "faq_portlet"
    }

    ad_proc -private my_package_key {
    } {
        return "faq-portlet"
    }

    ad_proc -public get_pretty_name {
    } {
        return "#faq-portlet.pretty_name#"
    }

    ad_proc -public link {
    } {
        return ""
    }

    ad_proc -public add_self_to_page {
        {-portal_id:required}
        {-package_id:required}
        {-param_action:required}
    } {
        Adds a faq PE to the given portal or appends the given
        faq_package_id to the params of the faq pe already there

        @param portal_id The page to add self to
        @param faq_package_id the id of the faq package for this community

        @return element_id The new element's id
    } {
        return [portal::add_element_parameters \
            -portal_id $portal_id \
            -portlet_name [get_my_name] \
            -key package_id \
            -value $package_id \
            -pretty_name [get_pretty_name] \
            -force_region [parameter::get_from_package_key \
                               -package_key [my_package_key] \
                               -parameter "faq_portlet_force_region"] \
            -param_action $param_action
        ]
    }

    ad_proc -public remove_self_from_page {
        {-portal_id:required}
        {-package_id:required}
    } {
        Removes a faq PE from the given page or just the passed
        in faq_package_id parameter from the portlet
        (that has other faq_package_ids)

        @param portal_id The page to remove self from
        @param package_id
    } {
        portal::remove_element_parameters \
            -portal_id $portal_id \
            -portlet_name [get_my_name] \
            -key package_id \
            -value $package_id
    }

    ad_proc -public show {
        cf
    } {
    } {
        portal::show_proc_helper \
            -package_key [my_package_key] \
            -config_list $cf \
            -template_src "faq-portlet"
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

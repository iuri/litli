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

    Procedures to support the news portlet

    @creation-date Nov 2001
    @author arjun@openforce.net
    @cvs-id $Id: news-portlet-procs.tcl,v 1.22.14.1 2015/09/12 11:06:45 gustafn Exp $

}

namespace eval news_portlet {

    ad_proc -private get_my_name {
    } {
        return "news_portlet"
    }

    ad_proc -private my_package_key {
    } {
        return "news-portlet"
    }

    ad_proc -public get_pretty_name {
    } {
        return [parameter::get_from_package_key \
                    -package_key [my_package_key] \
                    -parameter news_portlet_pretty_name
        ]
    }

    ad_proc -public get_summary_length {
    } {
        return [parameter::get_from_package_key \
                    -package_key [my_package_key] \
                    -parameter news_portlet_summary_length
        ]
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
	Adds a news PE to the given portal.

	@param portal_id The page to add self to
	@param package_id The community with the folder

	@return element_id The new element's id
    } {
        return [portal::add_element_parameters \
            -portal_id $portal_id \
            -portlet_name [get_my_name] \
            -value $package_id \
            -force_region [parameter::get_from_package_key \
                               -parameter "news_portlet_force_region" \
                               -package_key [my_package_key]] \
            -pretty_name [get_pretty_name] \
            -param_action $param_action
        ]
    }

    ad_proc -public remove_self_from_page {
	{-portal_id:required}
	{-package_id:required}
    } {
        Removes a news PE from the given page or the package_id of the
        news package from the portlet if there are others remaining

        @param portal_id The page to remove self from
        @param package_id
    } {
        portal::remove_element_parameters \
            -portal_id $portal_id \
            -portlet_name [get_my_name] \
            -value $package_id
    }

    ad_proc -public show {
	 cf
    } {
    } {
        portal::show_proc_helper \
            -package_key [my_package_key] \
            -config_list $cf \
            -template_src "news-portlet"
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

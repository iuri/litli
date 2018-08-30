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

    Procedures to supports the "dotlrn" portlet. The "dotlrn" portlet shows
    the subcommunities of the community's portal where it's located. This portal
    is not to be confused with the "dotlrn-main" portal, that goes on user's
    workspace portals and shows the communities that they are members of.

    @creation-date September 30 2001
    @author arjun@openforce.net
    @cvs-id $Id: dotlrn-portlet-procs.tcl,v 1.37.2.1 2015/09/11 11:41:00 gustafn Exp $

}

namespace eval dotlrn_portlet {

    ad_proc -private get_my_name {
    } {
        return "dotlrn_portlet"
    }

    ad_proc -private my_package_key {
    } {
        return "dotlrn-portlet"
    }

    ad_proc -public get_pretty_name {
    } {
        # get the param from the dotlrn package
	return [dotlrn::parameter -name subcommunities_pretty_plural]
    }

    ad_proc -public link {
    } {
	return ""
    }

    ad_proc -public add_self_to_page {
	{-portal_id:required}
	{-community_id:required}
    } {
	Adds a dotlrn PE to the given communities's portal

	@param portal_id
	@param community_id

	@return element_id The new element's id
    } {
        set force_region [parameter::get_from_package_key \
                              -package_key [my_package_key] \
                              -parameter "dotlrn_portlet_force_region"
        ]

        set element_id [portal::add_element_parameters \
                            -portal_id $portal_id \
                            -portlet_name [get_my_name] \
                            -pretty_name [get_pretty_name] \
                            -force_region $force_region \
                            -key "community_id" \
                            -value $community_id
        ]

	return $element_id
    }

    ad_proc -public remove_self_from_page {
        {-portal_id:required}
    } {
	Removes the dotlrn PE from the portal.
    } {
        # since there can be only one dotlrn pe on the portal use:
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
            -config_list $cf
    }

    ad_proc -public is_allowed {
	{-parameter:required}
    } {
        This is the Tcl proc that is called by some Group Administration pages
        that need to verify a dotlrn-portlet parameter.
        This prevents bad users to access protected pages.

 
        @author Hector Amado (hr_amado@galileo.edu)
        @creation-date 2004-06-22

    } {

        switch $parameter {
            "cenrollment" {
		if { ![parameter::get_from_package_key -package_key dotlrn-portlet -parameter AllowChangeEnrollmentPolicy] } {
		    if { ![dotlrn::admin_p] } {  
                ns_log notice "user has tried to see    without permission"
                ad_return_forbidden \
                   "Permission Denied"\
                   "<p>
                     You don't have permission to see this page.
                    </p>"
		    }
                }
	    }
            "managemembership" {
                if { ![parameter::get_from_package_key -package_key dotlrn-portlet -parameter AllowManageMembership] } {
     	      if { ![dotlrn::admin_p] } {
                ns_log notice "user has tried to see /dotlrn/www/members  without permission"
                ad_return_forbidden \
                   "Permission Denied"\
                   "<p>
                     You don't have permission to see this page.
                    </p>"
              }
             }
	    }
            "cplayout" {
                if { ![parameter::get_from_package_key -package_key dotlrn-portlet -parameter AllowCustomizePortalLayout] } {
                	 if { ![dotlrn::admin_p] } {
                ns_log notice "user has tried to see /dotlrn/www/one-community-portal-configure  without permission"
                ad_return_forbidden \
                   "Permission Denied"\
                   "<p>
                     You don't have permission to see this page.
                    </p>"
	       }
             }
	    }
            "guestuser" { 
                if { ![parameter::get_from_package_key -package_key dotlrn-portlet -parameter AllowCreateGuestUsersInCommunity] } {
                	 if { ![dotlrn::admin_p] } {
                ns_log notice "user has tried to see /dotlrn/www/user-add  without permission"
                ad_return_forbidden \
                   "Permission Denied"\
                   "<p>
                     You don't have permission to see this page.
                    </p>"
	       }
             }
	    }
            "limiteduser" {
                if { ![parameter::get_from_package_key -package_key dotlrn-portlet -parameter AllowCreateLimitedUsersInCommunity] } {
     	                 if { ![dotlrn::admin_p] } {
                ns_log notice "user has tried to see /dotlrn/www/user-add  without permission"
                ad_return_forbidden \
                   "Permission Denied"\
                   "<p>
                     You don't have permission to see this page.
                    </p>"
	       }
             }
           }
	    "manageapplets" {
              if { ![parameter::get_from_package_key -package_key dotlrn-portlet -parameter AllowManageApplets] } {
     	                 if { ![dotlrn::admin_p] } {
                ns_log notice "user has tried to see /dotlrn/www/applets  without permission"
                ad_return_forbidden \
                   "Permission Denied"\
                   "<p>
                     You don't have permission to see this page.
                    </p>"
	       }
             }
          }
	}
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

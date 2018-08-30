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

#
# Procs for DOTLRN "staff list" Applet
#
# $Id: dotlrn-members-staff-procs.tcl,v 1.15.20.1 2015/09/11 11:40:56 gustafn Exp $
#

ad_library {
    
    Procs to set up the dotLRN "staff list" applet
    
    @author ben@openforce.net,arjun@openforce.net
}

namespace eval dotlrn_members_staff {
    
    ad_proc portal_element_key {
    } {
	Returns the key for the portal element this applet uses
    } {
	return "dotlrn-members-staff-portlet"
    }

    ad_proc -public get_pretty_name {
    } {
	Returns the pretty name of the applet
    } {
	return "[_ dotlrn-dotlrn.lt_dotLRN_Staff_List_Inf]"
    }

    ad_proc -public my_package_key {
    } {
        What's my package key?
    } {
        return "dotlrn-dotlrn"
    }

    ad_proc -public applet_key {
    } {
        What's my package key?
    } {
        return dotlrn_members_staff
    }

    ad_proc -public add_applet {
    } {
	Add the dotlrn applet to dotlrn - one time init - must be repeatable!
    } {
        dotlrn_applet::add_applet_to_dotlrn -applet_key [applet_key] -package_key [my_package_key]
    }

    ad_proc -public add_applet_to_community {
	community_id
    } {
	Add the dotlrn members staff applet to a specific community
    } {
	set portal_id [dotlrn_community::get_portal_id -community_id $community_id]
	dotlrn_members_staff_portlet::add_self_to_page \
            -portal_id $portal_id \
            -community_id $community_id

	return ""
    }

    ad_proc -public remove_applet_from_community {
	community_id
    } {
        removes the dotlrn members staff applet from a community
    } {
	set portal_id [dotlrn_community::get_portal_id -community_id $community_id]
	dotlrn_members_staff_portlet::remove_self_from_page -portal_id $portal_id 
    }

    ad_proc -public remove_applet {
	community_id
	package_id
    } {
	remove the applet from the community
    } {
    }

    ad_proc -public add_user {
	user_id
    } {
	Called for one time init when this user is added to dotlrn
    } {
        # noop
    }

    ad_proc -public remove_user {
        user_id
    } {
    } {
        # noop
    }

    ad_proc -public add_user_to_community {
	community_id
	user_id
    } {
	Called when a user is added to a spceific dotlrn community
    } {
    }

    ad_proc -public remove_user_from_community {
	community_id
	user_id
    } {
	Remove a user from a community
    } {
    }

    ad_proc -public add_portlet {
        args
    } {
        A helper proc to add the underlying portlet to the given portal. 
        
        @param args a list-ified array of args defined in add_applet_to_community
    } {
        ns_log notice "** Error in [get_pretty_name]: 'add_portlet' not implemented!"
        ad_return_complaint 1  "Please notifiy the administrator of this error:
        ** Error in [get_pretty_name]: 'add_portlet' not implemented!"
    }

    ad_proc -public remove_portlet {
        args
    } {
        A helper proc to remove the underlying portlet from the given portal. 
        
        @param args a list-ified array of args defined in remove_applet_from_community
    } {
        ns_log notice "** Error in [get_pretty_name]: 'remove_portlet' not implemented!"
        ad_return_complaint 1  "Please notifiy the administrator of this error:
        ** Error in [get_pretty_name]: 'remove_portlet' not implemented!"
    }

    ad_proc -public clone {
        old_community_id
        new_community_id
    } {
        Clone this applet's content from the old community to the new one
    } {
        return [add_applet_to_community $new_community_id]
    }

    ad_proc -public change_event_handler {
        community_id
        event
        old_value
        new_value
    } { 
        listens for the following events: 
    } { 
    }   

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

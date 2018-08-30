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

    Procs to set up the dotLRN Faq applet

    @author ben@openforce.net,arjun@openforce.net
    @creation-date 2001-10-05

}

namespace eval dotlrn_faq {

    ad_proc -public get_pretty_name {
    } {
        get the pretty name
    } {
        return "#faq.pretty_name#"
    }

    ad_proc -public applet_key {} {
        return "dotlrn_faq"
    }

    ad_proc -public my_package_key {
    } {
        What's my package key?
    } {
        return "dotlrn-faq"
    }

    ad_proc -public package_key {
    } {
        What package is associated with this applet?
    } {
        return "faq"
    }

    ad_proc -public add_applet {
    } {
        Add the faq applet to dotlrn - one time init - must be repeatable!
    } {
        dotlrn_applet::add_applet_to_dotlrn -applet_key [applet_key] -package_key [my_package_key]
    }

    ad_proc -public remove_applet {
        community_id
        package_id
    } {
        remove the applet
    } {
        ad_return_complaint 1 "[applet_key] remove_applet not implemented!"
    }

    ad_proc -public add_applet_to_community {
        community_id
    } {
        Add the faq applet to a specifc community
    } {
        set portal_id [dotlrn_community::get_portal_id \
                           -community_id $community_id
        ]

        # create the faq package instance (all in one, I've mounted it)
        set package_id [dotlrn::instantiate_and_mount \
                            $community_id \
                            [package_key]
        ]

        #
        # portlet stuff
        #

        # set up the admin portlet

        set admin_portal_id [dotlrn_community::get_admin_portal_id \
                                 -community_id $community_id
        ]

        faq_admin_portlet::add_self_to_page \
            -portal_id $admin_portal_id \
            -package_id $package_id

        # set up the faq portlet for this community

        set portal_id [dotlrn_community::get_portal_id \
                           -community_id $community_id
        ]

        # add the portlet to the comm's portal using add_portlet_helper
        set args [ns_set create]
        ns_set put $args package_id $package_id
        ns_set put $args param_action "overwrite"

        dotlrn_faq::add_portlet_helper $portal_id $args

        # return the package_id
        return $package_id
    }

    ad_proc -public remove_applet_from_community {
        community_id
    } {
        Drops the faq applet from the given community
    } {
        ad_return_complaint 1 "[applet_key] remove_applet_from_community not implemented!"
    }

    ad_proc -public add_user {
        user_id
    } {
        For one time user-specific init
    } {
        # noop
    }

    ad_proc -public remove_user {
        user_id
    } {
        Remove the user from dotlrn.
    } {
        # noop
    }

    ad_proc -public add_user_to_community {
        community_id
        user_id
    } {
        Called when a user is added to a specific dotlrn community
    } {
        set portal_id [dotlrn::get_portal_id -user_id $user_id]
        set package_id [dotlrn_community::get_applet_package_id \
            -community_id $community_id \
            -applet_key [applet_key]
        ]

        set args [ns_set create]
        ns_set put $args package_id $package_id
        ns_set put $args param_action append

        dotlrn_faq::add_portlet_helper $portal_id $args
    }

    ad_proc -public remove_user_from_community {
        community_id
        user_id
    } {
        Remove a user from a community
    } {
        set portal_id [dotlrn::get_portal_id -user_id $user_id]
        set package_id [dotlrn_community::get_applet_package_id \
            -community_id $community_id \
            -applet_key [applet_key]
        ]

        set args [ns_set create]
        ns_set put $args package_id $package_id

        remove_portlet $portal_id $args
    }

    ad_proc -public add_portlet {
        portal_id
    } {
        A helper proc to add the underlying portlet to the given portal.

        @portal_id
    } {
        set args [ns_set create]
        ns_set put $args package_id 0
        ns_set put $args param_action "overwrite"

        add_portlet_helper $portal_id $args
    }

    ad_proc -public add_portlet_helper {
        portal_id
        args
    } {
        This does the call to add the portlet to the given portal.
        Params for the portlet are set by the calllers.

        @param portal_id
        @param args An ns_set
    } {
        faq_portlet::add_self_to_page \
            -portal_id $portal_id \
            -package_id [ns_set get $args "package_id"] \
            -param_action [ns_set get $args "param_action"]
    }

    ad_proc -public remove_portlet {
        portal_id
        args
    } {
        A helper proc to remove the underlying portlet from the given portal.

        @param portal_id
        @param args An ns_set
    } {
        faq_portlet::remove_self_from_page \
            -portal_id $portal_id \
            -package_id [ns_set get $args "package_id"]
    }

    ad_proc -public clone {
        old_community_id
        new_community_id
    } {
        Clone this applet's content from the old community to the new one
    } {
        ns_log notice "Cloning: [applet_key]"
        set new_package_id [add_applet_to_community $new_community_id]
        set old_package_id [dotlrn_community::get_applet_package_id \
            -community_id $old_community_id \
            -applet_key [applet_key]
        ]

        db_exec_plsql call_faq_clone {}
        return $new_package_id
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

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

    proc library for dotlrn bulk-mail applet

    @author yon (yon@openforce.net)
    @creation-date 2002-05-13
    @cvs-id $Id: dotlrn-bm-procs.tcl,v 1.11.2.2 2017/06/30 17:45:40 gustafn Exp $

}

namespace eval dotlrn_bm {

    ad_proc -public applet_key {
    } {
        get the applet_key
    } {
        return dotlrn_bm
    }

    ad_proc -public my_package_key {
    } {
    } {
        return "dotlrn-bm"
    }

    ad_proc -public package_key {
    } {
        get the package_key this applet deals with
    } {
        return "bulk-mail"
    }

    ad_proc -public get_pretty_name {
    } {
        returns the pretty name
    } {
        return "#bulk-mail.pretty_name#"
    }

    ad_proc -public add_applet {
    } {
        used for one-time init - must be repeatable!
    } {
        if {![dotlrn::is_package_mounted -package_key [package_key]]} {

            db_transaction {
                set package_id [dotlrn::mount_package \
                    -package_key [package_key] \
                    -url [package_key] \
                    -directory_p t \
                ]

                dotlrn_applet::add_applet_to_dotlrn \
                    -applet_key [applet_key] \
                    -package_key [my_package_key]

                dotlrn_applet::mount \
                    -package_key [my_package_key] \
                    -url bm \
                    -pretty_name [get_pretty_name]
            }

        }
    }

    ad_proc -public remove_applet {
    } {
        remove the applet from dotlrn
    } {
    }

    ad_proc -public add_applet_to_community {
        community_id
    } {
        Add the bulk-mail applet to a dotlrn community
    } {
        set portal_id [dotlrn_community::get_admin_portal_id -community_id $community_id]
        set package_id [dotlrn::instantiate_and_mount $community_id [package_key]]

        bm_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id

        return $package_id
    }

    ad_proc -public remove_applet_from_community {
        community_id
    } {
        remove the bulk-mail applet from a dotlrn community
    } {
        set portal_id [dotlrn_community::get_admin_portal_id -community_id $community_id]
        set package_id [dotlrn_community::get_applet_package_id \
            -community_id $community_id \
            -applet_key [applet_key] \
        ]

        bm_portlet::remove_self_from_page -portal_id $portal_id -package_id $package_id
    }

    ad_proc -public add_user {
        user_id
    } {
        one time user-specific init
    } {
        # noop
    }

    ad_proc -public remove_user {
        user_id
    } {
        one time user-specific removal
    } {
        # noop
    }

    ad_proc -public add_user_to_community {
        community_id
        user_id
    } {
        add a user to a community
    } {
        # noop
    }

    ad_proc -public remove_user_from_community {
        community_id
        user_id
    } {
        remove a user from a community
    } {
        # noop
    }

    ad_proc -public add_portlet {
        portal_id
        args
    } {
        a helper proc to add the underlying portlet to the given portal.
    } {
        # since this is admin portal-only, noop here
    }

    ad_proc -public remove_portlet {
        portal_id
        args
    } {
        a helper proc to remove the underlying portlet from the given portal.
    } {
        # since this is admin portal-only, noop here
    }

    ad_proc -public clone {
        old_community_id
        new_community_id
    } {
        clone this applet's content from the old community to the new one
    } {
        add_applet_to_community $new_community_id
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

    ad_proc -public get_package_id {
    } {
        returns the package_id of the dotlrn-bm package
    } {
        return [db_string select_package_id {
            select min(package_id)
            from apm_packages
            where package_key = 'dotlrn-bm'
        }]
    }

    ad_proc -public get_url {
    } {
        returns the URL for the dotlrn-bm package
    } {
        return [lindex [site_node::get_url_from_object_id -object_id [get_package_id]] 0]
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

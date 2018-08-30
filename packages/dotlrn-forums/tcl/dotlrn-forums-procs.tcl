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

    Procs to set up the dotLRN Forums applet

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @author Arjun Sanyal (arjun@openforce.net)
    @creation-date 2002-05-29
    @cvs-id $Id: dotlrn-forums-procs.tcl,v 1.15.2.1 2015/09/11 11:40:56 gustafn Exp $

}

namespace eval dotlrn_forums {

    ad_proc -public applet_key {
    } {
        What's my applet key?
    } {
        return dotlrn_forums
    }

    ad_proc -public my_package_key {
    } {
        What's my package key?
    } {
        return "dotlrn-forums"
    }

    ad_proc -public package_key {
    } {
        What package does this applet deal with?
    } {
        return forums
    }

    ad_proc -public get_pretty_name {
    } {
        return the pretty name of this applet.
    } {
        return "#forums.pretty_name#"
    }

    ad_proc -public add_applet {
    } {
        Add the forums applet to dotlrn - for one-time init
        Must be repeatable!
    } {
        if {![dotlrn_applet::applet_exists_p -applet_key [applet_key]]} {

            db_transaction {
                dotlrn_applet::mount \
                    -package_key [my_package_key] \
                    -url forums \
                    -pretty_name [get_pretty_name]

                dotlrn_applet::add_applet_to_dotlrn \
                    -applet_key [applet_key] \
                    -package_key [my_package_key]
            }

        }
    }

    ad_proc -public remove_applet {
    } {
        remove the applet from dotlrn
    } {
        ad_return_complaint 1 "[applet_key] remove_applet not implemented!"
    }

    ad_proc -public add_applet_to_community {
        community_id
    } {
        Add the forums applet to a dotlrn community
    } {
        # Create and Mount the forums package
        set package_id [dotlrn::instantiate_and_mount \
            -mount_point forums \
            $community_id \
            [package_key] \
        ]

        # mount attachments under forums, if available
        # attachments requires that dotlrn-fs is already mounted 
        if {[apm_package_registered_p attachments]
            && [dotlrn_community::applet_active_p \
                    -community_id $community_id \
                    -applet_key [dotlrn_fs::applet_key]]} {

            set attachments_node_id [site_node::new \
                -name [attachments::get_url] \
                -parent_id [site_node::get_node_id_from_object_id \
                    -object_id $package_id
                ]
            ]

            site_node::mount \
                -node_id $attachments_node_id \
                -object_id [apm_package_id_from_key attachments]

            set fs_package_id [dotlrn_community::get_applet_package_id \
                 -community_id $community_id \
                 -applet_key [dotlrn_fs::applet_key]
            ]
                                     
            # map the fs root folder to the package_id of the new forums pkg
            attachments::map_root_folder \
                -package_id $package_id \
                -folder_id [fs::get_root_folder -package_id $fs_package_id] 
            
        } else {
            ns_log Warning "DOTLRN-FORUMS: Warning attachments or dotlrn-fs not found!"
        }
        
        set auto_create_forum_p [parameter::get_from_package_key \
            -package_key [my_package_key] \
            -parameter auto_create_forum_p \
        ]

        set auto_create_forum_name [parameter::get_from_package_key \
            -package_key [my_package_key] \
            -parameter auto_create_forum_name \
        ]

        if {$auto_create_forum_p == "t"} {
            forum::new \
                -name $auto_create_forum_name \
                -package_id $package_id
        }

        # Set up permissions for basic members (Admins inherit no problem)
        set members [dotlrn_community::get_rel_segment_id \
            -community_id $community_id \
            -rel_type dotlrn_member_rel \
        ]

        permission::grant -party_id $members -object_id $package_id -privilege read

        # set up the admin portlet
        set admin_portal_id [dotlrn_community::get_admin_portal_id \
            -community_id $community_id \
        ]

        dotlrn_forums_admin_portlet::add_self_to_page \
            -portal_id $admin_portal_id \
            -package_id $package_id

        # set up the bboard portlet for this community
        set portal_id [dotlrn_community::get_portal_id \
            -community_id $community_id \
        ]

        # add the portlet to the comm's portal using add_portlet_helper
        set args [ns_set create]
        ns_set put $args package_id $package_id
        ns_set put $args display_group_name_p f
        ns_set put $args param_action overwrite

        dotlrn_forums::add_portlet_helper $portal_id $args

        return $package_id
    }

    ad_proc -public remove_applet_from_community {
        community_id
    } {
        remove the applet from the given community
    } {
        ad_return_complaint 1 "[applet_key] remove_applet_from_community not implemented!"
    }

    ad_proc -public add_user {
        user_id
    } {
        Called when the user is initially added as a dotlrn user.
        For one-time init stuff.
    } {
    }

    ad_proc -public remove_user {
        user_id
    } {
        called when a user is removed from dotlrn.
    } {
    }

    ad_proc -public add_user_to_community {
        community_id
        user_id
    } {
        Add a user to a specific dotlrn community
    } {
        set portal_id [dotlrn::get_portal_id -user_id $user_id]
        set package_id [dotlrn_community::get_applet_package_id \
            -community_id $community_id \
            -applet_key [applet_key] \
        ]
        set args [ns_set create]
        ns_set put $args package_id $package_id
        ns_set put $args param_action append

        # don't use the cached version
        dotlrn_forums::add_portlet_helper \
            [dotlrn::get_portal_id_not_cached -user_id $user_id] \
            $args

        dotlrn_forums::add_portlet_helper $portal_id $args

        # Set up notifications for all the forums that have set for autosubscription

        set type_id [notification::type::get_type_id -short_name forums_forum_notif]
        set interval_id [notification::get_interval_id -name instant]
        set delivery_method_id [notification::get_delivery_method_id -name email]

        foreach forum_id [db_list select_forums {}] {
            notification::request::new \
                -type_id $type_id \
                -user_id $user_id \
                -object_id $forum_id \
                -interval_id $interval_id \
                -delivery_method_id $delivery_method_id
        }

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
            -applet_key [applet_key] \
        ]

        set args [ns_set create]
        ns_set put $args package_id $package_id

        remove_portlet $portal_id $args

        foreach forum [forum::list_forums -package_id $package_id] {
            set forum_id [ns_set get $forum forum_id]

            notification::request::delete \
                -request_id [notification::request::get_request_id \
                    -type_id [notification::type::get_type_id -short_name forums_forum_notif] \
                    -user_id $user_id \
                    -object_id $forum_id \
                ]
        }
    }

    ad_proc -public add_portlet {
        portal_id
    } {
        A helper proc to set up default params for templates.

        @param portal_id
    } {
        set args [ns_set create]
        ns_set put $args package_id 0
        ns_set put $args display_group_name_p f
        ns_set put $args param_action overwrite

        set type [dotlrn::get_type_from_portal_id -portal_id $portal_id]

        if {$type eq "user"} {
            # portal_id is a user portal template
            ns_set put $args display_group_name_p t
        }

        add_portlet_helper $portal_id $args
    }

    ad_proc -public add_portlet_helper {
        portal_id
        args
    } {
        This does the call to add the portlet to the given portal.
        Params for the portlet are set by the calllers.

        @param portal_id
        @param args An ns_set of params
    } {
        forums_portlet::add_self_to_page \
            -portal_id $portal_id \
            -package_id [ns_set get $args package_id] \
            -param_action [ns_set get $args param_action] \
            -display_group_name_p [ns_set get $args display_group_name_p]
    }

    ad_proc -public remove_portlet {
        portal_id
        args
    } {
        A helper proc to remove the underlying portlet from the given portal.

        @param portal_id
        @param args An ns_set of args
    } {
        set package_id [ns_set get $args package_id]
        forums_portlet::remove_self_from_page $portal_id $package_id
    }

    ad_proc -public clone {
        old_community_id
        new_community_id
    } {
        Clone this applet's content from the old community to the new one
    } {
        dotlrn_forums::add_applet_to_community $new_community_id
    }

    ad_proc -public change_event_handler {
        community_id
        event
        old_value
        new_value
    } { 
        listens for the following events: rename
    } { 
        switch $event {
            rename {
                handle_rename -community_id $community_id -old_value $old_value -new_value $new_value
            }
        }
    }   

    ad_proc -private handle_rename {
        {-community_id:required}
        {-old_value:required}
        {-new_value:required}
    } {
        what to do with forums when the name of the community changes
    } {
        set package_id [dotlrn_community::get_applet_package_id \
            -community_id $community_id \
            -applet_key [applet_key] \
        ]
        set name "$old_value [_ dotlrn-forums.Forum]"

        db_foreach select_forums_with_old_name {
            select *
            from forums_forums
            where package_id = :package_id
            and name = :name
        } {
            forum::edit \
                -forum_id $forum_id \
                -name "$new_value [_ dotlrn-forums.Forum]" \
                -charter $charter \
                -presentation_type $presentation_type \
                -posting_policy $posting_policy
        }
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

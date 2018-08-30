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

    Procs to set up the dotLRN homework applet

    @author Don Baccus (dhogaza@pacifier.com)

}

namespace eval dotlrn_homework_applet {

    ad_proc -public applet_key {
    } {
        What's my key?
    } {
        return dotlrn_homework_applet
    }

    ad_proc -public package_key {
    } {
        What package do I deal with?
    } {
        return dotlrn-homework
    }

    ad_proc -public my_package_key {
    } {
        What's my package_key?
    } {
        return "dotlrn-homework"
    }

    ad_proc -public get_pretty_name {
    } {
        returns the pretty name
    } {
        return "[_ dotlrn-homework.pretty_name]"
    }

    ad_proc -public add_applet {
    } {
	Used for one-time init - must be repeatable!
    } {
        dotlrn_applet::add_applet_to_dotlrn -applet_key [applet_key] -package_key [package_key]
    }

    ad_proc -public remove_applet {
    } {
        remove the applet from dotlrn
    } {
        ad_return_complaint 1 "[applet_key] remove_applet not implemented!"
    }

    ad_proc -public add_portlet {
        portal_id
    } {

        Adds a porlet.
        @param portal_id The page to add portlet.
    } {
        dotlrn_homework_portlet::add_portlet -portal_id $portal_id
    }

    ad_proc -public remove_portlet {
        {-portal_id:required}
    } {
        Remove portlet
        @param portal_id The page from remove portlet.
    } {
        ad_return_complaint 1  "[applet_key] remove_portlet not implemented!"
    }


    ad_proc -private create_homework_folder {
        -community_id:required
        -package_id:required
    } {

        Helper proc for adding the homework applet to a community or cloning of an
        existing community.  This proc creates the target community's homework folder
        and sets the proper permissions.

        @param community_id    The community we're creating the homefolder for
        @param package_id      Our package id

        @return          The new folder id

    } {

        set community_name [dotlrn_community::get_community_name $community_id]
        set folder_id [fs::get_root_folder -package_id $package_id]

        fs::rename_folder -folder_id $folder_id -name "[_ dotlrn-homework.lt_homework_folder]"

        set node_id [site_node::get_node_id_from_object_id -object_id $package_id]
        site_node_object_map::new -object_id $folder_id -node_id $node_id

        set party_id [acs_magic_object registered_users]
        permission::revoke -party_id $party_id -object_id $folder_id -privilege read
        permission::revoke -party_id $party_id -object_id $folder_id -privilege write
        permission::revoke -party_id $party_id -object_id $folder_id -privilege admin

        set party_id [acs_magic_object the_public]
        permission::revoke -party_id $party_id -object_id $folder_id -privilege read
        permission::revoke -party_id $party_id -object_id $folder_id -privilege write
        permission::revoke -party_id $party_id -object_id $folder_id -privilege admin

        # Set up permissions on the homework folder
        # The homework folder is available only to community members
        set members [dotlrn_community::get_rel_segment_id \
            -community_id $community_id \
            -rel_type dotlrn_member_rel \
        ]

        # Class members can read from and write to the folder.  We'll manipulate direct
        # perms on files in order to implement the special restrictions placed on members 
        # actions

        permission::grant -party_id $members -object_id $folder_id -privilege read
        permission::grant -party_id $members -object_id $folder_id -privilege write

        # admins of this community can admin the folder
        set admins [dotlrn_community::get_rel_segment_id \
            -community_id $community_id \
            -rel_type dotlrn_admin_rel \
        ]
        permission::grant -party_id $admins -object_id $folder_id -privilege admin

        return $folder_id
    }

    ad_proc -public add_applet_to_community {
        community_id
    } {
        Add the homework applet to a specifc dotlrn community
    } {
        set portal_id [dotlrn_community::get_portal_id -community_id $community_id]
        set package_id [dotlrn::instantiate_and_mount $community_id [package_key]]

        set folder_id [create_homework_folder -community_id $community_id -package_id $package_id]
        
        # add the portlet

        dotlrn_homework_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id \
            -folder_id $folder_id -param_action overwrite

        # add the admin portlet
	set admin_portal_id [dotlrn_community::get_admin_portal_id -community_id $community_id]
	dotlrn_homework_admin_portlet::add_self_to_page -portal_id $admin_portal_id -package_id $package_id \
            -folder_id $folder_id -param_action overwrite

        return $package_id
    }
    
    ad_proc -public remove_applet_from_community {
        community_id
    } {
        remove the fs applet from a specifc dotlrn community
    } {
        ad_return_complaint 1 "[applet_key] remove_applet_from_community not implemented!"
    }

    ad_proc -public add_user {
        user_id
    } {
        One time user-specific init
    } {
        # no-op
    }

    ad_proc -public remove_user {
        user_id
    } {
    } {
        # no-op
    }

    ad_proc -public add_user_to_community {
        community_id
        user_id
    } {
        Add a user to a to a specifc dotlrn community
    } {
        # no-op
    }

    ad_proc -public remove_user_from_community {
        community_id
        user_id
    } {
        Remove a user from a community
    } {
        # no-op
    }

    ad_proc -public clone {
        old_community_id
        new_community_id
    } {

        Clone this applet's content from the old community to the new one

        We just create the homework folder and portlets in the new community,
        as requested by Sloan.

        @param old_community_id  The old (source) community
        @param new_community_id  The new (destination) community

        @return The package id for the homework package mounted in the new community
    } {

        # this code is copied from add_applet_to_community above
        # they should be refactored together
        
        # get the old comm's root folder id
        set old_package_id [dotlrn_community::get_applet_package_id -community_id $old_community_id -applet_key [applet_key]]
        set old_root_folder [fs::get_root_folder -package_id $old_package_id]
        
        # do homework folder stuff

        set portal_id [dotlrn_community::get_portal_id -community_id $new_community_id]
        set package_id [dotlrn::instantiate_and_mount $new_community_id [package_key]]

        set folder_id [create_homework_folder -community_id $new_community_id -package_id $package_id]
        
        # add the portlet

        dotlrn_homework_portlet::add_self_to_page -portal_id $portal_id -package_id $package_id \
            -folder_id $folder_id -param_action overwrite

        # add the admin portlet
	set admin_portal_id [dotlrn_community::get_admin_portal_id -community_id $new_community_id]
	dotlrn_homework_admin_portlet::add_self_to_page -portal_id $admin_portal_id -package_id $package_id \
            -folder_id $folder_id -param_action overwrite

        return $package_id

    }

    ad_proc -public get_package_id {
    } {
        returns the package_id of the dotlrn-homework package
    } {
        return [db_string select_package_id {}]
    }

    ad_proc -public get_url {
    } {
        returns the URL for the dotlrn-homework package
    } {
        return [site_node::get_url_from_object_id -object_id [get_package_id]]
    }

    ad_proc -public change_event_handler {
        community_id
        event
        old_value
        new_value
    } {
        dotlrn-homework listens only for rename

        @param community_id  The community experiencing an event
        @param event         The event (rename)
        @param old_value     The old community name being changed
        @param new_value     The new community name
    } {
        switch $event {
            rename {
                fs::rename_folder -folder_id [fs::get_root_folder -package_id [get_package_id]] \
                    -name "[_ dotlrn-homework.lt_new_values]"
            }
        }
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

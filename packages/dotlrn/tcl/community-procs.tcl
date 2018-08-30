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

    Procs to manage dotLRN Communities

    @author Ben Adida (ben@openforce.net)
    @author Arjun Sanyal (arjun@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-09-28
    @cvs-id $Id: community-procs.tcl,v 1.211.2.6 2017/06/30 17:43:06 gustafn Exp $

}

namespace eval dotlrn_community {

    ad_proc -public is_initialized {
        {-community_type:required}
    } {
        is this dotlrn_community type initialized correctly?
    } {
        return [db_string is_dotlrn_community_type_initialized {
            select count(*)
            from dotlrn_community_types
            where community_type = :community_type
            and package_id is not null
        }]
    }

    ad_proc -public init {
        {-community_type:required}
        {-community_type_url_part:required}
        {-pretty_name ""}
    } {
        create base community_type for dotlrn_community type
    } {
        db_transaction {
            set package_id [dotlrn::mount_package \
                    -package_key [dotlrn::package_key] \
                    -url $community_type_url_part \
                    -pretty_name $pretty_name \
                    -directory_p "t"]

            dotlrn_community::set_type_package_id \
                -community_type $community_type \
                -package_id $package_id

            parameter::set_value -package_id $package_id -parameter dotlrn_level_p -value 0
            parameter::set_value -package_id $package_id -parameter community_type_level_p -value 1
            parameter::set_value -package_id $package_id -parameter community_level_p -value 0
        }
    }

    ad_proc -public one_community_package_key {} {
        return dotlrn
    }

    ad_proc -public one_community_type_package_key {} {
        return dotlrn
    }

    ad_proc -public new_type {
        {-description ""}
        {-community_type_key:required}
        {-parent_type "dotlrn_community"}
        {-pretty_name:required}
        {-url_part ""}
    } {
        Create a new community type.
    } {
        # Figure out parent_node_id
        set parent_node_id [get_type_node_id $parent_type]
        array set parent_node [site_node::get -node_id $parent_node_id]
	
	db_transaction {
            set community_type_key [db_exec_plsql create_community_type {}]

            set package_id [site_node::instantiate_and_mount \
                -parent_node_id $parent_node_id \
                -node_name [ad_decode $url_part "" $community_type_key $url_part] \
                -package_name $pretty_name \
                -package_key [one_community_type_package_key] \
                -context_id $parent_node(object_id)]
            
            # Set some parameters
            parameter::set_value -package_id $package_id -parameter dotlrn_level_p -value 0
            parameter::set_value -package_id $package_id -parameter community_type_level_p -value 1
            parameter::set_value -package_id $package_id -parameter community_level_p -value 0

            # Set the site node
            dotlrn_community::set_type_package_id \
                -community_type $community_type_key \
                -package_id $package_id
        }

        return $community_type_key
    }

    ad_proc -public delete_type {
        {-community_type_key:required}
    } {
        delete a community type
    } {
        db_transaction {
            # Get the package_id for the type
            set package_id [dotlrn_community::get_type_package_id \
                -community_type $community_type_key \
            ]

            # Delete the type
            db_exec_plsql delete_community_type {}

            # blow away the package_id and ALL associated site nodes
            site_node_apm_integration::delete_site_nodes_and_package \
                    -package_id $package_id
        }
    }

    ad_proc -public set_type_package_id {
        {-community_type:required}
        {-package_id:required}
    } {
        map the type's name to it's package_id
    } {
        db_dml update_package_id {}
    }

    ad_proc -public get_type_package_id {
        {-community_type:required}
    } {
        get the type's package_id 
    } {
        return [db_string select_package_id {}]
    }

    ad_proc -public get_type_node_id {
        community_type
    } {
        get the node ID of a community type
    } {
        return [db_string select_node_id {}]
    }

    ad_proc -public get_community_node_id {
        community_id
    } {
        get the node ID of a community
    } {
        return [db_string select_node_id {}]
    }

    ad_proc -public new {
        {-parent_community_id ""}
        {-description ""}
        {-community_type:required}
        {-object_type dotlrn_community}
        {-community_key ""}
        {-pretty_name:required}
        {-extra_vars ""}
    } {
        create a new community
    } {

        if {$community_key eq ""} {
            set community_key [dotlrn_community::generate_key -name $pretty_name]
        }

        check_community_key_valid_p \
            -complain_if_invalid \
            -community_key $community_key \
            -parent_community_id $parent_community_id

        set package_id [dotlrn::get_package_id]
	set dotlrn_package_id $package_id

        # Set up extra vars
        if {$extra_vars eq ""} {
            set extra_vars [ns_set create]
        }

        ns_set put $extra_vars parent_community_id $parent_community_id
        ns_set put $extra_vars community_type $community_type
        ns_set put $extra_vars community_key $community_key
        ns_set put $extra_vars pretty_name $pretty_name
        ns_set put $extra_vars pretty_plural $pretty_name
        ns_set put $extra_vars description $description
        ns_set put $extra_vars context_id $dotlrn_package_id

        db_transaction {
            set user_id [ad_conn user_id]
            set community_id [package_instantiate_object -extra_vars $extra_vars $object_type]

            # YON MAJOR HACK
            # acs_object.new() initializes the acs_attributes for us if the
            # object_type of this community matches the object_type of the
            # acs_attributes. this screws us because we use dotlrn_community
            # as the object_type for subgroups which means that their
            # attributes will be defaulted to empty strings but we will think
            # that they are set. we must delete them.
            db_dml delete_acs_attribute_values {
                delete
                from acs_attribute_values
                where object_id = :community_id
            }

            set template_id [dotlrn::get_portal_id_from_type -type $object_type]

            # Create comm's portal page
            set portal_id [portal::create \
                -template_id $template_id \
                -name "$pretty_name Portal" \
                -context_id $community_id \
                $user_id \
            ]

            # Create the comm's non-member page
            set non_member_portal_id [portal::create \
                -name "$pretty_name Non-Member Portal" \
                -default_page_name [dotlrn::parameter -name non_member_page_name] \
                -layout_name [dotlrn::parameter -name non_member_layout_name] \
                -context_id $community_id \
                $user_id \
            ]

            # Create the comm's admin page
            set admin_portal_id [portal::create \
                -name "$pretty_name Administration Portal" \
                -default_page_name [dotlrn::parameter -name admin_page_name] \
                -layout_name [dotlrn::parameter -name admin_layout_name] \
                -context_id $community_id \
                $user_id \
            ]

            # Set up the rel segments
            dotlrn_community::create_rel_segments -community_id $community_id

            # Set up the node
            if {$parent_community_id eq ""} {
                set parent_node_id [get_type_node_id $community_type]
            } else {
                set parent_node_id [get_community_node_id $parent_community_id]
            }
	    

            set package_id [site_node::instantiate_and_mount \
                -parent_node_id $parent_node_id \
                -node_name $community_key \
                -package_key [one_community_package_key] \
                -package_name $pretty_name \
                -context_id $community_id \
            ]

            # Set the right parameters
            parameter::set_value -package_id $package_id -parameter dotlrn_level_p -value 0
            parameter::set_value -package_id $package_id -parameter community_type_level_p -value 0
            parameter::set_value -package_id $package_id -parameter community_level_p -value 1

            # Set up the node
            dotlrn_community::set_package_id $community_id $package_id
            
            # update the portal_id and non_member_portal_id
            db_dml update_portal_ids {}

            # Add the default applets based on the community type
            # 2. the the list of default applets for this type
            if {$community_type eq "dotlrn_community"} {
                set default_applets [parameter::get \
                    -package_id $dotlrn_package_id \
                    -parameter default_subcomm_applets \
                ]
            } elseif {$community_type eq "dotlrn_club"} {
                set default_applets [parameter::get \
                    -package_id $dotlrn_package_id \
                    -parameter default_club_applets \
                ]
            } elseif {$community_type eq "user"} {
                set default_applets [parameter::get \
                    -package_id $dotlrn_package_id \
                    -parameter default_user_portal_applets \
                ]
            } else {
                set default_applets [parameter::get \
                    -package_id $dotlrn_package_id \
                    -parameter default_class_instance_applets \
                ]
            }


            set default_applets_list [string trim [split $default_applets {,}]]

            foreach applet_key $default_applets_list {
                if {[dotlrn_applet::applet_exists_p -applet_key $applet_key]} {
                    dotlrn_community::add_applet_to_community $community_id $applet_key
		    ns_log Notice "Added applet:::: $applet_key"
                }
            }
        }

	# Assign default community site template
	dotlrn_community::set_site_template_id -community_id $community_id \
	    -site_template_id [parameter::get -package_id [dotlrn::get_package_id] -parameter "CommDefaultSiteTemplate_p"]

        # This new community should _not_ inherit it's permissions
        # from the root dotlrn instance. Why? All dotlrn users
        # can read the root dotlrn instance, but only members of
        # this community should be able to read this instance (and
        # it's children)
        permission::set_not_inherit -object_id $community_id


        # Grant permission to dotlrn-admin group

        set dotlrn_admin_group_id [db_string group_id_from_name "
             select group_id from groups where group_name='dotlrn-admin'" -default ""]
        if {$dotlrn_admin_group_id ne "" } {

             permission::grant \
                  -party_id $dotlrn_admin_group_id  \
                  -object_id $community_id \
                  -privilege "admin"

        }


        # Grant read_private_data permission to "non guest" users.
        dotlrn_privacy::grant_read_private_data_to_non_guests -object_id $community_id
        
        #this block sets permissions for subcommunities
        while {1} {
            if {$parent_community_id ne ""} {
                #admin of the parent need admin on the subcommunity.
                set parent_admin_party [db_string parent_admin_party {
                    select segment_id
                    from rel_segments
                    where group_id = :parent_community_id and rel_type='dotlrn_admin_rel'
                }]
                permission::grant -party_id $parent_admin_party -object_id $community_id -privilege "admin"
                
                #if this community has a parent we need to work up the chain.
                set parent_community_id [get_parent_id -community_id $parent_community_id]
                
            } else {
                return $community_id
            }
        }
    }

    ad_proc set_active_dates {
        {-community_id:required}
        {-start_date:required}
        {-end_date:required}
    } {
        set the community active begin and end dates
    } {
        set start_date "[template::util::date::get_property year $start_date] [template::util::date::get_property month $start_date] [template::util::date::get_property day $start_date]"
        set end_date "[template::util::date::get_property year $end_date] [template::util::date::get_property month $end_date] [template::util::date::get_property day $end_date]"
        set date_format "YYYY MM DD"

        db_exec_plsql set_active_dates {}
    }

    ad_proc set_package_id {
        community_id
        package_id
    } {
        Update the node ID for the community
    } {
        db_dml update_package_id {}
        db_dml update_application_group_package_id {}
	util_memoize_flush "dotlrn_community::get_package_id_not_cached $community_id"
    }

    ad_proc -public get_url {
        {-current_node_id ""}
        {-package_id ""}
    } {
        This gets the relative URL for a package_id under a particular node_id
    } {
        if {$current_node_id eq ""} {
            set current_node_id [site_node::get_node_id -url [ad_conn url]]
        }

        return [db_string select_node_url {} -default ""]
    }

    ad_proc -public get_default_roles {
        {-community_id ""}
    } {
        get default rel_type data for this community
    } {
        if {$community_id eq ""} {
            set community_id [get_community_id]
        }
        set community_type [get_community_type_from_community_id $community_id]

        return [util_memoize "dotlrn_community::get_default_roles_not_cached -community_type $community_type"]
    }

    ad_proc -private get_default_roles_not_cached {
        {-community_type:required}
    } {
        if {[string match $community_type dotlrn_club] || [string match $community_type dotlrn_pers_community]} {
            set community_type dotlrn_community
        } elseif {![string match $community_type dotlrn_community]} {
            set community_type dotlrn_class_instance
        }

        return [db_list_of_lists select_role_data {}]
    }

    ad_proc -private get_roles {
        {-community_id ""}
    } {
        if {$community_id eq ""} {
            set community_id [get_community_id]
        }
        set default_roles [concat {*}[get_default_roles -community_id $community_id]]
        set attributes [concat {*}[get_attributes -community_id $community_id]]

        set roles [list]
        foreach {rel_type role pretty_name pretty_plural} $default_roles {
            set new_role [list]

            lappend new_role $rel_type
            lappend new_role $role

            set i [lsearch -exact $attributes "${role}_pretty_name"]
            if {$i > -1} {
                lappend new_role [lindex $attributes $i+1]
            } else {
                lappend new_role $pretty_name
            }

            set i [lsearch -exact $attributes "${role}_pretty_plural"]
            if {$i > -1} {
                lappend new_role [lindex $attributes $i+1]
            } else {
                lappend new_role $pretty_plural
            }

            lappend roles $new_role
        }

        return $roles
    }

    ad_proc -public get_role_pretty_name {
        {-community_id ""}
        {-rel_type:required}
    } {
        get the pretty name for the role associated with this rel_type
    } {
        if {$community_id eq ""} {
            set community_id [get_community_id]
        }

        set roles [concat {*}[get_roles -community_id $community_id]]
        set i [lsearch -exact $roles $rel_type]
        if {$i > -1} {
            set pretty_name [lindex $roles $i+2]
	    return [lang::util::localize $pretty_name]
        }

        return ""
    }

    ad_proc -public get_role_pretty_plural {
        {-community_id ""}
        {-rel_type:required}
    } {
        get the pretty plural for the role associated with this rel_type
    } {
        if {$community_id eq ""} {
            set community_id [get_community_id]
        }

        set roles [concat {*}[get_roles -community_id $community_id]]
        set i [lsearch -exact $roles $rel_type]
        if {$i > -1} {
            set pretty_plural [lindex $roles $i+3]
	    return [lang::util::localize $pretty_plural]
        }

	return ""
    }

    ad_proc -public get_all_roles {} {
        return the list of roles used in dotLRN
    } {
        return [util_memoize {dotlrn_community::get_all_roles_not_cached}]
    }

    ad_proc -private get_all_roles_not_cached {} {
        return [db_list_of_lists select_all_roles {}]
    }

    ad_proc -public get_all_roles_as_options {} {
        return the list of roles used in dotLRN
    } {
        set role_options [list]

        foreach {rel_type role pretty_name pretty_plural} [concat {*}[get_all_roles]] {
            lappend role_options [list [lang::util::localize $pretty_name] $rel_type]
        }

        return $role_options
    }

    ad_proc -public set_roles_pretty_data {
        {-community_id ""}
        {-roles_data:required}
    } {
        set the pretty_name and pretty_plural for several roles
    } {
        if {$community_id eq ""} {
            set community_id [get_community_id]
        }

        foreach {rel_type role pretty_name pretty_plural} [concat {*}$roles_data] {
            set_role_pretty_data \
                -community_id $community_id \
                -rel_type $rel_type \
                -role $role \
                -pretty_name $pretty_name \
                -pretty_plural $pretty_plural
        }
    }

    ad_proc -public set_role_pretty_data {
        {-community_id ""}
        {-rel_type:required}
        {-role:required}
        {-pretty_name:required}
        {-pretty_plural:required}
    } {
        set the pretty_name and pretty_plural of a role for a community
    } {
        if {$community_id eq ""} {
            set community_id [get_community_id]
        }

        set roles [concat {*}[get_roles -community_id $community_id]]
        set i [lsearch -exact $roles $rel_type]

        if {$i > -1} {
            set old_pretty_name [lindex $roles $i+2]
            if {![string match $pretty_name $old_pretty_name]} {
                set_attribute \
                    -community_id $community_id \
                    -attribute_name "${role}_pretty_name" \
                    -attribute_value $pretty_name
            }

            set old_pretty_plural [lindex $roles $i+3]
            if {![string match $pretty_plural $old_pretty_plural]} {
                set_attribute \
                    -community_id $community_id \
                    -attribute_name "${role}_pretty_plural" \
                    -attribute_value $pretty_plural
            }
        }
    }

    ad_proc -public get_rel_segment_id {
        {-community_id:required}
        {-rel_type:required}
    } {
        get the relational segment ID for a community and a rel type
    } {
        return [db_string select_rel_segment_id {} -default ""]
    }

    ad_proc -private get_members_rel_id {
        {-community_id:required}
    } {
        return [get_rel_segment_id -community_id $community_id -rel_type dotlrn_member_rel]
    }

    ad_proc -private get_admin_rel_id {
        {-community_id:required}
    } {
        return [get_rel_segment_id -community_id $community_id -rel_type dotlrn_admin_rel]
    }

    ad_proc -private rel_segments_grant_permission {
        {-community_id:required}
    } {
        Grant the standard set of privileges on the rel_segments of a community
    } {
        set member_segment_id [get_members_rel_id -community_id $community_id]
        set admin_segment_id [get_admin_rel_id -community_id $community_id]

        set parent_id [dotlrn_community::get_parent_id -community_id $community_id]
        set parent_admin_segment_id [get_admin_rel_id -community_id $parent_id]

        # Member privs
        foreach priv { read create write } {
            permission::grant \
                -party_id $member_segment_id \
                -object_id $community_id \
                -privilege $priv
        }

        # Admin privs
        permission::grant \
            -party_id $admin_segment_id \
            -object_id $community_id \
            -privilege admin
    }

    ad_proc -private rel_segments_revoke_permission {
        {-community_id:required}
    } {
        Revoke the standard set of privileges on the rel_segments of a community
    } {
        set member_segment_id [get_members_rel_id -community_id $community_id]
        set admin_segment_id [get_admin_rel_id -community_id $community_id]

        permission::revoke \
            -party_id $member_segment_id \
            -object_id $community_id \
            -privilege read
        permission::revoke \
            -party_id $member_segment_id \
            -object_id $community_id \
            -privilege write
        permission::revoke \
            -party_id $admin_segment_id \
            -object_id $community_id \
            -privilege admin
    }

    ad_proc -public create_rel_segments {
        {-community_id:required}
    } {
        create all the relational segments for a community
    } {
        set community_name [get_community_name $community_id]

        db_transaction {
            set member_segment_id [rel_segments_new \
                $community_id \
                dotlrn_member_rel \
                "[_ dotlrn.Members_of] $community_name" \
            ]
            set admin_segment_id [rel_segments_new \
                $community_id \
                dotlrn_admin_rel \
                "[_ dotlrn.Admins_of] $community_name" \
            ]
            rel_segments_grant_permission -community_id $community_id
        }
    }

    ad_proc -public delete_rel_segments {
        {-community_id:required}
    } {
        remove the rel segments for a community
    } {
        set member_segment_id [get_members_rel_id -community_id $community_id]
        set admin_segment_id [get_admin_rel_id -community_id $community_id]

        rel_segments_revoke_permission -community_id $community_id
        rel_segments_delete $admin_segment_id
        rel_segments_delete $member_segment_id
    }

    ad_proc -public list_admin_users {
        community_id
    } {
        Returns list of admin users
    } {
        return [list_users -rel_type dotlrn_admin_rel $community_id]
    }

    ad_proc -public list_users {
        {-rel_type dotlrn_member_rel}
        community_id
    } {
        Returns the list of users with a membership_id, a user_id, first name,
        last name, email, and role. 
    } {
        return [dotlrn_community::list_users_not_cached \
            -rel_type $rel_type \
            -community_id $community_id
        ]
    }

    ad_proc -private list_users_not_cached {
        {-rel_type:required}
        {-community_id:required}
    } {
        Memoizing helper
    } {
        set bio_attribute_id [db_string bio_attribute_id {
            select attribute_id
            from acs_attributes
            where object_type = 'person'
            and attribute_name = 'bio'
        }]

        return [db_list_of_ns_sets select_users {}]
    }

    ad_proc -public list_possible_subcomm_users {
        {-subcomm_id:required}
    } {
        Returns the list of users from the subcomm's parent group that
        are not already in the subcomm with a membership_id, a user_id,
        first name, last name, email, and role
    } {
        return [db_list_of_ns_sets select_possible_users {}]
    }

    ad_proc -public list_users_in_role {
        {-rel_type:required}
        community_id
    } {
        Returns the list of users with a membership_id, a user_id,
        first name, last name, email, in a given role.
    } {
        return [db_list_of_lists select_users_in_role {}]
    }

    ad_proc -public member_p {
        community_id
        user_id
    } {
        check membership
    } {
        return [db_string select_count_membership {}]
    }

    ad_proc -public member_pending_p {
        {-community_id:required}
        {-user_id:required}
    } {
        is this user awaiting membership in this community?
    } {
        return [db_string is_pending_membership {}]
    }

    ad_proc -public add_user {
        {-rel_type dotlrn_member_rel}
        {-member_state approved}
        community_id
        user_id
    } {
        add a user to a particular community based on the community type
    } {
        set toplevel_community_type \
                [get_toplevel_community_type_from_community_id $community_id]

        if {$toplevel_community_type eq "dotlrn_class_instance"} {
            if {$rel_type eq "dotlrn_member_rel"} {
                set rel_type "dotlrn_student_rel"
            }
            dotlrn_class::add_user \
                -rel_type $rel_type \
                -community_id $community_id \
                -user_id $user_id \
                -member_state $member_state
        } elseif {$toplevel_community_type eq "dotlrn_club"} {
            dotlrn_club::add_user \
                -rel_type $rel_type \
                -community_id $community_id \
                -user_id $user_id \
                -member_state $member_state
        } else {
            add_user_to_community \
                -rel_type $rel_type \
                -community_id $community_id \
                -user_id $user_id \
                -member_state $member_state
        }

        util_memoize_flush "dotlrn_community::list_users_not_cached -rel_type $rel_type -community_id $community_id"
        util_memoize_flush_regexp  $user_id
    }

    ad_proc -public add_user_to_community {
        {-rel_type dotlrn_member_rel}
        {-community_id:required}
        {-user_id:required}
        {-member_state approved}
        {-extra_vars ""}
    } {
        Assigns a user to a particular role for that class.
        Roles in DOTLRN can be student, prof, ta, admin
    } {
	ns_log debug "dotlrn_community::add_user_to_community community_id '${community_id}' user_id '${user_id}'"

        if {[member_p $community_id $user_id]} {
            return
        }

        db_transaction {
            # Create the form
            if {$extra_vars eq ""} {
                set extra_vars [ns_set create]
            }

            # ns_set put $extra_vars portal_id $portal_id
            ns_set put $extra_vars user_id $user_id
            ns_set put $extra_vars community_id $community_id

            # Set up the relationship
            if {[catch {set rel_id [relation_add \
                -member_state "needs approval" \
                -extra_vars $extra_vars \
                $rel_type \
                $community_id \
                $user_id \
            ]} errmsg]} {
                set savedInfo $::errorInfo

                if {[string match -nocase {acs_object_rels_un} $errmsg]} {
                    return
                } else {
                    error $errmsg $savedInfo
                }
            }

            if {$member_state eq "approved"} {
                membership_approve -user_id $user_id -community_id $community_id
            }
        }

    }

    ad_proc -public membership_approve {
        {-user_id:required}
        {-community_id:required}
    } {
        Approve membership to a community
    } {
        db_1row select_rel_info {}

        db_transaction {
            membership_rel::approve -rel_id $rel_id

            applets_dispatch \
                -community_id $community_id \
                -op AddUserToCommunity \
                -list_args [list $community_id $user_id]

        }

        callback dotlrn_community::membership_approve -user_id $user_id -community_id $community_id

    }

    ad_proc -public membership_reject {
        {-user_id:required}
        {-community_id:required}
    } {
        Reject membership to a community
    } {
        # This is the *right* thing to do, but for now we'll just remove them
        # (ben)
        # db_1row select_rel_info {}

        # db_transaction {
        #    membership_rel::reject -rel_id $rel_id
        # }

        remove_user $community_id $user_id
    }

    ad_proc -public remove_user {
        community_id
        user_id
    } {
        Removes a user from a community (and all subcomms she's a member of)
    } {
        db_transaction {
            # recursively drop membership from subgroups of this comm
            foreach subcomm_id [get_subcomm_list -community_id $community_id] {
                if { [member_p $subcomm_id $user_id] } {
                    remove_user $subcomm_id $user_id
                }
            }

            # Do Callbacks
            applets_dispatch \
                -community_id $community_id \
                -op RemoveUserFromCommunity \
                -list_args [list $community_id $user_id]

            # get the rel_id
            db_1row select_rel_info {}

            # Remove it
            relation_remove $rel_id

            # flush the list_users cache
            util_memoize_flush "dotlrn_community::list_users_not_cached -rel_type $rel_type -community_id $community_id"
        }
        util_memoize_flush_regexp $user_id
    }

    ad_proc -public remove_user_from_all {
        {-user_id:required}
    } {
        Remove a user from all communities
    } {
        foreach community_ns_set [dotlrn_community::get_all_communities_by_user $user_id] {
            set community_id [ns_set get $community_ns_set community_id]
            if { [member_p $community_id $user_id] } {
                dotlrn_community::remove_user $community_id $user_id
            }
        }
    }

    ad_proc -public get_all_communities_by_user {
        user_id
    } {
        returns all communities for a user
    } {
        return [db_list_of_ns_sets select_communities_by_user {}]
    }

    ad_proc -public get_communities_by_user {
        community_type
        user_id
    } {
        Return a datasource of the communities that a user belongs to in a particular type
    } {
        set list_of_communities [list]

        db_foreach select_communities {} {
            lappend list_of_communities [list $community_id $community_type $pretty_name $description [get_url -package_id $package_id]]
        }

        return $list_of_communities
    }

    ad_proc -public get_all_communities {
        community_type
    } {
        Returns a list of all communities, and whether or not they are active.
    } {
        return [db_list_of_lists select_all_communities {}]
    }

    ad_proc -public get_toplevel_community_type {
        {-community_type:required}
    } {
        returns the toplevel community_type which is the ancestor of this
        community_type
    } {
        return [db_string select_community_type {}]
    }

    ad_proc -public get_toplevel_community_type_from_community_id {
        community_id
    } {
        returns the community type from community_id
    } {
        set type [get_community_type_from_community_id $community_id]

        if {$type eq "dotlrn_community"} {
            return $type
        }

        return [db_string select_community_type {}]
    }

    ad_proc -public get_community_type_from_community_id {
        community_id
    } {
        returns the community type from community_id
    } {
        return [util_memoize "dotlrn_community::get_community_type_from_community_id_not_cached -community_id $community_id"]
    }

    ad_proc -private get_community_type_from_community_id_not_cached {
        {-community_id:required}
    } {
        returns the community type from community_id
    } {
        return [db_string select_community_type {}]
    }

    ad_proc -public get_community_type {
    } {
        Returns the community type key depending on the node we're at
    } {
        set package_id [ad_conn package_id]
        return [util_memoize "dotlrn_community::get_community_type_not_cached -package_id $package_id"]
    }

    ad_proc -private get_community_type_not_cached {
        {-package_id:required}
    } {
        Returns the community type key depending on the node we're at
    } {
        return [db_string select_community_type {} -default ""]
    }

    ad_proc -public get_community_id_from_url {
        {-url ""}
    } {
        returns the community from a URL
    } {
        if {$url eq ""} {
            set url [ad_conn url]
        }

        set package_id [site_node::closest_ancestor_package -include_self -url $url -package_key dotlrn]

        return [get_community_id -package_id $package_id]
    }

    ad_proc -public get_community_id {
        {-package_id ""}
    } {
        Returns the community id depending on the package_id
        we're at, or the package_id passed in.

	If no community_id found, return empty_string

	@param package_id PackageID for which to search the community_id for
	@return community_id of the community where the package is mounted, empty string if not found
    } {
        if {$package_id eq ""} {
            set package_id [site_node::closest_ancestor_package \
                                -url [ad_conn url] \
                                -include_self \
                                -package_key dotlrn]
	    if {$package_id eq ""} {
		set package_id [ad_conn package_id]
	    }
        }

	if {$package_id ne ""} {
	    return [util_memoize [list dotlrn_community::get_community_id_not_cached -package_id $package_id]]
	} else {
	    return ""
	}
    }

    ad_proc -private get_community_id_not_cached {
        {-package_id:required}
    } {
        Returns the community id depending on the package_id
        we're at, or the package_id passed in
    } {
        return [db_string select_community {} -default ""]
    }

    ad_proc -public get_parent_community_id {
        {-package_id ""}
    } {
        Returns the community_id of our parent node or the parent
        of the passed in package_id. This is used for certain scripts
        under a dotlrn community, such as workflow panels, that cannot
        be passed their community_id.
    } {
        if {$package_id eq ""} {
            set package_id [ad_conn package_id]
        }

        return [util_memoize "dotlrn_community::get_parent_community_id_not_cached -package_id $package_id"]
    }

    ad_proc -private get_parent_community_id_not_cached {
        {-package_id:required}
    } {
        Returns the community_id of our parent node or the parent
        of the passed in package_id. This is used for certain scripts
        under a dotlrn community, such as workflow panels, that cannot
        be passed their community_id.
    } {
        array set parent_node [site_node::get_from_object_id -object_id $package_id]

        return [get_community_id -package_id $parent_node(object_id)]
    }

    ad_proc -public get_parent_id {
        {-community_id:required}
    } {
        Returns the parent community's id or null
    } {
        return [util_memoize "dotlrn_community::get_parent_id_not_cached -community_id $community_id"]
    }

    ad_proc -private get_parent_id_not_cached {
        {-community_id:required}
    } {
        Returns the parent community's id or null
    } {
        return [db_string select_parent_id {} -default ""]
    }

    ad_proc -public get_parent_name {
        {-community_id:required}
    } {
        Returns the parent community's name or null string
    } {
        set parent_id [get_parent_id -community_id $community_id]

        if {$parent_id eq ""} {
            return ""
        } else {
            return [get_community_name $parent_id]
        }
    }

    ad_proc -public generate_key {
        {-name:required}
    } {
        Generate a key from a name. Compresses all adjacent non-alphanum
        chars to a dash. Yes, this is not unique, grows rapidly, will
        need collision detection and resolution, yada yada.
    } {
        set existing [db_list existing_community_keys {}]

        return [util_text_to_url \
                    -replacement {} \
                    -existing_urls [concat $existing { members configure spam index not-allowed clone help }] \
                    -- $name]
    }


    ad_proc -public check_community_key_valid_p {
        {-community_key:required}
        {-parent_community_id ""}
        {-complain_if_invalid:boolean}
    } {
        Checks if the community_key passed in is valid for creating a new
        community by checking that it's not the same as an existing (possible)
        sibling's name.
    } {
        if {$parent_community_id ne ""} {
            set valid_p [ad_decode [db_string collision_check_with_parent {}] 0 1 0]
        } else {
            # LARS 2003-10-21: Should this check only against communities with null parent_id?
            set valid_p [ad_decode [db_string collision_check_simple {}] 0 1 0]
        }

        if {$complain_if_invalid_p && !$valid_p} {
            ns_log notice "The name '$community_key' is already in use either by an active or archived group. \n Please go back and select a different name."
            ad_return_complaint 1 \
                [_ dotlrn.community_name_already_in_use [list community_key $community_key]]

            ad_script_abort
        } else {
            return $valid_p
        }
    }

    ad_proc -public subcommunity_p {
        {-community_id:required}
    } {
        Returns 1 if the community is a subcommunity, else 0
    } {
        if {[get_parent_id -community_id $community_id] eq ""} {
            return 0
        } else {
            return 1
        }
    }

    ad_proc -public has_subcommunity_p {
        {-community_id:required}
    } {
        Returns 1 if the community has a subcommunity, memoized for 1 min
    } {
        return [util_memoize "dotlrn_community::has_subcommunity_p_not_cached -community_id $community_id" 60]
    }

    ad_proc -private has_subcommunity_p_not_cached {
        {-community_id:required}
    } {
        Returns 1 if the community has a subcommunity
    } {
        return [db_0or1row select_subcomm_check {}]
    }

    ad_proc -public get_subcomm_list {
        {-community_id:required}
    } {
        Returns a Tcl list of the subcommunities of this community or
        if none, the empty list
    } {
        return [db_list select_subcomms {}]
    }

    ad_proc -public get_subcomm_info_list {
        {-community_id:required}
    } {
        Returns a Tcl list of ns_sets with info about each subcomm. The keys
        are: community_id, community_key, pretty_name, archived_p and url. Returns both archived and unarchived subcommunities.
    } {
        return [db_list_of_ns_sets select_subcomms_info {}]
    }

    ad_proc -public get_subcomm_chunk {
        {-user_id ""}
        {-community_id:required}
        {-pretext "<li>"}
        {-join_target register}
        {-drop_target deregister}
        {-only_member_p 0}
    } {
        Returns a html fragment of the subcommunity hierarchy of this
        community or if none, the empty list.

        Brief notes: his proc always shows the subgroups of the
        passed-in group, but shows deeper groups _only if_ you are a
        member of all the supergroups to the leaf subgroup. Not even
        admins see the whole tree.

        FIXME: we want to be rid of this proc. it's only used in the dotlrn-portlet.
        A better solution is to do a db_multirow like yon's in dotlrn-main-portlet.

        things to get: has_subcom, member_p, url, name, admin_p, not_closed_p,
                       member_pending, needs_approval
        things to send: user_id, sc_id,
    } {
        ns_log Notice "RUnning ad_proc get_subcomm_chuunk"
        set chunk ""

        if {$user_id eq ""} {
            set user_id [ad_conn user_id]
        }

        set show_drop_link_p [parameter::get_from_package_key \
                                  -package_key dotlrn-portlet \
                                  -parameter AllowMembersDropGroups \
                                  -default 0]

        foreach sc_id [get_subcomm_list -community_id $community_id] {

	    set url [get_community_url $sc_id]
	    set subgroup_name [get_community_name $sc_id]

            if {[has_subcommunity_p -community_id $sc_id] 
		&& [member_p $sc_id $user_id]} {
                # Shows the subcomms of this subcomm ONLY IF I'm a
                # member of the current comm
                append chunk [subst {$pretext
		    <a href="[ns_quotehtml $url]" title="[_ dotlrn.goto_subgroup_name]">$subgroup_name</a>
		}]

                if {$show_drop_link_p} {
		    set href [export_vars -base ${url}${drop_target} {{referer {[ad_conn url]}}}]
                    append chunk [subst {
			(<a href="[ns_quotehtml $href]" title="[_ dotlrn.Drop_from_subgroup_name]">[_ dotlrn.Drop]</a>)
		    }]
                }

                append chunk "<ul>\n[get_subcomm_chunk -community_id $sc_id -user_id $user_id -only_member_p $only_member_p]</ul>\n"
            } elseif {[member_p $sc_id $user_id] || [not_closed_p -community_id $sc_id]} {
                
                # Shows the subcomm if:
                # 1. I'm a member of this subcomm OR
                # 2. I'm have admin rights over the subcomm OR
                # 3. The subcomm has an "open" OR "request" join policy
                # but if the only_member_p flag is true, the user must be
                # a member of the subcomm to see it.
                if {$only_member_p && ![member_p $sc_id $user_id]} {
                    continue
                }
                
                # We will use the parent_url in our register link because before the user has
                # registered they can't read the subgroup, and they can't read the subgroup because
                # they haven't joined it yet.   The semantics enforced by using the parent group's
                # url seem right to me: the request processor will kick out any attempt to register
                # if the user can't read the parent group, while register itself will protect against
                # illicit registrations if the group is closed.
                set parent_url [get_community_url $community_id]

                append chunk [subst {$pretext
		    <a href="[ns_quotehtml $url]" title="[_ dotlrn.goto_subgroup_name]">$subgroup_name</a>
		}]

                if {![member_p $sc_id $user_id] && [not_closed_p -community_id $sc_id]} {
                      append chunk "<nobr>"

                      if {[member_pending_p -community_id $sc_id -user_id $user_id]} {
                          append chunk "[_ dotlrn.Pending_Approval]"
                      } elseif {[needs_approval_p -community_id $sc_id]} {
			  set href [export_vars -base ${parent_url}${join_target} {{community_id $sc_id} {referer {[ad_conn url]}}}]
                          append chunk [subst {
			      <a href="[ns_quotehtml $href]" title="[_ dotlrn.Request_Membership_for_subgroup_name]">[_ dotlrn.Request_Membership]</a>
			  }]
                      } else {
			  set href [export_vars -base ${parent_url}${join_target} {{community_id $sc_id} {referer {[ad_conn url]}}}]
                          append chunk [subst {
			      (<a href="[ns_quotehtml $href]" title="[_ dotlrn.Join_subgroup_name]">[_ dotlrn.Join]</a>)
                              
                          } ]
                      }
                    
                    append chunk "\n"
                }  elseif {[member_p $sc_id $user_id]} {
                    
                    # User is a member.
                    if {$show_drop_link_p} {
			set href [export_vars -base ${url}${drop_target} {{referer {[ad_conn url]}}}]
                        append chunk [subst {
			    (<a href="[ns_quotehtml $href]" title="[_ dotlrn.Drop_from_subgroup_name]">[_ dotlrn.Drop]</a>)
			}]
                    }
                }
            }
        }
        
        return $chunk
    }
    
    ad_proc -public get_community_type_url {
        community_type
    } {
        Get the URL for a community type
    } {
        return [lindex [site_node::get_url_from_object_id -object_id [get_community_type_package_id $community_type]] 0]
    }

    ad_proc -public get_community_url {
        community_id
    } {
        Get the URL for a community
    } {
        return [lindex [site_node::get_url_from_object_id -object_id [get_package_id $community_id]] 0]
    }

    ad_proc -public get_community_type_package_id {
        community_type
    } {
        get the package id for a particular community type
    } {
        return [db_string select_package_id {} -default [dotlrn::get_package_id]]
    }


    ad_proc -public get_package_id {
        community_id
    } {
        get the package ID for a particular community.
	This is cached as the package ID is not going to change
    } {
        return [util_memoize [list dotlrn_community::get_package_id_not_cached $community_id]]
    }

    ad_proc -public get_package_id_not_cached {
        community_id
    } {
        get the package ID for a particular community
    } {
        return [db_string select_package_id {} -default [dotlrn::get_package_id]]
    }

    ad_proc -public get_applet_package_id {
        {-community_id:required}
        {-applet_key:required}
    } {
        get the package ID for a particular community
    } {
        return [db_string select_package_id {} -default ""]
    }

    ad_proc -public get_community_type_name {
        community_type
    } {
        get the name for a community type
    } {
        return [db_string select_community_type_name {} -default ""]
    }

    ad_proc -public set_community_name {
        {-community_id:required}
        {-pretty_name:required}
    } {
        update the name for a community
    } {
        set old_value [get_community_name $community_id]

        db_dml update_community_name {}

        # rename the package - this is used in the user interface. ie - context bar and
        # in the portlets

        set package_id [dotlrn_community::get_package_id $community_id]
        apm_package_rename -package_id $package_id -instance_name $pretty_name

        util_memoize_flush "dotlrn_community::get_community_name_not_cached $community_id"

        # generate "rename" event
        raise_change_event \
            -community_id $community_id \
            -event rename \
            -old_value $old_value \
            -new_value $pretty_name
    }

    ad_proc -public get_community_name {
        community_id
    } {
        get the name for a community
    } {
        return [util_memoize "dotlrn_community::get_community_name_not_cached $community_id"]
    }

    ad_proc -private get_community_name_not_cached {
        community_id
    } {
        memo helper
    } {
        return [db_string select_community_name {} -default ""]
    }

    ad_proc -public get_community_header_name {
        community_id
    } {
        get the name for a community for the header
    } {
        if {[subcommunity_p -community_id $community_id]} {
            set parent_name [get_parent_name -community_id $community_id]
            set parent_url [get_community_url [get_parent_id -community_id $community_id]]
            return [subst {<a href="[ns_quotehtml $parent_url]">$parent_name</a>: [get_community_name $community_id]}]
        } else {
            return [get_community_name $community_id]
        }
    }

    ad_proc -public navigation_context {
        community_id
    } {
        Get the navigation context (list of url and name pairs) 
        of the given community. Used for generating context bar.

        @author Peter Marklund
    } {
        set context [list]

        if {[subcommunity_p -community_id $community_id]} {
            set parent_name [get_parent_name -community_id $community_id]
            set parent_url [get_community_url [get_parent_id -community_id $community_id]]

            lappend context [list $parent_url $parent_name]
        }

        set community_name [get_community_name $community_id]
        set community_url [get_community_url $community_id]

        lappend context [list $community_url $community_name]

        return $context
    }

    ad_proc -public get_community_description {
        {-community_id:required}
    } {
        get the description for a community
    } {
        return [db_string select_community_description {} -default ""]
    }

    ad_proc -public set_community_description {
        {-community_id:required}
        {-description:required}
    } {
        update the description for a community
    } {
        db_dml update_community_description {}
    }

    ad_proc -public get_community_key {
        {-community_id:required}
    } {
        Get the key for a community
    } {
        return [db_string select_community_key {} -default ""]
    }

    ad_proc -public not_closed_p {
        {-community_id:required}
    } {
        returns 1 if the community's join policy is not closed
    } {
        return [db_string check_community_not_closed {} -default 0]
    }

    ad_proc -public open_p {
        {-community_id:required}
    } {
        returns 1 if the community's join policy is 'open'
    } {
        return [db_string check_community_open {} -default 0]
    }

    ad_proc -public needs_approval_p {
        {-community_id:required}
    } {
        returns 1 if the community's join policy is 'needs approval' aka "request approval"
    } {
        return [db_string check_community_needs_approval {} -default 0]
    }

    ad_proc -public get_portal_id {
        {-community_id ""}
    } {
        get the id of the comm's portal
    } {
        if {$community_id eq ""} {
            set community_id [get_community_id]
        }

        return [util_memoize "dotlrn_community::get_portal_id_not_cached -community_id $community_id"]
    }

    ad_proc -private get_portal_id_not_cached {
        {-community_id:required}
    } {
        get the id of the comm's portal
    } {
        return [db_string select_portal_id {} -default ""]
    }

    ad_proc -public get_non_member_portal_id {
        {-community_id ""}
    } {
        Get the community portal_id for non-members
    } {
        if {$community_id eq ""} {
            set community_id [get_community_id]
        }

        return [util_memoize "dotlrn_community::get_non_member_portal_id_not_cached -community_id $community_id"]
    }

    ad_proc -private get_non_member_portal_id_not_cached {
        {-community_id:required}
    } {
        Get the community portal_id for non-members
    } {
        return [db_string select_non_member_portal_id {}]
    }

    ad_proc -public get_admin_portal_id {
        {-community_id ""}
    } {
        Get the community Admin portal_id
    } {
        if {$community_id eq ""} {
            set community_id [get_community_id]
        }

        return [util_memoize "dotlrn_community::get_admin_portal_id_not_cached -community_id $community_id"]
    }

    ad_proc -private get_admin_portal_id_not_cached {
        {-community_id:required}
    } {
        Get the community Admin portal_id
    } {
        return [db_string select_admin_portal_id {}]
    }

    ad_proc -public register_applet {
        {-community_id:required}
        {-package_id:required}
        {-applet_key:required}
    } {
        Helper proc for add_applet_to_community and clone, since
        they both need to set up the community <-> applet map
    } {
        set applet_id [dotlrn_applet::get_applet_id_from_key -applet_key $applet_key]

        # auto activate for now
        set active_p t
        db_dml insert {}
    }

    ad_proc -public add_applet_to_community {
        community_id
        applet_key
    } {
        Adds an applet to the community
    } {
        db_transaction {
            set package_id [applet_call \
                $applet_key \
                AddAppletToCommunity \
                [list $community_id]]
            
            register_applet \
                -community_id $community_id \
                -package_id $package_id \
                -applet_key $applet_key

            # Go through current users and make sure they are added!
            foreach user [list_users $community_id] {
                set user_id [ns_set get $user user_id]

                # do the callbacks
                applet_call \
                    $applet_key \
                    AddUserToCommunity \
                    [list $community_id $user_id]
            }
        }
    }

    ad_proc -public remove_applet_from_community {
        community_id
        applet_key
    } {
        Removes an applet from a community
    } {
        # Get the package_id
        set package_id [get_package_id $community_id]

        db_transaction {
            # Take care of all existing users
            foreach user [list_users $community_id] {
                set user_id [ns_set get $user user_id]

                # do the callbacks
                applet_call $applet_key RemoveUserFromCommunity [list $community_id $user_id]
            }

            # Callback
            applet_call $applet_key RemoveAppletFromCommunity [list $community_id]

            # Delete from the DB
            set applet_id [dotlrn_applet::get_applet_id_from_key -applet_key $applet_key]
            db_dml delete_applet_from_community {}
        }
    }

    ad_proc -public clone {
        {-community_id:required}
        {-key:required}
        {-pretty_name ""}
        {-description ""}
        {-parent_community_id ""}
        {-term_id ""}
    } {
        Clones a community. Cloning is a deep copy of the
        comm's metadata with a newly generated key. Callbacks are
        made to the comm's applets "clone" procs. Subgoups of comm's
        are also recursively cloned as well.

        @param community_id the community to clone
        @return the clone's community_id
    } {
        set subcomm_p 0

        db_transaction {

            # create the clone, by manually copying the metadata
            # this code is copied from ::new
            set community_type \
                [get_community_type_from_community_id $community_id]

            set extra_vars [ns_set create]

            # there is some special stuff for cloning subcomms
            if {"dotlrn_community" eq $community_type} {
                set subcomm_p 1
                
                # we need this here in case we are being called from ourself
                if {$parent_community_id eq ""} {
                    set parent_community_id [get_parent_id -community_id $community_id]
                }
                set parent_type [dotlrn_community::get_community_type_from_community_id $parent_community_id]

                if {$parent_type ne [dotlrn_club::community_type] &&
                    $parent_type ne "dotlrn_community" } {
                    # we want to make a subgroup of a class instance
                    # get the term_id, since the subgroup should not
                    # outlive the class
                    set term_id [dotlrn_class::get_term_id -class_instance_id $parent_community_id]
                    ns_set put $extra_vars term_id $term_id
                }
                
                check_community_key_valid_p \
                    -complain_if_invalid \
                    -community_key $key \
                    -parent_community_id $parent_community_id

                ns_set put $extra_vars parent_community_id $parent_community_id
            } else {
                # we want to clone a club or class instance
                check_community_key_valid_p \
                    -complain_if_invalid \
                    -community_key $key
                
                if {$term_id ne ""} {
                    # it's a class instance that we're cloning
                    ns_set put $extra_vars class_key [db_string get_class_key {
                        select class_key 
                        from dotlrn_class_instances_full
                        where class_instance_id = :community_id
                    }]

                    ns_set put $extra_vars term_id $term_id
                    # re-write the comm type for class instances
                    set community_type [dotlrn_community::get_toplevel_community_type -community_type $community_type]
                }
            }

            if {$pretty_name eq ""} {
                set pretty_name $key
            }

            ns_set put $extra_vars community_type $community_type
            ns_set put $extra_vars community_key $key
            # just the key for now
            ns_set put $extra_vars pretty_name $pretty_name
            ns_set put $extra_vars pretty_plural $key
            ns_set put $extra_vars description $description
            ns_set put $extra_vars context_id [dotlrn::get_package_id]

            # LARS 2003-10-22: Shouldn't we set the join_policy, too? Otherwise they'll get created as 'closed'
            #ns_set put $extra_vars join_policy $join_policy

            # Create the clone object - "dotlrn community A"
            # Note: the "object_type" to pass into package_instantiate_object
            # is just the community_type
            set clone_id [package_instantiate_object \
                -extra_vars $extra_vars $community_type]

            set user_id [ad_conn user_id]

            # clone the comm's portal by using it as a template
            # this will get the pages, layouts, and theme, elements,
            # and element  parameters
            set portal_id [portal::create \
                -template_id [get_portal_id -community_id $community_id] \
                -name "$pretty_name Portal" \
                -context_id $clone_id \
                $user_id \
            ]

            # clone the non-member page
            set non_member_portal_id [portal::create \
                -template_id [get_non_member_portal_id \
                    -community_id $community_id] \
                -name "$pretty_name Non-Member Portal" \
                -context_id $clone_id \
                $user_id \
            ]

            # clone the admin page
            set admin_portal_id [portal::create \
                -template_id [get_admin_portal_id \
                    -community_id $community_id] \
                -name "$pretty_name Administration Portal" \
                -context_id $clone_id \
                $user_id \
            ]

            # Set up the rel segments
            dotlrn_community::create_rel_segments -community_id $clone_id

            # Set up the node
            if {$subcomm_p} {
                set parent_node_id [get_community_node_id $parent_community_id]
            } else {
                set parent_node_id [get_type_node_id $community_type]
            }
           
           set package_id [site_node::instantiate_and_mount \
                -node_name $key \
                -parent_node_id $parent_node_id \
                -package_key [one_community_type_package_key] \
                -package_name $pretty_name \
                -context_id $clone_id \
            ]  

            # Set the right parameters
            parameter::set_value \
                -package_id $package_id \
                -parameter dotlrn_level_p \
                -value 0
            parameter::set_value \
                -package_id $package_id \
                -parameter community_type_level_p \
                -value 0
            parameter::set_value \
                -package_id $package_id \
                -parameter community_level_p \
                -value 1

            # Set up the node
            dotlrn_community::set_package_id $clone_id $package_id

            # update the portal_id and non_member_portal_id
            db_dml update_portal_ids {}

            # more extra stuff for subcomms
            if {$subcomm_p} {
                set parent_admin_segment_id [dotlrn_community::get_rel_segment_id \
                    -community_id $parent_community_id \
                    -rel_type dotlrn_admin_rel \
                ]

                permission::grant \
                    -party_id $parent_admin_segment_id \
                    -object_id $clone_id \
                    -privilege admin

                # for a subcomm of a "class instance" set the start and end dates
                if {$parent_type ne [dotlrn_club::community_type] &&
                    $parent_type ne "dotlrn_community" } {

                    dotlrn_community::set_active_dates \
                        -community_id $clone_id \
                        -start_date [dotlrn_term::get_start_date -term_id $term_id] \
                        -end_date [dotlrn_term::get_end_date -term_id $term_id]
                }

                # Copy community attribute values from original.
                # See "YON MAJOR HACK" above. -AG
                db_dml delete_default_acs_attribute_values {}
                db_dml copy_customizations_if_any {}
            }

	    # This new community should _not_ inherit it's permissions
	    # from the root dotlrn instance. Why? All dotlrn users
	    # can read the root dotlrn instance, but only members of
	    # this community should be able to read this instance (and
	    # it's children)
	    permission::set_not_inherit -object_id $clone_id

            # Grant read_private_data permission to "non guest" users.
            dotlrn_privacy::grant_read_private_data_to_non_guests -object_id $clone_id

            # recursively clone the subcommunities
            set subcomm_list [get_subcomm_info_list -community_id $community_id]

            foreach subcomm $subcomm_list {
                set subcomm_id [ns_set get $subcomm community_id]
                
                clone \
                    -community_id $subcomm_id \
                    -key [ns_set get $subcomm community_key] \
                    -description [get_community_description -community_id $subcomm_id]  \
                    -parent_community_id $clone_id
            }

            foreach applet_key [list_applets -community_id $community_id] {
                # do the clone call on each applet in this community
                ns_log debug "dotlrn_community::clone cloning applet = $applet_key"
                set package_id [applet_call \
                    $applet_key \
                    "Clone" \
                    [list $community_id $clone_id]
                ]

                register_applet \
                    -community_id $clone_id \
                    -package_id $package_id \
                    -applet_key $applet_key
            }

            set_site_template_id -community_id $clone_id \
                -site_template_id [get_site_template_id -community_id $community_id]

        }
        
        return $clone_id
    }

    ad_proc -public archive {
        {-community_id:required}
    } {
        Archives a community. This means that:

        1. the community is marked as archived

        2. the RemovePortlet callback is called for all users of the
        community (both members and GAs) and all the applets.

        3. Do this recursively for all subcommunities.

    } {
        db_transaction {
            # do RemoveUserFromCommunity callback, which
            # calls the RemovePortlet proc with the right params

            foreach subcomm_id [get_subcomm_list -community_id $community_id] {
                archive -community_id $subcomm_id
            }

            foreach user [list_users $community_id] {
                set user_id [ns_set get $user user_id]
                applets_dispatch \
                        -community_id $community_id \
                        -op RemoveUserFromCommunity \
                        -list_args [list $community_id $user_id]
            }

            # mark the community as archived
            db_dml update_archive_p {}
        }
    }

    ad_proc -public unarchive {
        {-community_id:required}
    } {
        Unarchives a community.
        08/10-2003 CK looks like its done now
    } {
        # 19/06-2003 CK Activated the code for unarchive
        db_dml update_archive_p {}

        rel_segments_grant_permission -community_id $community_id

        # 08/10-2003 CK Must also execute AddUserToCommunity
        foreach user [list_users $community_id] {
            set user_id [ns_set get $user user_id]
            applets_dispatch \
                -community_id $community_id \
                -op AddUserToCommunity \
                -list_args [list $community_id $user_id]
        }
    }

    ad_proc -public nuke {
        {-community_id:required}
    } {
        NUKES the community.
        ** not done **
        ** do not use! **
    } {
        error
        ad_script_abort

        db_transaction {
            # Remove all users
            foreach user [list_users $community_id] {
                remove_user $community_id [ns_set get $user user_id]
            }

            # Remove all applets
            foreach applet [list_applets -community_id $community_id] {
                remove_applet_from_community $community_id $applet
            }

            # Clean up
            db_1row select_things_to_clean {
                select portal_id,
                       non_member_portal_id,
                       admin_portal_id,
                       package_id
                from dotlrn_communities
                where community_id = :community_id
            }

            db_dml update_portal_id {
                update dotlrn_communities_all
                set portal_id = NULL
                where community_id = :community_id
            }

            db_dml update_admin_portal_id {
                update dotlrn_communities_all
                set admin_portal_id = NULL
                where community_id = :community_id
            }

            db_dml update_non_member_portal_id {
                update dotlrn_communities_all
                set non_member_portal_id = NULL
                where community_id = :community_id
            }

            # delete the rel segments
            delete_rel_segments -community_id $community_id


            if {$admin_portal_id ne ""} {
                portal::delete $admin_portal_id
            }

            if {$non_member_portal_id ne ""} {
                portal::delete $non_member_portal_id
            }

            if {$portal_id ne ""} {
                portal::delete $portal_id
            }

            # call the communitie's delete pl/sql, which removes the group
            db_exec_plsql \
                remove_community \
                "begin dotlrn_community.del(:community_id); end;"

            # Remove the package
            db_exec_plsql delete_package "begin acs_object.del(:package_id) end;"
        }
    }

    ad_proc -public list_applets {
        {-community_id:required}
    } {
        lists the applets associated with a community
    } {
        return [db_list select_community_applets {}]
    }

    ad_proc -public list_active_applets {
        {-community_id:required}
    } {
        lists the applets associated with a community
    } {
        return [db_list select_community_active_applets {}]
    }

    ad_proc -public applet_active_p {
        {-community_id:required}
        {-applet_key:required}
    } {
        Is this applet active in this community? Does it do voulunteer work?
        Helps its neighbors? <joke> returns 1 or 0
    } {
        return [db_0or1row select_active_applet_p {}]
    }

    ad_proc -public applets_dispatch {
        {-community_id:required}
        {-op:required}
        {-list_args {}}
    } {
        Dispatch an operation to every applet, either in one communtiy or
        on all the active dotlrn applets
    } {
        foreach applet [list_active_applets -community_id $community_id] {
            applet_call $applet $op $list_args
        }
    }

    ad_proc -public applet_call {
        applet_key
        op
        {list_args {}}
    } {
        call a particular applet op
    } {
        acs_sc::invoke -contract dotlrn_applet -operation $op -call_args $list_args -impl $applet_key
    }

    ad_proc -public get_available_attributes {} {
        get a list of the attributes that we can get/set for dotLRN communities
    } {
        return [util_memoize {dotlrn_community::get_available_attributes_not_cached}]
    }

    ad_proc -private get_available_attributes_not_cached {} {
        return [db_list_of_lists select_available_attributes {}]
    }

    ad_proc -private get_available_attributes_flush {} {
        util_memoize_flush {dotlrn_community::get_available_attributes_not_cached}
    }

    ad_proc -public get_attributes {
        {-community_id ""}
    } {
        get the attributes of a given community
    } {
        if {$community_id eq ""} {
            set community_id [get_community_id]
        }

        return [util_memoize "dotlrn_community::get_attributes_not_cached -community_id $community_id"]
    }

    ad_proc -private get_attributes_not_cached {
        {-community_id:required}
    } {
        return [db_list_of_lists select_attributes {}]
    }

    ad_proc -public get_attribute {
        {-community_id ""}
        {-attribute_name:required}
    } {
        get the value for an attribute of this community
    } {
        set attribute_value ""
        foreach {attr_name attr_value} [concat {*}[get_attributes -community_id $community_id]] {
            if {[string match $attribute_name $attr_name]} {
                set attribute_value $attr_value
                break
            }
        }

        return $attribute_value
    }

    ad_proc -public set_attributes {
        {-community_id ""}
        {-pairs:required}
    } {
        set attributes for a certain community
    } {
        foreach {attr_name attr_value} [concat {*}$pairs] {
            set_attribute -community_id $community_id -attribute_name $attr_name -attribute_value $attr_value
        }
    }

    ad_proc -public set_attribute {
        {-community_id ""}
        {-attribute_name:required}
        {-attribute_value:required}
    } {
        set an attribute of this community
    } {
        # this is serious, we are trying to set an attribute that doesn't
        # exist
        set attribute_id [get_attribute_id -attribute_name $attribute_name]
        if {$attribute_id eq ""} {
            error "dotlrn_community::set_attribute: invalid attribute $attribute_name"
        }

        # we don't accept empty values (essentially, we are making the
        # acs_attribute_values.attr_value not null, which it is not in the db).
        if {$attribute_value eq ""} {
            return
        }

        if {$community_id eq ""} {
            set community_id [get_community_id]
        }

        # we assume that if the value of this attribute is null then we must
        # insert a new row for this attribute, if it's not null then we simply
        # update it's value. this is not enforced in the database since the
        # acs_attribute_values.attr_value column does not have a "not null"
        # constraint but we will enforce it via our api. if someone circumvents
        # our api then they can die and rot in hell.
        if {[get_attribute -community_id $community_id -attribute_name $attribute_name] eq ""} {
            db_dml insert_attribute {}
        } else {
            db_dml update_attribute_value {}
        }

        util_memoize_flush "dotlrn_community::get_attributes_not_cached -community_id $community_id"
    }

    ad_proc -public unset_attribute {
        {-community_id ""}
        {-attribute_name:required}
    } {
        ussets an attribute of this community
    } {
        if {$community_id eq ""} {
            set community_id [get_community_id]
        }

        # this is serious, we are trying to unset an attribute that doesn't
        # exist
        set attribute_id [get_attribute_id -attribute_name $attribute_name]
        if {$attribute_id eq ""} {
            error "dotlrn_community::set_attribute: invalid attribute $attribute_name"
        }
        # remove the row
        db_dml delete_attribute_value {}

        util_memoize_flush \
            "dotlrn_community::get_attributes_not_cached -community_id $community_id"
    }

    ad_proc -public unset_attributes {
        {-community_id ""}
    } {
        ussets all the attributes of this community
    } {
        db_dml delete_attributes {}

        util_memoize_flush \
            "dotlrn_community::get_attributes_not_cached -community_id $community_id"
    }

    ad_proc -public get_attribute_id {
        {-attribute_name:required}
    } {
        get the attribute id of an attribute
    } {
        set attribute_id ""

        foreach {attr_id attr_name} [concat {*}[get_available_attributes]] {
            if {[string match $attribute_name $attr_name]} {
                set attribute_id $attr_id
                break
            }
        }

        return $attribute_id
    }

    ad_proc -public attribute_valid_p {
        {-attribute_name:required}
    } {
        is this a valid attribute for dotlrn communities?
    } {
        set valid_p 0

        if {[get_attribute_id -attribute_name $attribute_name] ne ""} {
            set valid_p 1
        }

        return $valid_p
    }

    ad_proc -private raise_change_event {
        {-community_id:required}
        {-event:required}
        {-old_value:required}
        {-new_value:required}
    } {
        raise a change event so that anyone interested can take action
    } {
        applets_dispatch \
            -community_id $community_id \
            -op ChangeEventHandler \
            -list_args [list $community_id $event $old_value $new_value]
    }

    ad_proc -public get_package_id_from_package_key {
	{-package_key:required}
	{-community_id:required}
    } {
	Return the package_id of a certain package type mounted in a community
	
	@author Malte Sussdorff (sussdorff@sussdorff.de)
	@creation-date 2005-06-13
	
	@param package_key
	
       @param community_id
	
	@return 
	
	@error 
    } {
	
	set package_id [dotlrn_community::get_package_id $community_id]
	set site_node_id [site_node::get_node_id_from_object_id -object_id $package_id]
	set url [site_node::get_children -package_key "$package_key" -node_id $site_node_id]
	array set site_node [site_node::get_from_url -url [lindex $url 0]]
	return $site_node(package_id)
    }

    ad_proc -public send_member_email {
        {-community_id:required}
        {-to_user:required}
        {-type "on join"}
        {-var_list ""}
        {-override_email ""}
        {-override_subject ""}
        {-email_send_to ""}
        {-override_enabled:boolean}
        {-message_only:boolean}
    } {
        Send a membership email to the user

        @author Roel Canicula (roel@solutiongrove.com)
        @creation-date 2004-09-05

        @param community_id
        @param to_user
        @param type

        @return

        @error
    } {

        ns_log debug "dotlrn_community::send_member_email \n community_id '${community_id}' to_user '${to_user}' type '${type}'"

        set var_list [lindex [callback dotlrn::member_email_var_list -community_id $community_id -to_user $to_user -type $type] 0]
        array set vars $var_list
        if {![db_0or1row member_email {*SQL*}] }  {

            # Only use the default mail if this is set in a parameter (off by default).

            if {[parameter::get -package_id [dotlrn::get_package_id] -parameter "DefaultCommunityJoinMailP" -default 0]} {
                # no email in database, use default
                ns_log debug "DAVEB checking for default email community_id '${community_id}' type '${type}'"
                set default_email [lindex [callback dotlrn::default_member_email -community_id $community_id -to_user $to_user -type $type -var_list $var_list] 0]
                ns_log debug "DAVEB default email '${default_email}' community_id '${community_id}' type '${type}'"
                if {[llength $default_email]} {
                    set from_addr [lindex $default_email 0]
                    set subject [lindex $default_email 1]
                    set email [lindex $default_email 2]
                }
            } else {
                set subject ""
            }
        }

        #This is a trick. If the subject is set, send the mail. Otherwise don't. 
        # We gracefully assume that the subject will be empty if no mail should be send. Otherwise why
        # bother to create the welcome message in the first place (will be spam filtered...) MalteS
        if { ([info exists subject] && $subject ne "") || $override_subject ne "" } {
            ns_log Debug "DAVEB override email '${override_email}' override_subject '${override_subject}'"
            if {([info exists override_email] && $override_email ne "")} {
                set email $override_email
            }
            if {([info exists override_subject] && $override_subject ne "")} {
                set subject $override_subject
            }
            if {[info exists email] && "" ne [string trim $email] } {
                
                # user %varname% to substitute variables in email
                set subject_vars [lang::message::get_embedded_vars $subject]
                set email_vars [lang::message::get_embedded_vars $email]
                foreach var [concat $subject_vars $email_vars] {
                    if {![info exists vars($var)]} {
                        set vars($var) ""
                    }
                }
                set var_list [array get vars]
                set subject [lang::message::format $subject $var_list]
                set email "[lang::message::format $email $var_list]"
                
                if {$message_only_p} {
                    return [list $subject $email]
                }
                # Shamelessly cut & pasted from bulk mail
                if { (![info exists from_addr] || $from_addr eq "") } {
                    set from_addr [ad_system_owner]
                }
                
                if {$email_send_to eq ""} {
                    set to_addr [party::email -party_id $to_user]
                }  else {
                    set to_addr [party::email -party_id $email_send_to]
                }
                
                set extra_headers [ns_set create]
                
                set message [ad_html_text_convert -from text/enhanced -to text/html $email]
                set mime_type "text/html"
                
                acs_mail_lite::send \
                    -to_addr $to_addr \
                    -from_addr $from_addr \
                    -subject $subject \
                    -body $message \
                    -mime_type $mime_type \
                    -extraheaders $extra_headers \
                    -use_sender

                set return_val 1
            } else {
                set return_val 0
            }
        } else {
            # We did not send the mail so we still succeed :). MS
            set return_val 1
        }
        return $return_val
    }
    
    ad_proc -public set_site_template_id {
        {-community_id:required}
        {-site_template_id:required}
    } {
        Sets a given Site Template for a Community

	@author Victor Guerra ( guerra@galileo.edu )
	@creation-date 2006-03-11
	
	@param community_id The id of the Community that will change it's Site Template 
	@param site_template_id The id of the Site Template that will be used by the Community

    } {
        db_dml update_site_template {}
        set new_theme_id [db_string select_portal_theme {}]
        set portal_id [get_portal_id -community_id $community_id]
        db_dml update_portal_theme {}
        set portal_id [get_admin_portal_id -community_id $community_id]
	db_dml update_portal_theme {}
	util_memoize_flush [list dotlrn_community::get_site_template_id_not_cached -community_id $community_id]
	util_memoize_flush [list dotlrn_community::get_dotlrn_master_not_cached -community_id $community_id]
    }

    ad_proc -public get_dotlrn_master {
        {-community_id:required}
    } {
        Returns the master configured for a given Community

	@author Victor Guerra ( guerra@galileo.edu )
	@creation-date 2006-03-11

	@param community_id The id of the Community in order to obtain the master template configured for it

	@return The path of the master template that will be used.

    } {
        set site_template_id [get_site_template_id -community_id $community_id]
	return [dotlrn::get_master_from_site_template_id -site_template_id $site_template_id]
    }
    
    ad_proc -public get_site_template_id {
        {-community_id:required}
    } {
        Gets the id of the community's site template

	@author Victor Guerra ( guerra@galileo.edu )
	@creation-date 2006-03-11

	@param community_id The id of the Community of which we want to abtain the Site Template
   
	@return The id of the Site Template assigned to the Community

    } {
        return [util_memoize [list dotlrn_community::get_site_template_id_not_cached -community_id $community_id]]
    }
    
    ad_proc -private get_site_template_id_not_cached { 
        {-community_id:required}
    } {
	Gets the id of the community's site template - not cached
    } {
	set dotlrn_package_id [dotlrn::get_package_id] 
	set comm_site_template_id [db_string select_site_template_id {} -default "0"]
	if {[parameter::get -package_id $dotlrn_package_id -parameter AdminChangeSiteTemplate_p]} {
	    set site_template_id $comm_site_template_id
	} else {
	    set site_template_id [parameter::get -package_id $dotlrn_package_id -parameter CommDefaultSiteTemplate_p]
	    if {$site_template_id != $comm_site_template_id} {
		set_site_template_id -community_id $community_id -site_template_id $site_template_id
	    }
	}
	return $site_template_id
    }
    
    ad_proc -public assign_default_sitetemplate {
	{-site_template_id:required}
    } {
	Assigns a portal theme associated to a Site Template
	to all communities

	@author Victor Guerra ( guerra@galileo.edu )
	@creation-date 2006-03-11

	@param site_template_id The id of The Site Template to obtain the portal theme to be assigned
    
    } {
	
	# We need to update the portal theme before the first hit!
	set new_theme_id [db_string select_portal_theme {}]
        db_dml update_portal_themes {}
	db_dml update_portal_admin_themes {}
	
	util_memoize_flush_regexp "dotlrn_community::get_site_template_id_not_cached *" 
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

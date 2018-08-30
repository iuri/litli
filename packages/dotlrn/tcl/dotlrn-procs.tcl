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

    Procs for basic dotLRN

    @author ben@openforce.net
    @creation-date 2001-08-18

}

namespace eval dotlrn {

    ad_proc -public community_type {} {
        returns the base community type
    } {
        return dotlrn_community
    }

    ad_proc -public class_group_type_key {
    } {
	Returns the group type key used for class groups
    } {
	return [dotlrn::parameter -name class_group_type_key]
    }

    ad_proc -public group_type_key {
    } {
	Returns the group_type key that is being used for class management
    } {
	return [dotlrn::parameter -name group_type_key]
    }

    ad_proc -public package_key {} {
	returns the package key
    } {
	return dotlrn
    }

    ad_proc -public get_url {} {
	returns the root URL for dotLRN
    } {
	return "/[package_key]"
    }

    ad_proc -public get_admin_url {} {
	returns the root URL for dotLRN
    } {
	return "[get_url]/admin"
    }

    ad_proc -public is_instantiated {} {
	returns 1 if dotlrn is instantiated, 0 otherwise
    } {
        return [ad_decode [apm_num_instances [package_key]] 0 0 1]
    }

    ad_proc -public is_initialized {} {
        is dotlrn initialized with the right community_type?
    } {
        set community_type [community_type]
        return [db_string dotlrn_is_initialized {
            select count(*)
            from dotlrn_community_types
            where community_type = :community_type
            and package_id is not null
        }]
    }

    ad_proc -public init {} {
        create base community_type for dotlrn and create the user and subgroups
        portal templates
    } {
        db_transaction {
            dotlrn_community::set_type_package_id \
                -community_type [community_type] \
                -package_id [get_package_id]
            
            dotlrn::new_type_portal \
                -type user \
                -pretty_name [dotlrn::parameter -name user_portal_pretty_name]
            
            # do the same for subgroups (the dotlrn_community type)
            dotlrn::new_type_portal \
                -type dotlrn_community \
                -pretty_name [dotlrn::parameter -name subcommunities_pretty_plural]
        }
    }

    ad_proc -public is_package_mounted {
        {-package_key:required}
    } {
        returns 1 if package is mounted under dotlrn, 0 otherwise
    } {
        set list [site_node::get_children -package_key $package_key \
                      -node_id [get_node_id]]
        return [expr {[llength $list] > 0 ? 1 : 0}]
    }

    ad_proc -public mount_package {
        {-parent_node_id ""}
        {-package_key:required}
        {-url:required}
        {-directory_p:required}
        {-pretty_name ""}
    } {
        mount a package under dotlrn
    } {
        set parent_node_id [ad_decode $parent_node_id "" [get_node_id] $parent_node_id]

        db_transaction {
            array set parent_node [site_node::get -node_id $parent_node_id]
            set parent_package_id $parent_node(object_id)

            ns_log notice "dotlrn::mount_package: [array get parent_node]"

            set package_id [site_node::instantiate_and_mount \
                -node_name $url \
                -parent_node_id $parent_node_id \
                -package_key $package_key \
                -package_name $pretty_name \
                -context_id $parent_package_id \
            ]
        }

        return $package_id
    }

    ad_proc -public unmount_package {
        {-package_id:required}
    } {
        unmount a package previously mounted with dotlrn::mount_package.
        just a nice wrapper for the dotrn-*-procs so they don't have to 
        deal with site_nodes and apm directly.
    } {
        db_transaction {
            # site node del package instance
            site_node_delete_package_instance \
                -package_id $package_id \
                -node_id [site_node::get_node_id_from_object_id -object_id $package_id]
        }
    }

    ad_proc -public get_node_id {} {
	return the root node id for dotLRN
    } {
	return [site_node::get_node_id -url [get_url]]
    }

    ad_proc -public get_package_id {} {
	return the package ID for dotLRN
    } {
        return [site_node::get_object_id -node_id [get_node_id]]
    }

    ad_proc -public get_users_rel_segment_id {} {
	returns the rel_segment_id of the dotLRN users segment
    } {
	return [db_string select_user_rel_segment {}]
    }

    ad_proc -public get_user_theme {
	user_id
    } {
	Return the user default theme
    } {
	return [util_memoize "dotlrn::get_user_theme_not_cached $user_id"]
    }

    ad_proc -private get_user_theme_not_cached {
	user_id
    } {
	helper
    } {
	return [db_string select_user_theme {} -default ""]
    }

    ad_proc -public set_user_theme {
	user_id
	theme_id
    } {
	Set the user theme
    } {
	db_dml update_user_theme {}
    }

    ad_proc -public get_portal_id {
	{-user_id:required}
    } {
	Get the portal_id for a particular user
    } {
        return [util_memoize "dotlrn::get_portal_id_not_cached -user_id $user_id"]
    }

    ad_proc -private get_portal_id_not_cached {
	{-user_id:required}
    } {
	Get the portal_id for a particular user
    } {
	return [db_string select_user_portal_id {} -default ""]
    }

    ad_proc -public -deprecated get_user_name {
	user_id
    } {
	Get the names the the user.
        
        Deprectead. Use acs_user::get_element -element name instead.

        @see acs_user::get_element.
    } {
        if { $user_id == 0 } {
            return {}
        } else {
            return [acs_user::get_element -user_id $user_id -element name]
        }
    }

    ad_proc -public instantiate_and_mount {
	{-mount_point ""}
	community_id
	package_key
    } {
	Mount an application under a particular community
    } {
	if {$mount_point eq ""} {
	    set mount_point $package_key
	}

	# Get the parent node_id correctly
	set package_id [dotlrn_community::get_package_id $community_id]

	# We only take the first node right now
	# FIXME: in case of multi-mounting, which is doubtful, but possible
	# we have a problem here.
	set parent_node_id [site_node::get_node_id -url [lindex [site_node::get_url_from_object_id -object_id $package_id] 0]]

        set new_package_id [site_node::instantiate_and_mount \
            -node_name $mount_point \
            -parent_node_id $parent_node_id \
            -package_key $package_key \
            -context_id $package_id \
        ]

	# Return the newly created package_id
	return $new_package_id
    }
	
    ad_proc -public render_page {
	{-workspace_p ""}
	{-hide_links_p  f}
        {-render_style individual}
        {-page_num ""}
	portal_id
    } {
	render a page in a user's favorite style
    } {
	return [portal::render \
                -page_num $page_num \
                -hide_links_p $hide_links_p \
                -render_style $render_style \
                $portal_id
        ]
    }

    ad_proc -public get_group_id_from_user_type {
        -type
    } {
        return the group_id of the group that holds users of this type
    } {
        return [db_string select_group_id_from_user_type {} -default ""]
    }

    ad_proc -public get_rel_type_from_user_type {
        -type
    } {
        return the appropriate rel_type base on user type and access level
    } {
        return "dotlrn_${type}_profile_rel"
    }

    ad_proc -public parameter {
        -localize:boolean
        {-name:required}
        {-default ""}
    } {
        wrap 
    } {
        return [parameter::get -localize=$localize_p -package_id [get_package_id] -parameter $name -default $default]
    }

    ad_proc -public set_type_portal_id {
        {-type:required}
        {-portal_id:required}
    } {
        set the portal_id for this template type in the dotlrn_portal_types_map table
    } {
        db_dml insert {}
    }

    ad_proc -public get_type_from_portal_id {
        {-portal_id:required}
    } {
        Get the type from the passed in portal_id from the dotlrn_portal_types_map table
    } {
        return [db_string select {}]
    }

    ad_proc -public get_portal_id_from_type {
        {-type:required}
    } {
        What's this type's portal_id? If the type is not matched, 
        return the id of dotlrn_class_instance by default
    } {
        set id [db_string select {} -default ""]

        if {$id eq ""} {
            set type dotlrn_class_instance
	    # aks: this next line is necessary 
	    # for dotlrn_class_instances, don't remove it!
	    set id [db_string select {} -default ""]
        } 

        return $id
    }

    ad_proc -public new_type_portal {
        {-type:required}
        {-pretty_name:required}
    } {
        Create a portal for the given type. This is how "portal templates"
        (actually just regular portals) are created for things like the
        "user" portal, "communities", or "class instances". We can't just
        associate a portal_id with a dotlrn community_type since there's 
        no community type for a "user" portal. So we use the 
        dotlrn_portal_types_map table instead.

        @param type
        @param pretty_name
        @return portal_id
    } {
        # based on the type:
        # 1. get the page_names and layouts
        # 2. the the list of default applets for this type
        if {$type eq "dotlrn_community"} {
            set csv_list [dotlrn::parameter -name subcomm_pages_csv]
            set default_applets [dotlrn::parameter -name default_subcomm_applets]
        } elseif {$type eq "dotlrn_club"} {
            set csv_list [dotlrn::parameter -name club_pages_csv]
            set default_applets [dotlrn::parameter -name default_club_applets]
        } elseif {$type eq "user"} {
            set csv_list [dotlrn::parameter -name user_portal_pages_csv]
            set default_applets [dotlrn::parameter -name default_user_portal_applets]
        } else {
            set csv_list [dotlrn::parameter -name class_instance_pages_csv]
            set default_applets [dotlrn::parameter -name default_class_instance_applets]
        }
        
        # FIXME - if there's a proc to get the admin user_id w/o 
        # a connection put it here. This needs to be a vaild
        # grantee for the perms
        set user_id -1        
        
        set portal_id [portal::create \
            -name "$pretty_name Portal" \
            -csv_list $csv_list \
            $user_id
        ]
        
        # Associate this type with portal_id, must be before applet
        # callbacks, since they use this info
        set_type_portal_id \
            -type $type \
            -portal_id $portal_id

        # Add the default applets 
        set default_applets_list [string trim [split $default_applets {,}]]
        
        foreach applet_key $default_applets_list {
            if {[dotlrn_applet::applet_exists_p -applet_key $applet_key]} {
                if {[catch {dotlrn_community::applet_call $applet_key AddPortlet [list $portal_id]} errMsg]} { 
                    ns_log warning "FAILED: dotlrn_community::applet_call $applet_key AddPortlet [list $portal_id]\n$errMsg"
                }
            }
        }
    }

    ad_proc -public set_site_template_id {
        {-user_id:required}
        {-site_template_id:required}
    } {
        Sets a given Site Template for a User
	
	@author Victor Guerra ( guerra@galileo.edu )
	@creation-date 2006-03-11
	
	@param community_id The id of the User that will change his Site Template 
	@param site_template_id The id of the Site Template that will be used by the User
  
    } {
        set portal_id [dotlrn::get_portal_id -user_id $user_id]
        set new_theme_id [db_string select_portal_theme {}]
        db_dml update_portal_theme {}
        db_dml update_user_site_template {}
        util_memoize_flush [list dotlrn::get_site_template_id_not_cached -user_id $user_id]
        util_memoize_flush [list dotlrn::get_dotlrn_master_not_cached -user_id $user_id]
    }

    ad_proc -public get_dotlrn_master {
        {-user_id:required}
    } {
        Returns the master configured for a given User
	
	@author Victor Guerra ( guerra@galileo.edu )
	@creation-date 2006-03-11
	
	@param community_id The id of the User in order to obtain the master template configured for him
	
	@return The path of the master template that will be used.

    } {
	set site_template_id [get_site_template_id -user_id $user_id]
        return [get_master_from_site_template_id -site_template_id $site_template_id]
    }

    ad_proc -public get_site_template_id {
	{-user_id:required}
    } {
	Gets the id of a User's site template
	
	@author Victor Guerra ( guerra@galileo.edu )
	@creation-date 2006-03-11
	
	@param community_id The id of the User of whom we want to abtain the Site Template
	
	@return The id of the Site Template assigned to the User

    } {
        return [util_memoize [list dotlrn::get_site_template_id_not_cached -user_id $user_id] ]
    }

    ad_proc -private get_site_template_id_not_cached {
        {-user_id:required}
    } {
	Gets the id of the user's site template - not cached
    } {
	set dotlrn_package_id [dotlrn::get_package_id]
	set user_site_template_id [db_string select_site_template_id {} -default "0"]
	if {[parameter::get -package_id $dotlrn_package_id -parameter UserChangeSiteTemplate_p]} {
	    set site_template_id $user_site_template_id
	} else {
	    set site_template_id [parameter::get -package_id $dotlrn_package_id -parameter UserDefaultSiteTemplate_p]
	    if {$site_template_id != $user_site_template_id} {
		set_site_template_id -user_id $user_id -site_template_id $site_template_id
	    }
	}
	return $site_template_id
    }
    
    
    ad_proc -public get_master_from_site_template_id {
	{-site_template_id:required}
    } {
	Returns the master template associated to a given Site Template
	
	@author Victor Guerra ( guerra@galileo.edu )
	@creation-date 2006-03-11
	
	@param site_template_id The id of The Site Template to obtain the master template
	
	@return The path of the master template associated to the Site Template
	
    } {
	return [util_memoize [list dotlrn::get_master_from_site_template_id_not_cached -site_template_id $site_template_id]]
    }
    
    ad_proc -private get_master_from_site_template_id_not_cached {
	{-site_template_id:required}
    } {
	Returns the master template for a given site template
    } {
	return [db_string select_site_template_master {} \
		    -default [parameter::get -package_id [dotlrn::get_package_id] -parameter DefaultMaster_p]]
    }
    
    ad_proc -public assign_default_sitetemplate {
	{-site_template_id:required}
    } {
	Assigns a portal theme associated to a Site Template
	to all users
	
	@author Victor Guerra ( guerra@galileo.edu )
	@creation-date 2006-03-11
	
	@param site_template_id The id of The Site Template to obtain the portal theme to be assigned

    } {
	
	# We need to update the portal theme before the first hit!
	set new_theme_id [db_string select_portal_theme {}]
        db_dml update_portal_themes {update }

	util_memoize_flush_regexp "dotlrn::get_site_template_id_not_cached *" 
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

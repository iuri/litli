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

# dotlrn/tcl/club-procs.tcl
#
# procedures for dotlrn clubs
# distributed under the gnu gpl v2
#
# december 3, 2001

ad_library {
    procs to manage dotlrn clubs

    @author yon@openforce.net
    @creation-date 2001-12-03
}

namespace eval dotlrn_club {

    ad_proc -public community_type {} {
        return the community type
    } {
        return "dotlrn_club"
    }

    ad_proc -public get_url_part {} {
        return the url part for this community type
    } {
        return "clubs"
    }

    ad_proc -public get_url {} {
        return the url part for this community type
    } {
        return "/[get_url_part]"
    }

    ad_proc -public is_initialized {} {
        is dotlrn_class initialized with the right community_type?
    } {
        dotlrn_community::is_initialized -community_type [community_type]
    }

    ad_proc -public init {} {
        create base community_type for dotlrn_clubs
    } {
        set clubs_pretty_plural [parameter::get \
                                     -package_id [dotlrn::get_package_id] \
                                     -parameter clubs_pretty_plural
        ]

        db_transaction {
            dotlrn::new_type_portal \
                -type [community_type] \
                -pretty_name $clubs_pretty_plural
            
            dotlrn_community::init \
                -community_type [community_type] \
                -community_type_url_part [get_url_part] \
                -pretty_name $clubs_pretty_plural
        }
    }

    ad_proc -public new {
        {-pretty_name:required}
        {-description ""}
        {-join_policy "open"}
        {-parent_community_id ""}
	{-community_type "dotlrn_club"}
	{-community_key ""}
    } {
        creates a new club and returns the club key
	
	@param pretty_name The name the community will have
	@param community_key The key of the community, used e.g. in the URL
    } {
        set extra_vars [ns_set create]
        ns_set put $extra_vars join_policy $join_policy

	if {$community_type eq "" } {
	    set community_type [community_type]
	}

        return [dotlrn_community::new \
		    -community_type $community_type \
		    -object_type [community_type] \
		    -pretty_name $pretty_name \
		    -description $description \
		    -parent_community_id $parent_community_id \
		    -community_key $community_key \
		    -extra_vars $extra_vars]
    }

    ad_proc -public add_user {
        {-rel_type ""}
        {-community_id:required}
        {-user_id:required}
        {-member_state approved}
    } {
        Assigns a user to a particular role for that club.
    } {
        if {$rel_type eq ""} {
            set rel_type "dotlrn_member_rel"
        }

        dotlrn_community::add_user_to_community \
            -rel_type $rel_type \
            -community_id $community_id \
            -user_id $user_id \
            -member_state $member_state
    }

    ad_proc -public add_user_multiple {
        {-rel_type ""}
        {-community_ids:required}
        {-user_id:required}
        {-member_state approved}
    } {
        Assigns a user to a particular role for these clubs.
    } {
        if {$rel_type eq ""} {
            set rel_type "dotlrn_member_rel"
        }

	foreach community_id $community_ids {
	    dotlrn_community::add_user_to_community \
		-rel_type $rel_type \
		-community_id $community_id \
		-user_id $user_id \
		-member_state $member_state
	}
    }

}

ad_proc -public -callback contact::contact_form -impl dotlrn_club {
    {-package_id:required}
    {-form:required}
    {-object_type:required}
    {-party_id ""}
} {
    If organisation, ask to create new club
} {
    if {$object_type ne "person" } {
	
	set already_linked_p "f"
	if {$party_id ne ""} {

	    # if we are in edit mode we need to make that we are not
	    # already linked to a community
	    if {[application_data_link::get_linked -from_object_id $party_id -to_object_type "dotlrn_club"] ne ""} {
		set already_linked_p "t"
	    }
	}
	
	if {$already_linked_p == "f"} {
	    ad_form -extend -name $form -form {
		{create_club_p:text(radio) \
		     {label "[_ dotlrn.Create_Club]"} \
		     {options {{[_ acs-kernel.common_Yes] "t"} {[_ acs-kernel.common_No] "f"}}} \
		     {values "f"}
		}
	    }
	}
    }
}

ad_proc -public -callback contact::organization_new -impl dotlrn_club {
    {-package_id:required}
    {-contact_id:required}
    {-name:required}
} {
    create a new club for new organization
} {
    upvar create_club_p create_club_p
    
    if {([info exists create_club_p] && $create_club_p ne "")
	&& $create_club_p == "t"} {
	# Create the new club and create a link between it and
	# the new contact.

	set club_id [dotlrn_club::new -pretty_name "$name"]
	application_data_link::new -this_object_id $contact_id -target_object_id $club_id

	# Link the file storage directly to the contact
	set fs_id [fs::get_root_folder -package_id [dotlrn_community::get_package_id_from_package_key -package_key "file-storage" -community_id $club_id]]
	application_data_link::new -this_object_id $contact_id -target_object_id $fs_id
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

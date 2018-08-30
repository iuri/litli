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
    Procs to manage DOTLRN Classes

    @author Ben Adida (ben@openforce.net)
    @author yon (yon@openforce.net)
    @creation-date 2001-08-18
    @cvs-id $Id: class-procs.tcl,v 1.53.2.1 2015/09/11 11:40:39 gustafn Exp $
}

namespace eval dotlrn_class {

    ad_proc -public community_type {} {
        returns the base community type for classes
    } {
        return dotlrn_class_instance
    }

    ad_proc -public package_key {
    } {
        Returns the package key for this package
    } {
        return dotlrn
    }

    ad_proc -public one_class_package_key {
    } {
        Returns the package key for this package
    } {
        return dotlrn
    }

    ad_proc -public get_url_part {} {
        returns the url part for this community type
    } {
        return classes
    }

    ad_proc -public get_url {} {
        returns the url part for this community type
    } {
        return "/[get_url_part]"
    }

    ad_proc -public is_initialized {} {
        is dotlrn_class initialized with the right community_type?
    } {
        dotlrn_community::is_initialized -community_type [community_type]
    }

    ad_proc -public init {} {
        create base community_type for dotlrn_classes
    } {
        db_transaction {
            dotlrn::new_type_portal \
                -type [community_type] \
                -pretty_name [parameter::get \
                                  -package_id [dotlrn::get_package_id] \
                                  -parameter class_instance_portal_pretty_name]
            
            dotlrn_community::init \
                -community_type [community_type] \
                -community_type_url_part [get_url_part] \
                -pretty_name [parameter::get \
                                  -package_id [dotlrn::get_package_id] \
                                  -parameter classes_pretty_plural]
        }
    }

    ad_proc -public check_class_key_valid_p {
 	{-community_type_key ""}
        {-class_key:required}
        {-department_key:required}
    } {
        Checks if the class_key passed in is valid for the given dept name
        i. e. there are no sibling classes with the same key

        FIXME: Currently class keys must be globally unique
        (across all dept) since they are used to create acs_object
        types. We probably want to get rid of this constraint by
        adding some sequence numbers to the key. The query will change
        too.
        
    } {

	if {$community_type_key eq ""} {
	    set community_type_key "$department_key.$class_key"
	}

        if {[db_0or1row collision_check {}]} {
            # got a collision
            return 0
        } else {
            return 1 
        }
    }

    ad_proc -public new {
	{-class_key ""}
        {-department_key:required}
        {-pretty_name:required}
        {-description ""}
    } {
        Creates a new class - a class is a new community TYPE, not an actual
        class instance

        A class is like "Structure and Interpretation of
        Computer Programs." The return value is the short class name,
        a key that works in SQL, and that uniquely identifies the class.

        This class can then be instantiated for a particular semester.
    } {

	if {$class_key eq ""} {
            set new_class_key $department_key.[dotlrn::generate_key -name $pretty_name]
        } else {
            set new_class_key $class_key
        }
        
        # check if the name is already in use, if so, complain loudly
        if {![check_class_key_valid_p \
                  -community_type_key $new_class_key \
                  -class_key $class_key \
                  -department_key $department_key]} {
	    return
#             ad_return_complaint \
#                     1 \
#                     "Duplicate key error. The key $new_class_key already exists.
#                      <p>[_ dotlrn.lt_Please_select_a_diffe]."
        }        

        db_transaction {
            set class_key [dotlrn_community::new_type \
                -community_type_key "$department_key.$class_key" \
                -parent_type $department_key \
                -pretty_name $pretty_name \
                -description $description \
                -url_part $class_key]

            db_dml insert_class {}
        }
    }

    ad_proc -public delete  {
        {-class_key:required}
    } {
        Deletes an empty class (the TYPE), if there are no
        instantiated classes of this type.
    } {
        # check that it's empty
        if {![count_class_instances -class_key $class_key] == 0} {
            set msg_subst_list [list subject [parameter::get -localize -parameter classes_pretty_name] \
                                     class_instances [parameter::get -localize -parameter class_instances_pretty_plural]]
            ad_return_complaint 1 [_ dotlrn.class_may_not_be_deleted $msg_subst_list]

           ad_script_abort
        } 

        db_transaction {
            # delete the dept from the table
            db_dml delete_class {}

            # since depts are types, delete the type
            dotlrn_community::delete_type -community_type_key $class_key

        }
    }

    ad_proc -public count_class_instances {
        {-class_key:required}
    } {
        returns the number of class instances with the given class key
    } {
        return [db_string select_count_class_instaces {} -default 0]
    }

    ad_proc -public new_instance {
        {-class_key:required}
	{-class_instance_key ""}
        {-term_id:required}
        {-pretty_name ""}
        {-description ""}
        {-join_policy closed}
    } {
        Creates a new instance of a class for a particular term and year,
        and returns the class instance key.
    } {
        set term [dotlrn_term::get_term_name -term_id $term_id]
        set year [dotlrn_term::get_term_year -term_id $term_id]

        set extra_vars [ns_set create]
        ns_set put $extra_vars term_id $term_id
        ns_set put $extra_vars class_key $class_key
        ns_set put $extra_vars join_policy $join_policy

        if {$pretty_name eq ""} {
            set pretty_name  "[dotlrn_community::get_community_type_name $class_key]; $term $year"
        }
        db_transaction {
            set community_id [dotlrn_community::new \
                -community_key $class_instance_key \
                -description $description \
                -community_type $class_key \
                -object_type [community_type] \
                -pretty_name $pretty_name \
                -extra_vars $extra_vars \
            ]

            dotlrn_community::set_active_dates \
                -community_id $community_id \
                -start_date [dotlrn_term::get_start_date -term_id $term_id] \
                -end_date [dotlrn_term::get_end_date -term_id $term_id]
        }

        return $community_id
    }

    ad_proc -public add_user {
        {-rel_type ""}
        {-community_id:required}
        {-user_id:required}
        {-member_state "approved"}
    } {
        Assigns a user to a particular role for that class. 
        Roles in dotLRN can be student, prof, ta, admin
    } {
        if {$rel_type eq ""} {
            set rel_type "dotlrn_student_rel"
        }

        set extra_vars [ns_set create]
        ns_set put $extra_vars class_instance_id $community_id

        dotlrn_community::add_user_to_community \
            -rel_type $rel_type \
            -extra_vars $extra_vars \
            -community_id $community_id \
            -user_id $user_id \
            -member_state $member_state
    }

    ad_proc -public pretty_name {
        {-class_key:required}
    } {
        gets the pretty name for a particular class
    } {
        return [db_string select_class_pretty_name {} -default ""]
    }

    ad_proc -public get_term_id {
        {-class_instance_id:required}
    } {
        get the term_id for this class instance
    } {
        return [db_string get_term_id {}]
    }

    ad_proc -public get_term_name {
        {-class_instance_id:required}
    } {
        get the term for this class instance
    } {
        return [dotlrn_term::get_term_name \
                -term_id [get_term_id -class_instance_id $class_instance_id]
        ]
    }

    ad_proc -public get_term_year {
        {-class_instance_id:required}
    } {
        get the term year for this class instance
    } {
        return [dotlrn_term::get_term_year \
                -term_id [get_term_id -class_instance_id $class_instance_id]
        ]
    }

    ad_proc -public can_create {} {
        can a class be created? essentially, does at least one department
        exist?
    } {
        return [db_string can_create {}]
    }

    ad_proc -public can_instantiate {} {
        can we instantiate classes? essentially, are there any current terms?
    } {
        return [db_string can_instantiate {}]
    }

}



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

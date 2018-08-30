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
    Procs to manage dotLRN Departments

    @author yon (yon@openforce.net)
    @creation-date 2001-01-20
    @cvs-id $Id: department-procs.tcl,v 1.14.2.1 2015/09/11 11:40:39 gustafn Exp $
}

namespace eval dotlrn_department {

    ad_proc -public new {
	{-department_key ""}
        {-pretty_name:required}
        {-description ""}
        {-external_url ""}
    } {
        Create a new department.
    } {

	if {$department_key eq ""} {
	    set department_key [dotlrn::generate_key -name $pretty_name]
	}
        
        # check if the name is already in use, if so, complain loudly
        if {![check_department_key_valid_p \
                -department_key $department_key]} {
            ad_return_complaint \
                    1 \
                    [_ dotlrn.department_name_already_in_use [list department_pretty_name $pretty_name]]
            ad_script_abort
        }

        db_transaction {
            dotlrn_community::new_type \
                -community_type_key "$department_key" \
                -parent_type "dotlrn_class_instance" \
                -pretty_name $pretty_name \
                -description $description \
                -url_part $department_key

            db_dml insert_department {}
        }
    }

    ad_proc -public check_department_key_valid_p {
        {-department_key:required}
    } {
        Checks if the key is in use as a department key
    } {
        if {[db_0or1row check {}]} {
            return 0
        }
        return 1
    }

    ad_proc -public select_as_list {
    } {
        Select all departments as a list of tuples of format:
            "pretty_name department_key"
    } {
        return [db_list_of_lists select_departments {}]
    }

    ad_proc -public count_classes {
        {-department_key:required}
    } {
        retuns the number of classes under this department
    } {
        return [db_string select_count_classes {} -default 0]
    }

    ad_proc -public delete {
        {-department_key:required}
    } {
        Deletes an empty department. Use count_classes to verify it's empty.
    } {
        # check that it's empty
        if {![count_classes -department_key $department_key] == 0} {
            set msg_subst_list [list departments_pretty_name [parameter::get -localize -parameter departments_pretty_name]]
            ad_return_complaint 1 [_ dotlrn.department_must_be_empty_to_be_deleted $msg_subst_list]

            ad_script_abort
        } 

        db_transaction {
            # delete the dept from the table
            db_dml delete_department {}

            # since depts are types, delete the type
            dotlrn_community::delete_type -community_type_key $department_key

        }
    }

}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

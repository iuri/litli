# packages/dotlrn-homework/tcl/test/dotlrn-homework-procs.tcl

ad_library {
    
    Test cases for dotlrn-homework
    
    @author Roel Canicula (roel@solutiongrove.com)
    @creation-date 2006-02-23
    @arch-tag: 2cbd4146-c8f6-4ee7-946c-0c5d05378622
    @cvs-id $Id: dotlrn-homework-procs.tcl,v 1.2.10.1 2015/09/11 11:40:57 gustafn Exp $
}

aa_register_case -cats { api } \
    -procs { dotlrn_homework::new } \
    homework_new { Test homework submission } {
	aa_run_with_teardown \
	    -rollback \
	    -test_code {
		# Run on all assessment packages
		foreach element_id [db_list homework_elements {
		    select element_id
		    from portal_element_map
		    where name = 'dotlrn_homework_portlet'
		}] {
		    foreach param [portal::element_params_not_cached $element_id] {
			set params([lindex $param 0]) [lindex $param 1]
		    }


		    set test_package_id [ad_conn package_id]
		    set package_id [site_node::closest_ancestor_package -url [site_node::get_url_from_object_id -object_id $params(package_id)] -package_key dotlrn]

		    ad_conn -set package_id $package_id
		    util_memoize_flush "dotlrn_community::get_community_id_not_cached -package_id $package_id"
		    
		    set homework_id [dotlrn_homework::new \
					 -file_id [db_nextval acs_object_id_seq] \
					 -new_file_p 1 \
					 -parent_folder_id $params(folder_id) \
					 -title "AA Homework Submit Test" \
					 -description "AA Homework Submit Test" \
					 -upload_file [list readme.txt "[acs_root_dir]/readme.txt" text/plain] \
					 -homework_file_id 0 \
					 -package_id $params(package_id)]

		    aa_true "homework successfully uploaded: $homework_id" $homework_id

		    aa_log "deleting homework: $homework_id"

		    set item_id [content::revision::item_id -revision_id $homework_id]

		    content::item::delete -item_id $item_id

		    util_memoize_flush "dotlrn_community::get_community_id_not_cached -package_id $test_package_id"
		    ad_conn -set package_id $test_package_id
		}
	    }
    }
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

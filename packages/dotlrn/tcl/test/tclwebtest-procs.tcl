ad_library {
    Automated tests.

    @author Mounir Lallali
    @creation-date 14 June 2005
   
}

namespace eval dotlrn::twt {}

ad_proc dotlrn::twt::term_new {term_name start_date end_date} {

        set response 0
	
	# The admin dotlrn page url
	set dotlrn_admin_page_url "[site_node::get_package_url -package_key dotlrn]admin"	 
	::twt::do_request $dotlrn_admin_page_url

	tclwebtest::link follow "Terms"
	tclwebtest::link follow "New Term"
	tclwebtest::form find ~n "add_term"
	tclwebtest::field find ~n "term_name"
	tclwebtest::field fill $term_name
	tclwebtest::field find ~n "start_date" 
	tclwebtest::field fill $start_date
	tclwebtest::field find ~n "end_date"
	tclwebtest::field fill $end_date
	tclwebtest::form submit
	
	aa_log "Add Term form submited"

	set response_url [tclwebtest::response url]

        if {[string match "*$dotlrn_admin_page_url/terms" $response_url] } {
            if { [catch {tclwebtest::link find $term_name } errmsg] } {
                aa_error  "dotlrn::twt::term_new failed $errmsg : Didn't create a New Term"
            } else {
                aa_log "a New Term created"
                set response 1
            }
        } else {
            aa_error "dotlrn::twt::term_new failed, bad response url : $response_url"
        }

	return $response
} 

ad_proc dotlrn::twt::term_edit { term_name new_term_name term_year start_date end_date} {

        set response 0

	# The admin dotlrn page url
	set dotlrn_admin_page_url "[site_node::get_package_url -package_key dotlrn]admin"
	::twt::do_request $dotlrn_admin_page_url

	tclwebtest::link follow "Terms"	
	tclwebtest::link follow $term_name
	tclwebtest::link follow "Edit"

	tclwebtest::form find ~n "edit_term"
	tclwebtest::field find ~n "term_name"
	tclwebtest::field fill $new_term_name
	tclwebtest::field find ~n "term_year"
	tclwebtest::field fill $term_year
	tclwebtest::field find ~n "start_date"
	tclwebtest::field fill $start_date
	tclwebtest::field find ~n "end_date"
	tclwebtest::field fill $end_date
	tclwebtest::form submit
	aa_log "Edit Term form submited"

	set response_url [tclwebtest::response url]

        if {[string match "*$dotlrn_admin_page_url/term*" $response_url] } {
	    if { [catch {tclwebtest::assert text $new_term_name } errmsg] || [catch {tclwebtest::assert text $term_year } errmsg]} {
		aa_error  "dotlrn::twt::term_edit failed $errmsg : Didn't create a New Term"
	    } else {
		aa_log "Term edited"
	        set response 1
	    }
	} else {
	    aa_error "dotlrn::twt::term_edit failed, bad response url : $response_url"
        }

	return $response
}
  
ad_proc dotlrn::twt::department_new  {department_name description external_url department_key } {

        set response 0

	# The admin dotlrn page url
	set dotlrn_admin_page_url "[site_node::get_package_url -package_key dotlrn]admin"
	::twt::do_request $dotlrn_admin_page_url
	
	tclwebtest::link follow "Departments"
	tclwebtest::link follow "New Department"

	tclwebtest::form find ~n "add_department" 
	tclwebtest::field find ~n "pretty_name"
	tclwebtest::field fill $department_name 	
	tclwebtest::field find ~n "description"
	tclwebtest::field fill $description
	tclwebtest::field find ~n "external_url"
	tclwebtest::field fill $external_url	
	tclwebtest::field find ~n "department_key"
	tclwebtest::field fill $department_key			
	tclwebtest::form submit
	aa_log "Add Department form submited"

	set response_url [tclwebtest::response url]	
	
	if {[string match "*$dotlrn_admin_page_url/departments" $response_url] } {
	    if { [catch {tclwebtest::link find $department_name } errmsg] } {
			aa_error  "dotlrn::twt::department_new failed $errmsg : Didn't create a New Department"
	    } else {
		aa_log "New Department Created"
		set response 1
	    }
	} else {
	    aa_error "dotlrn::twt::department_new failed, bad response url : $response_url"
	}
	
	return $response
} 

ad_proc dotlrn::twt::department_delete { department_name department_key } {

        set response 0

	# The admin dotlrn page url
	set dotlrn_departments_page_url "[site_node::get_package_url -package_key dotlrn]admin/departments"
	::twt::do_request $dotlrn_departments_page_url
	
	set delete_url [export_vars -base "department-delete" { {department_key "$department_key"} {pretty_name "$department_name"} {referer "departments"} }]
	
	::twt::do_request "$delete_url"
	
	tclwebtest::form find ~n "delete_department"	
	tclwebtest::form submit ~n "yes_button"
	aa_log "Delete Department form submited"

	set response_url [tclwebtest::response url]	

	if {[string match "*$dotlrn_departments_page_url" $response_url] } {
	    if { ![catch {tclwebtest::link find $department_name} errmsg] } { 
		aa_error "dotlrn::twt::department_delete failed $errmsg : Didn't Delete a Department"
	    } else {
		aa_log "Dorlrn Department Deleted"
		set response 1
	    }
	} else {
	    aa_error "dotlrn::twt::department_delete failed, bad response url : $response_url"
	}

	return $response
} 

ad_proc dotlrn::twt::subject_new  { department_name subject_name description subject_key } {
        set response 0

	# The admin dotlrn page url
	set dotlrn_admin_page_url "[site_node::get_package_url -package_key dotlrn]admin"
	::twt::do_request $dotlrn_admin_page_url
	
	tclwebtest::link follow "Departments"
	tclwebtest::link follow $department_name
	tclwebtest::link follow {New subject}

	tclwebtest::form find ~n "add_class"
	tclwebtest::field find ~n "department_key"		
	tclwebtest::field select  $department_name
	tclwebtest::field find ~n pretty_name
	tclwebtest::field fill $subject_name
	tclwebtest::field find ~n description 
	tclwebtest::field fill $description
	tclwebtest::form submit
	aa_log "Add Subject Form submited"

	set response_url [tclwebtest::response url]	
	
	if {[string match "*$dotlrn_admin_page_url/classes*" $response_url] } {
	    if { [catch {tclwebtest::link find $subject_name } errmsg] } {
		aa_error  "dotlrn::twt::subject_new failed $errmsg : Didn't Create a New Subject"
	    } else {
		aa_log "Create a New Subject"
		set response 1
	    }
	} else {
	    aa_error "dotlrn::twt::subject_new failed, bad response url : $response_url"
	}

	return $response
} 

ad_proc dotlrn::twt::subject_delete  { department_name } {

        set response 0

	# The admin dotlrn page url
	set dotlrn_admin_page_url "[site_node::get_package_url -package_key dotlrn]admin"
	::twt::do_request $dotlrn_admin_page_url
	
	tclwebtest::link follow "Departments"
	tclwebtest::link follow $department_name
	tclwebtest::link follow {Delete subject}

	tclwebtest::form find ~n "delete_class"	
	tclwebtest::form submit ~n "formbutton:ok"
	aa_log "Delete Subject Form submited"

	set response_url [tclwebtest::response url]	
	
	if {[string match "*$dotlrn_admin_page_url/classes*" $response_url] } {
	    if {![catch {tclwebtest::link find $subject_name } errmsg] } {
		aa_error  "dotlrn::twt::subject_delete failed $errmsg : Didn't Delete Subject Department"
	    } else {
		  aa_log "Delete Subject Department"
		        set response 1
		}
	} else {
		aa_error "dotlrn::twt::subject_delete failed, bad response url : $response_url"
	}

	return $response
} 

ad_proc dotlrn::twt::subject_edit  { department_name subject_name new_subject_name new_description } {

        set response 0

	# The admin dotlrn page url
	set dotlrn_admin_page_url "[site_node::get_package_url -package_key dotlrn]admin"
	::twt::do_request $dotlrn_admin_page_url
	
	tclwebtest::link follow "Departments"
	tclwebtest::link follow $department_name
	tclwebtest::link follow $subject_name
	tclwebtest::link follow "Edit Subject properties."

	tclwebtest::form find ~n "edit_class"
	tclwebtest::field find ~n pretty_name
	tclwebtest::field fill $new_subject_name
	tclwebtest::field find ~n description 
	tclwebtest::field fill $new_description
	tclwebtest::form submit
	aa_log "Edit Subject Form submited"

        set response_url [tclwebtest::response url]

        if {[string match "*$dotlrn_admin_page_url/class?class_key*" $response_url] } {
	    if {[catch {tclwebtest::assert text $new_subject_name } errmsg] || [catch {tclwebtest::assert text $new_description } errmsg]} {
		aa_error  "dotlrn::twt::subject_edit failed $errmsg : Didn't Edit Subject Department"
	    } else {
		aa_log "Edit Subject Department"
		set response 1
	    }
        } else {
	    aa_error "dotlrn::twt::subject_edit failed, bad response url : $response_url"
        }

	return $response
}

ad_proc dotlrn::twt::class_new  { department_name class_name description class_key } {

        set response 0

	# The admin dotlrn page url
	set dotlrn_admin_page_url "[site_node::get_package_url -package_key dotlrn]admin"
	::twt::do_request $dotlrn_admin_page_url
	
	tclwebtest::link follow "Departments"
	tclwebtest::link follow $department_name
	tclwebtest::link follow {New Class}

	tclwebtest::form find ~n "add_class_instance"
	tclwebtest::field find ~n pretty_name
	tclwebtest::field fill $class_name
	tclwebtest::field find ~n description 
	tclwebtest::field fill $description
	tclwebtest::field find ~n add_instructor
	tclwebtest::field select -index 1
	tclwebtest::field find ~n class_instance_key 
	tclwebtest::field fill $class_key
	tclwebtest::form submit
	aa_log "Add Class Form submited"

	set response_url [tclwebtest::response url]	
	
	if {[string match "*$dotlrn_admin_page_url/class*" $response_url] } {
		if {[catch {tclwebtest::link find $class_name } errmsg] } {
			aa_error  "dotlrn::twt::class_new failed $errmsg : Didn't Create a New Class"
		} else {
			aa_log "Create a New Class"
		        set response 1
		}
	} else {
		aa_error "dotlrn::twt::class_new failed, bad response url : $response_url"
	}

	return $response
} 

ad_proc dotlrn::twt::community_new { community_name description } {

        set response 0

	# The admin dotlrn page url
	set dotlrn_community_page_url "[site_node::get_package_url -package_key dotlrn]admin/clubs"
	::twt::do_request $dotlrn_community_page_url
	#tclwebtest::link follow Communities

 	tclwebtest::link follow {New Community}

	tclwebtest::form find ~n "add_club"
	tclwebtest::field find ~n pretty_name
	tclwebtest::field fill $community_name
	tclwebtest::field find ~n description 
	tclwebtest::field fill $description
	tclwebtest::form submit	

	aa_log "Add Community Form submited"		

	set response_url [tclwebtest::response url]	
	
	if {[string match "*$dotlrn_community_page_url*" $response_url] } {
		if {[catch {tclwebtest::link find $community_name } errmsg] } {
			aa_error  "dotlrn::twt::community_new failed $errmsg : Didn't Create a New Community"
		} else {
			aa_log "Create a New Community"
		        set response 1
		}
	} else {
		aa_error "dotlrn::twt::community_new failed, bad response url : $response_url"
	}

	return $response
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

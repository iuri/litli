ad_library {
    Automated tests.
    @author Mounir Lallali
    @creation-date 14 June 2005

}

aa_register_case -cats {web smoke} -libraries tclwebtest  tclwebtest_dotlrn_new_term {

	Test Create a dotLRN Term.

	@author Mounir Lallali
} {
	aa_run_with_teardown -test_code {

	    tclwebtest::cookies clear
	    # Login user
	    array set user_info [twt::user::create -admin]
	    twt::user::login $user_info(email) $user_info(password)
	    
	    # Create new Term
	    set term_name [ad_generate_random_string]
	    set date [template::util::date::today]
                
	    set year [template::util::date::get_property year $date]
            set next_year [expr {$year+1}]
            set day [template::util::date::get_property day $date]
            set month [template::util::date::get_property month $date]
                
	    set start_date "$year-$month-$day"
	    set end_date "$next_year-$month-$day"
		
	    set response [dotlrn::twt::term_new $term_name $start_date $end_date]
	    aa_display_result -response $response -explanation {Webtest for creating a new Term}    
	    twt::user::logout
        }
}	

aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_dotlrn_edit_term {

        Test Edit a dotLRN Term.

	@author Mounir Lallali
} {
	aa_run_with_teardown -test_code {
	
            tclwebtest::cookies clear
            # Login user
            array set user_info [twt::user::create -admin]
            twt::user::login $user_info(email) $user_info(password)
	
	    # Create new Term
	    set term_name [ad_generate_random_string]
	    set start_date "2005-06-24"
	    set end_date   "2006-06-24"
		
	    dotlrn::twt::term_new $term_name $start_date $end_date
		
	    set new_term_name [ad_generate_random_string]
	    set date [template::util::date::today]
		
	    set year [template::util::date::get_property year $date]
	    set next_year [expr {$year+1}]
	    set day [template::util::date::get_property day $date]
	    set month [template::util::date::get_property month $date]
		
	    set new_start_date "$year-$month-$day"
	    set new_end_date "$next_year-$month-$day"
		
	    set term_year "$year/$next_year"
		
	    set response [dotlrn::twt::term_edit $term_name $new_term_name $term_year $new_start_date $new_end_date]
	    aa_display_result -response $response -explanation {Webtest for editing Term}   
	    twt::user::logout
        }
}	

aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_dotlrn_new_department {

	Test Create a New Department.

	@author Mounir Lallali
} {
	aa_run_with_teardown -test_code {
		
	    tclwebtest::cookies clear
            # Login user
	    array set user_info [twt::user::create -admin]
            twt::user::login $user_info(email) $user_info(password)

	    # Create a new Department
	    set department_name [ad_generate_random_string]
	    set description [ad_generate_random_string]
	    set external_url [ad_generate_random_string]
	    set department_key [ad_generate_random_string]
	    set response [dotlrn::twt::department_new $department_name $description $external_url $department_key]
	    aa_display_result -response $response -explanation {Webtest for creating a new Department}
	    twt::user::logout
	}
}
	
aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_dotlrn_delete_department {

	Test Delete Create a Department.

	@author Mounir Lallali
} {
	aa_run_with_teardown -test_code {
	    tclwebtest::cookies clear
            # Login user
            array set user_info [twt::user::create -admin]
            twt::user::login $user_info(email) $user_info(password)

	    # Create a new Department
	    set department_name [ad_generate_random_string]
	    set description [ad_generate_random_string]
	    set external_url [ad_generate_random_string]
	    set department_key [ad_generate_random_string]
	    dotlrn::twt::department_new $department_name $description $external_url $department_key
	    set response [dotlrn::twt::department_delete $department_name $department_key]
	    aa_display_result -response $response -explanation {Webtest for deleting a Department}
	    twt::user::logout
        }            	
}

aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_dotlrn_new_subject {

	Test Create a New Subject.

	@author Mounir Lallali
} {
	aa_run_with_teardown -test_code {
	    tclwebtest::cookies clear
            # Login user
            array set user_info [twt::user::create -admin]
            twt::user::login $user_info(email) $user_info(password)

	    # Create a new Department
	    set department_name [ad_generate_random_string]
	    set description [ad_generate_random_string]
	    set external_url [ad_generate_random_string]
	    set department_key [ad_generate_random_string]
	    dotlrn::twt::department_new $department_name $description $external_url $department_key	
	    # Create a New Subject
	    set subject_name [ad_generate_random_string]
	    set description [ad_generate_random_string]
	    set subject_key  [ad_generate_random_string]
	    set response [dotlrn::twt::subject_new $department_name $subject_name $description $subject_key]
	    aa_display_result -response $response -explanation {Webtest for creating a new Subject}
	    twt::user::logout
        }              	
}

aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_dotlrn_delete_subject {

        Test Delete a Subject.

	@author Mounir Lallali
} {
	aa_run_with_teardown -test_code {
	                tclwebtest::cookies clear
            # Login user
            array set user_info [twt::user::create -admin]
            twt::user::login $user_info(email) $user_info(password)

	    # Create a new Department
	    set department_name [ad_generate_random_string]
	    set description [ad_generate_random_string]
	    set external_url [ad_generate_random_string]
	    set department_key [ad_generate_random_string]
	    dotlrn::twt::department_new $department_name $description $external_url $department_key	
	    # Create a New Subject
	    set subject_name [ad_generate_random_string]
	    set description [ad_generate_random_string]
	    set subject_key  [ad_generate_random_string]
	    dotlrn::twt::subject_new $department_name $subject_name $description $subject_key
                
	    # Delete a Subject
	    set response [dotlrn::twt::subject_delete $department_name]
	    aa_display_result -response $response -explanation {Webtest for deleting a Subject}
	    twt::user::logout
        }              	
}

aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_dotlrn_edit_subject {

	Test Edit a Subject.

	@author Mounir Lallali
} {
	aa_run_with_teardown -test_code {
            tclwebtest::cookies clear
            # Login user
            array set user_info [twt::user::create -admin]
            twt::user::login $user_info(email) $user_info(password)

	    # Create a new Department
	    set department_name [ad_generate_random_string]
	    set description [ad_generate_random_string]
	    set external_url [ad_generate_random_string]
	    set department_key [ad_generate_random_string]
	    dotlrn::twt::department_new $department_name $description $external_url $department_key	
	    # Create a New Subject
	    set subject_name [ad_generate_random_string]
	    set description [ad_generate_random_string]
	    set subject_key  [ad_generate_random_string]
	    dotlrn::twt::subject_new $department_name $subject_name $description $subject_key		
	    # Edit a Subject
	    set new_subject_name [ad_generate_random_string]
	    set new_description [ad_generate_random_string]
	    set response [dotlrn::twt::subject_edit $department_name $subject_name $new_subject_name $new_description]
	    aa_display_result -response $response -explanation {Webtest for editing a Subject}
	    twt::user::logout
        }
}

aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_dotlrn_new_class {

        Test Create a New Class.

	@author Mounir Lallali
} {
	aa_run_with_teardown -test_code {
            tclwebtest::cookies clear
            # Login user
            array set user_info [twt::user::create -admin]
            twt::user::login $user_info(email) $user_info(password)

	    # Create a new Department
	    set department_name [ad_generate_random_string]
	    set description [ad_generate_random_string]
	    set external_url [ad_generate_random_string]
	    set department_key [ad_generate_random_string]
	    dotlrn::twt::department_new $department_name $description $external_url $department_key
 
	    # Create a New Subject
	    set subject_name [ad_generate_random_string]
	    set description [ad_generate_random_string]
	    set subject_key  [ad_generate_random_string]
	    dotlrn::twt::subject_new $department_name $subject_name $description $subject_key

	    # Create a New Class
	    set class_name [ad_generate_random_string]
	    set description [ad_generate_random_string]
	    set class_key  [ad_generate_random_string]
	    set response [dotlrn::twt::class_new $department_name $class_name $description $class_key]
	    aa_display_result -response $response -explanation {Webtest for creating a new Class}
	    twt::user::logout
	}
}

aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_dotlrn_new_community {

        Test Create a New Community.

	@author Mounir Lallali
} {
	aa_run_with_teardown -test_code {
            tclwebtest::cookies clear
            # Login user
            array set user_info [twt::user::create -admin]
            twt::user::login $user_info(email) $user_info(password)

	    # Create a New Community
	    set community_name [ad_generate_random_string]
	    set description [ad_generate_random_string]
	    set response [dotlrn::twt::community_new $community_name $description]
	    aa_display_result -response $response -explanation {Webtest for creating a new Community}
	    twt::user::logout
	}
}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

ad_library {
    
    Procs to set up the dotLRN assessment applet
    
    @author jopez@galileo.edu
    @cvs-id $Id: dotlrn-assessment-procs.tcl,v 1.6.2.2 2017/06/30 17:44:32 gustafn Exp $
}

namespace eval dotlrn_assessment {}

ad_proc -public dotlrn_assessment::applet_key {} {
    What's my applet key?
} {
    return dotlrn_assessment
}

ad_proc -public dotlrn_assessment::package_key {} {
    What package do I deal with?
} {
    return "assessment"
}

ad_proc -public dotlrn_assessment::my_package_key {} {
    What package do I deal with?
} {
    return "dotlrn-assessment"
}

ad_proc -public dotlrn_assessment::get_pretty_name {} {
    returns the pretty name
} {
    return "#assessment.Applet#"
}

ad_proc -public dotlrn_assessment::add_applet {} {
    One time init - must be repeatable!
} {
    dotlrn_applet::add_applet_to_dotlrn -applet_key [applet_key] -package_key [my_package_key]
}

ad_proc -public dotlrn_assessment::remove_applet {} {
    One time destroy. 
} {
    set applet_id [dotlrn_applet::get_applet_id_from_key [my_package_key]]
    db_exec_plsql delete_applet_from_communities { *SQL* } 
    db_exec_plsql delete_applet { *SQL* } 
}

ad_proc -public dotlrn_assessment::add_applet_to_community {
    community_id
} {
    Add the assessment applet to a specifc dotlrn community
} {
    set portal_id [dotlrn_community::get_portal_id -community_id $community_id]

    # create the assessment package instance 
    set package_id [dotlrn::instantiate_and_mount $community_id [package_key]]

    # set up the admin portal
    set admin_portal_id [dotlrn_community::get_admin_portal_id \
                             -community_id $community_id
                        ]

    assessment_admin_portlet::add_self_to_page \
        -portal_id $admin_portal_id \
        -package_id $package_id
    
    set args [ns_set create]
    ns_set put $args package_id $package_id
    add_portlet_helper $portal_id $args

    return $package_id
}

ad_proc -public dotlrn_assessment::remove_applet_from_community {
    community_id
} {
    remove the applet from the community
} {
    ad_return_complaint 1 "[applet_key] remove_applet_from_community not implemented!"
}

ad_proc -public dotlrn_assessment::add_user {
    user_id
} {
    one time user-specifuc init
} {
    # noop
}

ad_proc -public dotlrn_assessment::remove_user {
    user_id
} {
} {
    # noop
}

ad_proc -public dotlrn_assessment::add_user_to_community {
    community_id
    user_id
} {
    Add a user to a specifc dotlrn community
} {
    set package_id [dotlrn_community::get_applet_package_id -community_id $community_id -applet_key [applet_key]]
    set portal_id [dotlrn::get_portal_id -user_id $user_id]
    
    # use "append" here since we want to aggregate
    set args [ns_set create]
    ns_set put $args package_id $package_id
    ns_set put $args param_action append
    add_portlet_helper $portal_id $args
}

ad_proc -public dotlrn_assessment::remove_user_from_community {
    community_id
    user_id
} {
    Remove a user from a community
} {
    set package_id [dotlrn_community::get_applet_package_id -community_id $community_id -applet_key [applet_key]]
    set portal_id [dotlrn::get_portal_id -user_id $user_id]

    set args [ns_set create]
    ns_set put $args package_id $package_id

    remove_portlet $portal_id $args
}

ad_proc -public dotlrn_assessment::add_portlet {
    portal_id
} {
    A helper proc to add the underlying portlet to the given portal. 
    
    @param portal_id
} {
    # simple, no type specific stuff, just set some dummy values

    set args [ns_set create]
    ns_set put $args package_id 0
    ns_set put $args param_action overwrite
    add_portlet_helper $portal_id $args
}

ad_proc -public dotlrn_assessment::add_portlet_helper {
    portal_id
    args
} {
    A helper proc to add the underlying portlet to the given portal.

    @param portal_id
    @param args an ns_set
} {
    assessment_portlet::add_self_to_page \
        -portal_id $portal_id \
        -package_id [ns_set get $args package_id] \
        -param_action [ns_set get $args param_action]
}

ad_proc -public dotlrn_assessment::remove_portlet {
    portal_id
    args
} {
    A helper proc to remove the underlying portlet from the given portal. 
    
    @param portal_id
    @param args A list of key-value pairs (possibly user_id, community_id, and more)
} { 
    assessment_portlet::remove_self_from_page \
        -portal_id $portal_id \
        -package_id [ns_set get $args package_id]
}

ad_proc -public dotlrn_assessment::clone {
    old_community_id
    new_community_id
} {
    Clone this applet's content from the old community to the new one
} {
    ns_log notice "Cloning: [applet_key]"
    set new_package_id [add_applet_to_community $new_community_id]
    set old_package_id [dotlrn_community::get_applet_package_id \
                            -community_id $old_community_id \
                            -applet_key [applet_key]
                       ]

    set folder_id [as::assessment::folder_id -package_id $new_package_id]
    
    set assessments [db_list_of_lists get_assessments {}]
    
    foreach assessment $assessments {
	dotlrn_assessment::assessment_copy -assessment_id [lindex $assessment 0] -name [lindex $assessment 1] -folder_id $folder_id
    }
    return $new_package_id
}

ad_proc -public dotlrn_assessment::change_event_handler {
    community_id
    event
    old_value
    new_value
} { 
    listens for the following events: 
} { 
}   

ad_proc -public dotlrn_assessment::assessment_copy {
    {-assessment_id:required}
    {-name ""}
    {-folder_id}
} {
    @author Anny Flores (annyflores@viaro.net) Viaro Networks (www.viaro.net)
    @creation-date 2005-06-27

    Copies an assessment with all sections and items
} {
    as::assessment::data -assessment_id $assessment_id
    array set a [array get assessment_data]
    append a(title) "[_ assessment.copy_appendix]"
    
    
    set new_assessment_id [db_nextval acs_object_id_seq]
    if {$name eq ""} {
	set name "ASS_$new_assessment_id"
    }
    set new_assessment_id [content::item::new -item_id $new_assessment_id -parent_id $folder_id -content_type {as_assessments} -name $name]
    
    set new_rev_id [content::revision::new \
			-item_id $new_assessment_id \
			-content_type {as_assessments} \
			-title $a(title) \
			-description $a(description) \
			-attributes [list [list creator_id $a(creator_id)] \
					 [list instructions $a(instructions)] \
					 [list run_mode $a(run_mode)] \
					 [list anonymous_p $a(anonymous_p)] \
					 [list secure_access_p $a(secure_access_p)] \
					 [list reuse_responses_p $a(reuse_responses_p)] \
					 [list show_item_name_p $a(show_item_name_p)] \
					 [list random_p $a(random_p)] \
					 [list entry_page $a(entry_page)] \
					 [list exit_page $a(exit_page)] \
					 [list consent_page $a(consent_page)] \
					 [list return_url $a(return_url)] \
					 [list start_time $a(start_time)] \
					 [list end_time $a(end_time)] \
					 [list number_tries $a(number_tries)] \
					 [list wait_between_tries $a(wait_between_tries)] \
					 [list time_for_response $a(time_for_response)] \
					 [list ip_mask $a(ip_mask)] \
					 [list password $a(password)] \
					 [list show_feedback $a(show_feedback)] \
					 [list section_navigation $a(section_navigation)] ] ]
    
    as::assessment::copy_sections -assessment_id $a(assessment_rev_id) -new_assessment_id $new_rev_id
    as::assessment::copy_categories -from_id $a(assessment_rev_id) -to_id $new_rev_id
    
    
    return $new_assessment_id
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

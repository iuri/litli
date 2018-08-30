ad_library {
    Automated tests.

    @author Mounir Lallali.
    @creation-date 20 September 2005

}

namespace eval evaluation::twt {}

ad_proc evaluation::twt::create_file {file_name}  {
    
    # Create a temporal file
    set file_name "/tmp/$file_name"
    exec touch $file_name
    exec ls / >> $file_name
    exec chmod 777 $file_name
    return $file_name
}

ad_proc evaluation::twt::delete_file {file_name}  {

    # Delete a file name 
    file delete -force -- $file_name
}

ad_proc evaluation::twt::get_notification_ids { pretty_name } {
    
    # Get the notification ids : type_id, object_id and user_id
    set link [lindex [tclwebtest::link find ~u "(.+)request-new\?(.*)pretty(.+)name=$pretty_name\(.+)"] 7]

    set type_id [::tclwebtest::regsplit ".+type.+id=(.+)&.+object.+" $link]
    set object_id [::tclwebtest::regsplit ".+type.+id=.+object.+id=(.+)&.+" $link]
    set user_id [::tclwebtest::regsplit ".+user.+id=(.+)" $link]

    return [list $type_id $object_id $user_id]
}

ad_proc evaluation::twt::get_task_grade_id { task_name } {
    
    db_1row task_id "select task_id from evaluation_tasks where task_name=:task_name"
    db_1row grade_item_id "select grade_item_id from evaluation_tasks where task_name=:task_name"
    db_1row grade_id "select grade_id from evaluation_grades where grade_item_id=:grade_item_id"
    
    return [list $task_id $grade_id]
}

ad_proc evaluation::twt::get_evaluation_url {} {

    # The admin dotlrn page url
    set dotlrn_page_url [site_node::get_package_url -package_key dotlrn]
    set dotlrn_admin_page_url "[site_node::get_package_url -package_key dotlrn]admin"
    ::twt::do_request $dotlrn_admin_page_url

#    tclwebtest::link follow "Classes"
	
    # Create a new class             
    tclwebtest::link follow "Subjects"
    tclwebtest::link follow {New Class}
    
    set pretty_name [ad_generate_random_string] 
    tclwebtest::form find ~n "add_class_instance"
    tclwebtest::field find ~n pretty_name
    tclwebtest::field fill $pretty_name    
    tclwebtest::field find ~n description
    tclwebtest::field fill [ad_generate_random_string]
    tclwebtest::field find ~n add_instructor
    tclwebtest::field select -index 1
    tclwebtest::field find ~n class_instance_key
    tclwebtest::field fill [ad_generate_random_string]
    tclwebtest::form submit
    aa_log "Add Class Form submited"
    
    tclwebtest::link follow $pretty_name
	
    if { [catch {tclwebtest::assert text {Class Material} } errmsg] } {
	tclwebtest::link follow ~u ".*one-community-admin" 
	tclwebtest::link follow {Manage Applets}
	set add_evaluation_applet_url [export_vars -base "applet-add" {{applet_key "dotlrn_evaluation"}}]
	::twt::do_request $add_evaluation_applet_url
    } 

    tclwebtest::link follow {Class Material}
    set class_material_url [tclwebtest::response url]
	
    return $class_material_url 
}

ad_proc evaluation::twt::add_task { class_material_url task_name task_description file_name } {
    
    set response 0

    ::twt::do_request $class_material_url
    tclwebtest::link follow {Add Task}

    tclwebtest::form find ~n "task"
    tclwebtest::field find ~n "task_name"
    tclwebtest::field fill $task_name
    tclwebtest::field find ~n upload_file
    tclwebtest::field fill $file_name
    tclwebtest::field find ~n "description"
    tclwebtest::field fill $task_description
    tclwebtest::form submit
    aa_log "Add Task form submited"

    set response_url [tclwebtest::response url]

    if { [string match  $class_material_url  $response_url] } {
	
	if { [catch {tclwebtest::link find $task_name} errmsg] } {
                aa_error  "evaluation::twt::add_task failed $errmsg : Didn't add a New Task"
	} else {
	    aa_log "a New Task added"
	    set response 1
	}

    } else {
	aa_error "evaluation::twt::add_task failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::upload_task_solution { class_material_url task_name file_name} {

    set response 0

    ::twt::do_request $class_material_url
    
    # Get the task and the grade id 
    set list_ids [evaluation::twt::get_task_grade_id $task_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]
    
    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)solution-add-edit\?(.*)solution(.+)mode=edit(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"
    
    tclwebtest::form find ~n "solution"
    tclwebtest::field find ~n "upload_file"
    tclwebtest::field fill $file_name
    tclwebtest::form submit ~n "formbutton:ok"

    aa_log "Add Task form submited"

    set response_url [tclwebtest::response url]
    
    if {[string match $class_material_url $response_url] } {
        
	if { [catch {set true 1} errmsg] } {
	    aa_error "evaluation::twt::upload_task_solution failed $errmsg : Didn't upload a Task Solution"
        } else {
	    aa_log "a New Task Solution uploaded"
	    set response 1
        }
    
    } else {
	aa_error "evaluation::twt::upload_task_solution failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::view_task_solution { class_material_url task_name file_name } {

    set response 0

    ::twt::do_request $class_material_url

    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $task_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)solution-add-edit\?(.*)solution(.+)mode=display(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"
    
    set response_url [tclwebtest::response url]

    if { [string match  "*/classes/*/evaluation/admin/tasks/solution-add-edit*" $response_url] } {

	set list_words [split "$file_name" /]
	set short_file_name [lindex $list_words [llength $list_words]-1]
	
	if { [catch {tclwebtest::assert text "$short_file_name" } errmsg] } {
	    aa_error  "evaluation::twt::view_task_solution failed $errmsg : Didn't view a Task Solution"
        } else {
	    aa_log "a Task Solution viewed"
	    set response 1
        }

    } else {
	aa_error "evaluation::twt::view_task_solution failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::edit_task_solution { class_material_url task_name file_name } {

    set response 0

    ::twt::do_request $class_material_url

    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $task_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)solution-add-edit\?(.*)solution(.+)mode=display(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"

    tclwebtest::form find ~n "solution"
    tclwebtest::form submit
   
    tclwebtest::form find ~n "solution"
    tclwebtest::field find ~n "upload_file"
    tclwebtest::field fill $file_name
    tclwebtest::form submit ~n "formbutton:ok"
    aa_log "Edit Task form submited"
    
    set response_url [tclwebtest::response url]

    if { [string match  "$class_material_url"  $response_url] } {

	if { [string match  "*/classes/*/evaluation/admin/tasks/solution-add-edit*"  $response_url] } {
		aa_error "evaluation::twt::edit_task_solution failed $errmsg : Didn't edit a Task Solution"
        } else {
	    aa_log "a Task Solution edited"
	    set response 1
        }
	
    } else {
	aa_error "evaluation::twt::edit_task_solution failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::view_task { class_material_url task_name task_description file_name} {

    set response 0
    
    ::twt::do_request $class_material_url

    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $task_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)task-add-edit\?(.*)mode=display(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"
   
    set response_url [tclwebtest::response url]

    if {[string match  "*task-add-edit*$task_id*$grade_id" $response_url] } {

	set list_words [split "$file_name" /]
        set short_file_name [lindex $list_words [llength $list_words]-1]

        if { [catch {tclwebtest::assert text "$task_name" } errmsg] || [catch {tclwebtest::assert text "$task_description" } errmsg] || [catch {tclwebtest::assert text "$short_file_name" } errmsg] } {
	    
	    aa_error  "evaluation::twt::view_task failed $errmsg : Didn't view a Task"
        
	} else {
	    aa_log "a Task viewed"
	    set response 1
	}

    } else {
	aa_error "evaluation::twt::view_task failed, bad response url : $response_url"
    }
  
    return $response
}

ad_proc evaluation::twt::edit_task { class_material_url precedent_task_name task_name task_description file_name } {
    
    set response 0

    ::twt::do_request $class_material_url

    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $precedent_task_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)task-add-edit\?(.*)return(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"

    tclwebtest::form find ~n "task"
    tclwebtest::form submit

    tclwebtest::form find ~n "task"
    tclwebtest::field find ~n "task_name"
    tclwebtest::field fill $task_name
    tclwebtest::field find ~n upload_file
    tclwebtest::field fill $file_name
    tclwebtest::field find ~n "description"
    tclwebtest::field fill $task_description
    tclwebtest::form submit ~n "formbutton:ok"
    aa_log "Edit Task form submited"

    set response_url [tclwebtest::response url]
    
    if {[string match $class_material_url $response_url] } {

	set list_words [split "$file_name" /]
	set short_file_name [lindex $list_words [llength $list_words]-1]

	if {[catch {tclwebtest::assert text "$task_name" } errmsg]} {
	    aa_error  "evaluation::twt::edit_task failed $errmsg : Didn't edit a Task"
       
	} else {
	    aa_log "a Task edited"
	    set response 1
	}

    } else {
	aa_error "evaluation::twt::edit_task failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::delete_task { class_material_url task_name } {

    set response 0

    ::twt::do_request $class_material_url
    
    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $task_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)task-delete\?(.*)return(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"

    tclwebtest::form find ~a "task-delete-2"
    tclwebtest::form submit {Yes, I really want to remove this task}
    
    set response_url [tclwebtest::response url]

    if {[string match  "$class_material_url" $response_url] } {

	if {[catch {tclwebtest::assert text -fail "task_name" } errmsg] } {
	    aa_error  "evaluation::twt::delete_task failed $errmsg : Didn't delete  a Task"
	} else {
	    aa_log "a Task deleted"
	    set response 1
	}

    } else {
	aa_error "evaluation::twt::delete_task failed, bad response url : $response_url"
    }

    return $response
}


ad_proc evaluation::twt::add_project { class_material_url project_name project_description file_name } {

    set response 0

    ::twt::do_request $class_material_url
    tclwebtest::link follow {Add Project}
    tclwebtest::form find ~n "task"
    tclwebtest::field find ~n "task_name"
    tclwebtest::field fill $project_name
    tclwebtest::field find ~n upload_file
    tclwebtest::field fill $file_name
    tclwebtest::field find ~n "description"
    tclwebtest::field fill $project_description
    tclwebtest::form submit
    aa_log "Add Task form submited"
 
    set response_url [tclwebtest::response url]

    if { [string match  $class_material_url  $response_url] } {

	if { [catch {tclwebtest::link find $project_name} errmsg] } {
                aa_error  "evaluation::twt::add_project failed $errmsg : Didn't add a New Project"
	} else {
            aa_log "a New Project added"
            set response 1
	}

    } else {
        aa_error "evaluation::twt::add_project failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::upload_project_solution { class_material_url project_name file_name } {

    set response 0

    ::twt::do_request $class_material_url

    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $project_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)solution-add-edit\?(.*)solution(.+)mode=edit(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"

    tclwebtest::form find ~n "solution"
    tclwebtest::field find ~n "upload_file"
    tclwebtest::field fill $file_name
    tclwebtest::form submit ~n "formbutton:ok"

    aa_log "Add Task form submited"

    set response_url [tclwebtest::response url]

    if {[string match  $class_material_url  $response_url] } {

        if { [catch {set true 1} errmsg] } {
            aa_error  "evaluation::twt::upload_project_solution failed $errmsg : Didn't upload a Project Solution"
        } else {
            aa_log "a New Project Solution uploaded"
            set response 1
        }

    } else {
        aa_error "evaluation::twt::upload_project_solution failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::view_project_solution { class_material_url project_name file_name } {

    set response 0

    ::twt::do_request $class_material_url

    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $project_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)solution-add-edit\?(.*)solution(.+)mode=display(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"

    set response_url [tclwebtest::response url]

    if { [string match  "*/classes/*/evaluation/admin/tasks/solution-add-edit*"  $response_url] } {

        set list_words [split "$file_name" /]
        set short_file_name [lindex $list_words [llength $list_words]-1]
	aa_log $short_file_name
        if { [catch {tclwebtest::assert text "$short_file_name" } errmsg] } {
            aa_error  "evaluation::twt::view_project_solution failed $errmsg : Didn't view a Project Solution"
        } else {
            aa_log "a Project Solution viewed"
            set response 1
        }

    } else {
        aa_error "evaluation::twt::view_project_solution failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::edit_project_solution { class_material_url project_name file_name } {

    set response 0

    ::twt::do_request $class_material_url

    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $project_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)solution-add-edit\?(.*)mode=display(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"

    tclwebtest::form find ~n "solution"
    tclwebtest::form submit

    tclwebtest::form find ~n "solution"
    tclwebtest::field find ~n "upload_file"
    tclwebtest::field fill $file_name
    tclwebtest::form submit ~n "formbutton:ok"
    aa_log "Edit Task form submited"

    set response_url [tclwebtest::response url]

    if { [string match  "$class_material_url"  $response_url] } {

        if { [string match  "*/classes/*/evaluation/admin/tasks/solution-add-edit*"  $response_url] } {
                aa_error "evaluation::twt::edit_project_solution failed $errmsg : Didn't edit a Project Solution"
        } else {
            aa_log "a Project Solution edited"
            set response 1
        }

    } else {
        aa_error "evaluation::twt::edit_project_solution failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::view_project { class_material_url project_name project_description file_name} {

    set response 0

    ::twt::do_request $class_material_url

    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $project_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)task-add-edit\?(.*)mode=display(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"

    set response_url [tclwebtest::response url]

    if {[string match  "*/dotlrn/classes*/evaluation/admin/tasks/task-add-edit*" $response_url] } {

        set list_words [split "$file_name" /]
        set short_file_name [lindex $list_words [llength $list_words]-1]

        if { [catch {tclwebtest::assert text "$project_name" } errmsg] || [catch {tclwebtest::assert text "$project_description" } errmsg] || [catch {tclwebtest::assert text "$short_file_name" } errmsg] } {

            aa_error  "evaluation::twt::view_project failed $errmsg : Didn't view a Project"

        } else {
            aa_log "a Project viewed"
            set response 1
        }

    } else {
        aa_error "evaluation::twt::view_project failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::edit_project { class_material_url precedent_project_name project_name project_description file_name } {

    set response 0

    ::twt::do_request $class_material_url

    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $precedent_project_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)task-add-edit\?(.*)return(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"

    tclwebtest::form find ~n "task"
    tclwebtest::form submit

    tclwebtest::form find ~n "task"
    tclwebtest::field find ~n "task_name"
    tclwebtest::field fill $project_name
    tclwebtest::field find ~n upload_file
    tclwebtest::field fill $file_name
    tclwebtest::field find ~n "description"
    tclwebtest::field fill $project_description
    tclwebtest::form submit

    aa_log "Edit Task form submited"

    set response_url [tclwebtest::response url]

    if {[string match  "$class_material_url" $response_url] } {

        set list_words [split "$file_name" /]
        set short_file_name [lindex $list_words [llength $list_words]-1]

        if {[catch {tclwebtest::assert text "$project_name" } errmsg]} {
            aa_error  "evaluation::twt::edit_project failed $errmsg : Didn't edit a Project"

        } else {
            aa_log "a Project edited"
            set response 1
        }

    } else {
        aa_error "evaluation::twt::edit_project failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::delete_project { class_material_url project_name } {

    set response 0

    ::twt::do_request $class_material_url

    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $project_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)task-delete\?(.*)return(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"

    tclwebtest::form find ~a "task-delete-2"
    tclwebtest::form submit {Yes, I really want to remove this task}

    set response_url [tclwebtest::response url]

    if {[string match  "$class_material_url" $response_url] } {

        if {[catch {tclwebtest::assert text -fail "project_name" } errmsg] } {
            aa_error  "evaluation::twt::delete_project failed $errmsg : Didn't delete a Project"
        } else {
            aa_log "a Project deleted"
            set response 1
        }

    } else {
        aa_error "evaluation::twt::delete_project failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::add_exam { class_material_url exam_name exam_description file_name } {

    set response 0

    ::twt::do_request $class_material_url
    tclwebtest::link follow {Add Exam}
    tclwebtest::form find ~n "task"
    tclwebtest::field find ~n "task_name"
    tclwebtest::field fill $exam_name
    tclwebtest::field find ~n upload_file
    tclwebtest::field fill $file_name
    tclwebtest::field find ~n "description"
    tclwebtest::field fill $exam_description
    tclwebtest::form submit
    aa_log "Add Exam form submited"

    set response_url [tclwebtest::response url]

    if { [string match  $class_material_url  $response_url] } {

        if { [catch {tclwebtest::link find $exam_name} errmsg] } {
                aa_error  "evaluation::twt::add_exam failed $errmsg : Didn't add a New Exam"

        } else {
            aa_log "a New Exam added"
            set response 1
        }

    } else {
        aa_error "evaluation::twt::add_exam failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::upload_exam_solution { class_material_url exam_name file_name} {

    set response 0

    ::twt::do_request $class_material_url

    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $exam_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)solution-add-edit\?(.*)solution(.+)mode=edit(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"

    tclwebtest::form find ~n "solution"
    tclwebtest::field find ~n "upload_file"
    tclwebtest::field fill $file_name
    tclwebtest::form submit ~n "formbutton:ok"

    aa_log "Add Task form submited"

    set response_url [tclwebtest::response url]

    if {[string match  $class_material_url  $response_url] } {

        if { [catch {set true 1} errmsg] } {
            aa_error  "evaluation::twt::upload_task_solution failed $errmsg : Didn't upload a Task Solution"
        } else {
            aa_log "a New Task Solution uploaded"
            set response 1
        }

    } else {
        aa_error "evaluation::twt::upload_task_solution failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::view_exam_solution { class_material_url exam_name file_name } {

    set response 0

    ::twt::do_request $class_material_url

    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $exam_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)solution-add-edit\?(.*)solution(.+)mode=display(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"

    set response_url [tclwebtest::response url]

    if { [string match  "*/classes/*/evaluation/admin/tasks/solution-add-edit*"  $response_url] } {

        set list_words [split "$file_name" /]
        set short_file_name [lindex $list_words [llength $list_words]-1]

        if { [catch {tclwebtest::assert text "$short_file_name" } errmsg] } {
            aa_error  "evaluation::twt::view_exam_solution failed $errmsg : Didn't view an Exam Solution"
        } else {
            aa_log "an Exam Solution viewed"
            set response 1
        }

    } else {
        aa_error "evaluation::twt::view_exam_solution failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::edit_exam_solution { class_material_url exam_name file_name } {

    set response 0

    ::twt::do_request $class_material_url

    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $exam_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)solution-add-edit\?(.*)solution(.+)mode=display(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"
    
    tclwebtest::form find ~n "solution"
    tclwebtest::form submit

    tclwebtest::form find ~n "solution"
    tclwebtest::field find ~n "upload_file"
    tclwebtest::field fill $file_name
    tclwebtest::form submit ~n "formbutton:ok"
    aa_log "Edit Task form submited"

    set response_url [tclwebtest::response url]

    if { [string match  "$class_material_url"  $response_url] } {

        if { [string match  "*/classes/*/evaluation/admin/tasks/solution-add-edit*"  $response_url] } {
                aa_error "evaluation::twt::edit_exam_solution failed $errmsg : Didn't edit an Exam Solution"
        } else {
            aa_log "an Exam Solution edited"
            set response 1
        }

    } else {
        aa_error "evaluation::twt::edit_exam_solution failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::view_exam { class_material_url exam_name exam_description file_name} {

    set response 0

    ::twt::do_request $class_material_url

    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $exam_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)task-add-edit\?(.*)mode=display(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"

    set response_url [tclwebtest::response url]

    if {[string match  "*/dotlrn/classes*/evaluation/admin/tasks/task-add-edit*" $response_url] } {

        set list_words [split "$file_name" /]
        set short_file_name [lindex $list_words [llength $list_words]-1]

        if { [catch {tclwebtest::assert text "$exam_name" } errmsg] || [catch {tclwebtest::assert text "$exam_description" } errmsg] || [catch {tclwebtest::assert text "$short_file_name" } errmsg] } {

            aa_error  "evaluation::twt::view_exam failed $errmsg : Didn't view an Exam"

        } else {
            aa_log "an Exam viewed"
            set response 1
        }

    } else {
        aa_error "evaluation::twt::view_exam failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::edit_exam { class_material_url precedent_exam_name exam_name exam_description file_name } {

    set response 0

    ::twt::do_request $class_material_url
    
    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $precedent_exam_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)task-add-edit\?(.*)return(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"

    tclwebtest::form find ~n "task"
    tclwebtest::form submit

    tclwebtest::form find ~n "task"
    tclwebtest::field find ~n "task_name"
    tclwebtest::field fill $exam_name
    tclwebtest::field find ~n upload_file
    tclwebtest::field fill $file_name
    tclwebtest::field find ~n "description"
    tclwebtest::field fill $exam_description
    tclwebtest::form submit

    aa_log "Edit Task form submited"

    set response_url [tclwebtest::response url]

    if {[string match  "$class_material_url" $response_url] } {

        set list_words [split "$file_name" /]
        set short_file_name [lindex $list_words [llength $list_words]-1]

        if {[catch {tclwebtest::assert text "$exam_name" } errmsg]} {
            aa_error  "evaluation::twt::edit_exam failed $errmsg : Didn't edit an Exam"

        } else {
            aa_log "a Project edited"
            set response 1
        }

    } else {
        aa_error "evaluation::twt::edit_exam failed, bad response url : $response_url"
    }

    return $response
}


ad_proc evaluation::twt::delete_exam { class_material_url exam_name } {

    set response 0

    ::twt::do_request $class_material_url
    
    # Get the task and the grade id
    set list_ids [evaluation::twt::get_task_grade_id $exam_name]
    set task_id [lindex $list_ids 0]
    set grade_id [lindex $list_ids 1]

    # Follow Upload Solution link
    tclwebtest::link follow ~u "(.+)task-delete\?(.*)return(.+)task(.+)id=$task_id\(.+)grade(.+)id=$grade_id"

    tclwebtest::form find ~a "task-delete-2"
    tclwebtest::form submit {Yes, I really want to remove this task}

    set response_url [tclwebtest::response url]

    if {[string match  "$class_material_url" $response_url] } {

        if {[catch {tclwebtest::assert text -fail "$exam_name" } errmsg] } {
            aa_error  "evaluation::twt::delete_exam failed $errmsg : Didn't delete an Exam"
        } else {
            aa_log "an Exam deleted"
            set response 1
        }

    } else {
        aa_error "evaluation::twt::delete_exam failed, bad response url : $response_url"
    }

    return $response
}


ad_proc evaluation::twt::request_notification_Evaluation { class_material_url } {
    
    set response 0
    
    ::twt::do_request $class_material_url
    
    # Get the notification ids : type_id, object_id and user_id
    set list_ids [evaluation::twt::get_notification_ids "Evaluations"]
    
    # Follow Request Evaluation Notification link
    tclwebtest::link follow ~u  {(.+)pretty(.+)Evaluations(.+)}
    tclwebtest::form find ~n "subscribe"
    tclwebtest::form submit

    set response_url [tclwebtest::response url]

    if { [string match  $class_material_url  $response_url] } {

        if {! [catch {tclwebtest::link find  ~u  {(.+)pretty(.+)Evaluations(.+)} } errmsg] } {
	    aa_error  "evaluation::twt::request_notification_Evaluation failed $errmsg : Didn't request notification evaluation"
        } else {
            aa_log "Request Notification Evaluation "
            set response 1
        }

    } else {
        aa_error "evaluation::twt:::request_notification_Evaluation failed, bad response url : $response_url"
    }

    return [lappend list_ids $response]
}

ad_proc evaluation::twt::request_notification_GradeBook { class_material_url } {
    set response 0

    ::twt::do_request $class_material_url
    
    # Get the notification ids : type_id, object_id and user_id
    set list_ids [evaluation::twt::get_notification_ids "Gradebook"]

    # Follow Request GradeBook Notification link
    tclwebtest::link follow ~u  {(.+)pretty(.+)Gradebook(.+)}
    tclwebtest::form find ~n "subscribe"
    tclwebtest::form submit

    set response_url [tclwebtest::response url]

    if { [string match  $class_material_url  $response_url] } {

        if {! [catch {tclwebtest::link find  ~u  {(.+)pretty(.+)Gradebook(.+)} } errmsg] } {
            aa_error  "evaluation::twt::request_notification_GradeBook failed $errmsg : Didn't request notification Gradebook"
        } else {
            aa_log "Request Notification GradeBook"
            set response 1
        }

    } else {
        aa_error "evaluation::twt:::request_notification_GradeBook failed, bad response url : $response_url"
    }

    return [lappend list_ids $response]

}

ad_proc evaluation::twt::unsubscribe_GradeBook { class_material_url type_id object_id user_id} {

    set response 0

    ::twt::do_request $class_material_url

    # Get the request id
    set request_id [notification::request::get_request_id -type_id $type_id -object_id $object_id -user_id $user_id]

    # Follow Unsubscribe GradeBook link
    tclwebtest::link follow ~u "(.+)request-delete?(.*)request(.+)id=$request_id"

    set response_url [tclwebtest::response url]

    if { [string match  $class_material_url  $response_url] } {

        if {! [catch {tclwebtest::link find  ~u "(.+)request-delete?(.*)request(.+)id=$request_id" } errmsg] } {
            aa_error  "evaluation::twt::unsubscribe_GradeBook failed $errmsg : Didn't unsubscribe notification Gradebook"
        } else {
            aa_log "Unsubscribe Notification GradeBook"
            set response 1
        }

    } else {
        aa_error "evaluation::twt::::unsubscribe_GradeBook failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::unsubscribe_Evaluation { class_material_url type_id object_id user_id } {

    set response 0

    ::twt::do_request $class_material_url

    # Get the request id
    set request_id [notification::request::get_request_id -type_id $type_id -object_id $object_id -user_id $user_id]

    # Follow Unsubscribe Evaluation link
    tclwebtest::link follow ~u "(.+)request-delete?(.*)request(.+)id=$request_id"

    set response_url [tclwebtest::response url]

    if { [string match  $class_material_url  $response_url] } {

        if {! [catch {tclwebtest::link find  ~u "(.+)request-delete?(.*)request(.+)id=$request_id" } errmsg] } {
            aa_error  "evaluation::twt::unsubscribe_Evaluation Failed $errmsg : Didn't unsubscribe notification"
        } else {
            aa_log "Unsubscribe Notification Evaluation"
            set response 1
        }
    } else {
        aa_error "evaluation::twt::::unsubscribe_Evaluation failed, bad response url : $response_url"
    }

    return $response
}

ad_proc evaluation::twt::add_assignement_type { class_material_url assigment_type_name} {

    set response 0

    ::twt::do_request $class_material_url
  
    #Follow Control Panel link
    tclwebtest::link follow ~u {/dotlrn/classes(.+)/one-community-admin}
   
    tclwebtest::link follow {Administer Evaluation}
    tclwebtest::link follow {Admin my Assignment Types}
    set modify_assignment_type_url [tclwebtest::response url]

    tclwebtest::link follow {Add assignment type}
    
    tclwebtest::form find ~n "grade"
    tclwebtest::field find ~n grade_name 
    tclwebtest::field fill $assigment_type_name
    tclwebtest::field find ~n grade_plural_name
    tclwebtest::field fill "$assigment_type_name"
    tclwebtest::field find ~n weight
    tclwebtest::field fill 30 
    tclwebtest::form submit
   
    set response_url [tclwebtest::response url]

    if { [string match  $modify_assignment_type_url  $response_url] } {

	if {[catch {tclwebtest::assert text "$assigment_type_name" } errmsg]} {
        
	    aa_error  "evaluation::twt::add_assignement_type failed $errmsg : Didn't add a new assignement type"
        } else {
            aa_log "Add a new Assignement Type"
            set response 1
        }

    } else {
        aa_error "evaluation::twt::::add_assignement_type failed, bad response url : $response_url"
    }

    return $response

}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

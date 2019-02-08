# /packages/evaluation/www/admin/tasks/task-add-edit.tcl

ad_page_contract {
    Page for editing and adding tasks.

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id: task-add-edit.tcl,v 1.34.2.3 2016/11/08 12:55:07 gustafn Exp $
} {
    grade_id:naturalnum,notnull
    task_id:naturalnum,notnull,optional
    item_id:naturalnum,notnull,optional
    upload_file:trim,optional
    upload_file.tmpfile:tmpfile,optional
    {mode "edit"}
    return_url:localurl
    admin_groups_p:boolean,optional
    {add_to_more_classes_p:boolean ""}
    {attached_p:boolean "f"}
    {enable 1}
    {return_p:boolean ""}
    {simple_p:boolean ""}

}

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]

set community_id [dotlrn_community::get_community_id]

# Amended by Iuri Sampaio in 2019-02-08
# Tweak evaluation package to find commmunity the community from url
## BEGIN
if {$community_id eq ""} {
    set url [lindex [split [ad_conn url] "\/"] 1]
    
    set community_id [db_string select_community_id {
        SELECT community_id FROM dotlrn_communities_all WHERE community_key = :url
    } -default ""]
}
## END 



set new_p [ad_form_new_p -key task_id] 
set simple_p [parameter::get -parameter SimpleVersion ]


set more_communities_option 0
if { $new_p && $community_id ne "" && [db_string get_user_comunities { *SQL* }] } {
    set more_communities_option 1
}


db_1row get_grade_info { *SQL* }
if { $new_p } {
    set page_title "[_ evaluation.Add_grade_name_]"
    # set storage_type to its default value according to a db constraint
    set storage_type "lob"
} else {
    set page_title "[_ evaluation.Edit_grade_name_]"
}

if { [info exists admin_groups_p] } {
    set div_visibility visible
    set checked_p checked
} else {
    set div_visibility hidden
    set checked_p ""
}

set context [list $page_title]

ad_form -html { enctype multipart/form-data } -name task -cancel_url $return_url -export { return_url item_id storage_type grade_id } -mode $mode -form {

    task_id:key

    {task_name:text  
	{label "[_ evaluation.Task_Name_]"}
	{html {size 30}}
    }
    
}

if { !$new_p } {

    db_foreach select_grade_types { *SQL* } {
        set grade_name [lang::util::localize $grade_name]
        lappend grade_type_options [list $grade_name $grade_item_id]
    }
    ad_form -extend -name task -form {
	{grade_item_id:text
	    {label "[_ evaluation.Assignment_Type]"}
	    {widget select}
	    {options "$grade_type_options"}
	    {value $grade_id}
	}
    }

    db_1row get_task_info { *SQL* }
    
    if { $title ne "link" && $content_length > 0 } {
	if {$mode eq "edit"} {
	    set attached_p "t"
	    ad_form -extend -name task -form {			
		{upload_file:file,optional
		    {label "[_ evaluation.File_]"} 
		    {html "size 30"}
		    {help_text "[_ evaluation.lt_Currently_title_is_at_2]"}
		}
		{unattach_p:text(checkbox),optional 
		    {label "[_ evaluation.Unattach_file_]"} 
		    {options {{"" "t"}}}
		    {help_text "[_ evaluation.lt_Check_this_if_you_wan]"}
		}
		{url:text(text),optional
		    {label "[_ evaluation.URL__1]"} 
		    {value "http://"}
		}			
	    }
	} else {
	    ad_form -extend -name task -form {			
		{upload_file:text,optional
		    {label "[_ evaluation.File_]"} 
		    {html "size 30"}
		    {value "$title"}
		}
		{unattach_p:text(hidden)
		}
		{url:text(hidden)
		}			
	    }
	}
    } elseif {$title eq "link"} {

	if {$mode eq "edit"} {

	    set attached_p "t"
	    
	    ad_form -extend -name task -form {			
		
		{upload_file:file,optional
		    {label "[_ evaluation.File_]"} 
		    {html "size 30"}
		}
		{url:text(text),optional
		    {label "[_ evaluation.URL__1]"} 
		    {value "http://"}
		    {help_text "[_ evaluation.lt_Currently_content_is__1]"}
		}			
		{unattach_p:text(checkbox),optional 
		    {label "[_ evaluation.Unassociate_url_]"}
		    {options {{"" "t"}}} 
		    {help_text "[_ evaluation.lt_Check_this_if_you_wan]"}
		}
	    }
	} else {
	    ad_form -extend -name task -form {			
		
		{upload_file:text(hidden)
		}
		{url:text(text),optional
		    {label "[_ evaluation.URL__1]"} 
		    {value "$content"}
		}			
		{unattach_p:text(hidden)
		}
	    }
	}
    } else {
	ad_form -extend -name task -form {
	    
	    {upload_file:file,optional
		{label "[_ evaluation.File_]"} 
		{html "size 30"}
		{help_text "[_ evaluation.lt_You_can_upload_a_file]"}
	    }
	    
	    {url:text(text),optional
		{label "[_ evaluation.URL__1]"} 
		{value "http://"}
		{help_text "You can associate a link to this task by entering the absolute url here (also optional)"}
	    }
	    
	    {unattach_p:text(hidden),optional
		{value ""}
	    }
	}
	
    }
} else {
    
    ad_form -extend -name task -form {
	
	{upload_file:file,optional
	    {label "[_ evaluation.File_]"} 
	    {html "size 30"}
	    {help_text "[_ evaluation.lt_You_can_upload_a_file_1]"}
	}
    }

    ad_form -extend -name task -form {
	
	{url:text(text),optional
	    {label "[_ evaluation.URL__1]"} 
	    {value "http://"}
	    {help_text "[_ evaluation.lt_You_can_associate_a_l]"}
	}
	
	{unattach_p:text(hidden),optional
	    {value ""}
	}
    }
}

ad_form -extend -name task -form {

    {description:richtext,optional  
	{label "[_ evaluation.lt_Assignments_Descripti]"}
	{html {rows 4 cols 40}}
    }

    {due_date:date,to_sql(linear_date),from_sql(sql_date),optional
	{label "[_ evaluation.Due_Date_]"}
	{format "MONTH DD YYYY HH24 MI SS"}
	{value "[evaluation::now_plus_days -ndays 20]"}
	{help}
    }
    {relative_weight:float(hidden)
	{value 0}
    }
}

if { $simple_p } {
    ad_form -extend -name task -form {    
	{number_of_members:naturalnum(hidden)
	    {value "1"}
	}
	{weight:float(hidden)
	    {value "0"}
	}
	{net_value:float(hidden)
	    {value "0"}
	}

	
    }
    
} else {
    ad_form -extend -name task -form {
        {number_of_members:naturalnum
	    {label "[_ evaluation.Number_of_Members_]"}
	    {value "1"}
	    {html {size 5 id number_of_members}}
	    {help_text "[_ evaluation.1__Individual_]"}
	    {after_html {<div id="silentDiv" style="visibility:$div_visibility;"><div class="form-help-text"><input type="checkbox" name="admin_groups_p" $checked_p> [_ evaluation.lt_Check_this_if_you_wan_1] </div></div>}}
	}
	
	{weight:float,optional
	    {label "[_ evaluation.lt_Weight_over_grade_wei_2]"}
	    {html {size 5}} 
	    {help_text "[_ evaluation.lt_You_can_enter_the_wei]"}
	    {value "0"}
	}
	
	{net_value:float,optional
	    {label "[_ evaluation.Net_Value_]"}
	    {html {size 5}}
	    {help_text "[_ evaluation.lt_If_you_enter_the_net_]"}
	    {value "0"}
	}
    }
}
ad_form -extend -name task -form {    
    {perfect_score:float(text)
	{label "[_ evaluation.perfect_score]"}
	{html {size 5}} 
	{help_text "[_ evaluation.perfect_score_help]"}
	{value 100}
    }
    {answer_choice:text(radio)     
	{label "[_ evaluation.answer_choice_]"} 
	{options {{"[_ evaluation.submitted_online_]" ol}  {"[_ evaluation.forum_r_]" fr} {"[_ evaluation.not_submited_]" ns}}}
	{value "ol"}
    }
}
if { $simple_p } {
    ad_form -extend -name task -form {    
	{late_submit_p:text(hidden)     
	    {value t}
	}
    }
} else {
    ad_form -extend -name task -form {    
	{late_submit_p:text(radio)     
	    {label "[_ evaluation.lt_Can_the_student_submi]"} 
	    {options {{"[_ evaluation.Yes_]" t} {"[_ evaluation.No_]" f}}}
	    {value t}
	}
    }
}

ad_form -extend -name task -form {
    {requires_grade_p:text(radio)     
	{label "[_ evaluation.lt_Will_this_task_requir]"} 
	{options {{"[_ evaluation.Yes_]" t} {"[_ evaluation.No_]" f}}}
	{value t}
    }
}
if { $simple_p } {
    ad_form -extend -name task -form {
	{estimated_time:float(hidden)
	    {value "0"}
	}
    }
    
} else { 
    ad_form -extend -name task -form {
	{estimated_time:float,optional     
	    {label "[_ evaluation.lt_Time_estimated_to_com]"}
	    {html {size 5}} 
	    {value "0"}
	}
    }
}

if { $more_communities_option } {
    ad_form -extend -name task -form {
	{add_to_more_classes_p:text(checkbox),optional 
	    {label "[_ evaluation.lt_Add_this_assignment_t]"} 
	    {options {{"" "t"}}}
	    {help_text "[_ evaluation.lt_Check_this_if_you_wan_2]"}
	}
    }
} 

ad_form -extend -name task -form {
    
} -edit_request {
    
    db_1row task_info { *SQL* }
    if {$online_p == "t"} {
	set answer_choice "ol"
    } else {
	set answer_choice "ns"
    }
    if {$forums_related_p == "t"} {
	set answer_choice "fr"
    }
    
    set due_date [template::util::date::from_ansi $due_date_ansi "YYYY-MM-DD HH24:MI:SS"]
    set weight [format %0.2f $weight]
    set perfect_score $perfect_score
    
    
} -validate {
    {url
	{ ($url eq "http://" && $upload_file ne "") || ($url ne "http://" && $upload_file eq "") || ($url eq "http://" && $upload_file eq "") || ($url ne "http://" && [util_url_valid_p $url]) }
	{[_ evaluation.lt_Upload_a_file_OR_a_ur_1] }
    }
    {upload_file
	{ ($url eq "http://" && $upload_file ne "") || ($url ne "http://" && $upload_file eq "") || ($url eq "http://" && $upload_file eq "") }
	{ [_ evaluation.lt_Upload_a_file_OR_a_ur_1] }
    }
    {unattach_p 
	{ ($unattach_p == "t" && $upload_file eq "" && $url eq "http://") || $unattach_p eq "" }
	{ [_ evaluation.lt_First_unattach_the_fi] }
    }
    {net_value 
	{ !$net_value || ($net_value eq "" && $requires_grade_p == "f") || (($net_value > 0) && ($net_value <= $grade_weight) && (!$weight || $weight eq "")) }
	{ [_ evaluation.lt_The_net_value_must_be] }
    }
    {weight
	{ !$weight || ($weight eq "" && $requires_grade_p == "f") || (($weight > 0) && (!$net_value || $net_value eq "")) }
	{ [_ evaluation.lt_The_weight_must_be_gr] }
    }
    {number_of_members
	{ $number_of_members >= 1 }
	{ [_ evaluation.lt_The_number_of_members]}
    }
    {estimated_time
	{ $estimated_time >= 0 }
	{ [_ evaluation.lt_The_estimated_time_mu] }
    }
} -new_data {
    
    evaluation::notification::do_notification -task_id $revision_id -package_id [ad_conn package_id] -edit_p 0 -notif_type one_assignment_notif
    
} -edit_data {
    
    evaluation::notification::do_notification -task_id $revision_id -package_id [ad_conn package_id] -edit_p 1 -notif_type one_assignment_notif
    
} -on_submit {
    
    if {$requires_grade_p == "t"} {
	if { [info exists net_value] && ($net_value > 0) } {
	    set weight [expr {$net_value*100.000/$grade_weight}]
	}
    } else {
	set weight 0
	set points 0
    }
    set points [format %0.2f [expr ($weight*$grade_weight)/100.00]]
    set forums_related_p "f"
    set online_p "f"
    
    if {$answer_choice eq "ol"} {
	set online_p "t"
    }
    
    if {$answer_choice eq "fr"} {
	set forums_related_p "t"
    } 
    
    
    db_transaction {
		
	if { $upload_file ne "" } {
	    
	    # Get the filename part of the upload file
	    if { ![regexp {[^//\\]+$} $upload_file filename] } {
		# no match
		set filename $upload_file
	    }
	    
	    set title [template::util::file::get_property filename $upload_file]
	    set mime_type [cr_filename_to_mime_type -create $title]
	    
	    if { ![parameter::get -parameter "StoreFilesInDatabaseP" -package_id [ad_conn package_id]] } {
		set storage_type file
	    }
	} elseif { $url ne "http://" } {
	    set mime_type "text/plain"
	    set title "link"
	} elseif {$attached_p == "f"} {
	    set mime_type "text/plain"
	    set title ""
	}
	set due_date_p 1
	
	set title [evaluation::safe_url_name -name $title]
	set cal_due_date [calendar::to_sql_datetime -date $due_date -time $due_date -time_p 1]
	set due_date_ansi [db_string set_date " *SQL* "]
	
	if {$cal_due_date eq "-- :"} {
	    set due_date_p 0
	    set due_date ""
	}
	
	
	if { [ad_form_new_p -key task_id] } {
	    set item_id $task_id
	} 
	
	set revision_id [evaluation::new_task -new_item_p [ad_form_new_p -key grade_id] -item_id $item_id \
			     -content_type evaluation_tasks \
			     -content_table evaluation_tasks \
			     -content_id task_id \
			     -name $task_name \
			     -description $description \
			     -weight $weight \
			     -grade_item_id $grade_item_id \
			     -number_of_members $number_of_members \
			     -online_p $online_p \
			     -storage_type $storage_type \
			     -due_date  $due_date_ansi \
			     -late_submit_p $late_submit_p \
			     -requires_grade_p $requires_grade_p \
			     -title $title \
			     -mime_type $mime_type \
			     -estimated_time $estimated_time]
	
	content::item::set_live_revision -revision_id $revision_id
	
	# by the moment, since I'm having a date problem with oracle10g, I have to do this in order 
	# to store the entire date

	db_dml update_date { *SQL* }

	# initialize content_length in order to prevent wrong values
	set content_length 0
	db_dml lob_size { *SQL* }


	if { $upload_file ne "" }  {
	    set tmp_file [template::util::file::get_property tmp_filename $upload_file]
	    set content_length [file size $tmp_file]
	    
	    if { [parameter::get -parameter "StoreFilesInDatabaseP" -package_id [ad_conn package_id]] } {
		# create the new item
		db_dml lob_content { *SQL* } -blob_files [list $tmp_file]
		
		# Unfortunately, we can only calculate the file size after the lob is uploaded 
		db_dml lob_size { *SQL* }
	    } else {
		# create the new item
		set file_name [cr_create_content_file $item_id $revision_id $tmp_file]
                db_dml set_file_content { *SQL* }
		
	    }
	    
	} elseif { $url ne "http://" } {
	    
	    db_dml link_content { *SQL* }
	    # in order to support oracle and postgres and still using only the cr_items table to store the task
	    db_dml set_storage_type { *SQL* }
	    set content_length [string length $url]
	    db_dml content_size { *SQL* }

	} elseif { $attached_p == "t" && $unattach_p != "t" } {
	    
	    # just copy the old content to the new revision
	    db_exec_plsql copy_content { *SQL* }
	}	
	
	# integration with calendar
	# since there is no service contract defined
	
	set desc_url "<a href=\"$return_url\">[_ evaluation.lt_Click_here_to_go_to_t]</a>"

        ns_log Notice "COMMUNITYID $community_id"
	set url [dotlrn_community::get_community_url $community_id]
	
        ns_log Notice "URL $url"

	array set community_info [site_node::get -url "${url}calendar"]
        ns_log Notice "[parray community_info]"
        
	set community_package_id $community_info(package_id)

        ns_log Notice "COMMUNITY PKGID $community_package_id"
        
	set calendar_id [db_string get_cal_id { *SQL* }]
	
	if { ![db_0or1row calendar_mappings { *SQL* }] } {
	    # create cal_item
	    if { $due_date_p } {
		set cal_item_id [calendar::item::new -start_date $cal_due_date -end_date $cal_due_date -name "[_ evaluation.Due_date_task_name]" -description $desc_url -calendar_id $calendar_id]
		
		db_dml insert_cal_mapping { *SQL* }
	    }
	} else {
	    # edit previous cal_item
	    if { $due_date_p } {
		calendar::item::edit -cal_item_id $cal_item_id -start_date $due_date_ansi -end_date $due_date_ansi -name "[_ evaluation.Due_date_task_name]" -description $desc_url -calendar_id $calendar_id
	    }
	}
	db_transaction {
	    
	    set relative_weight [format %0.2f [expr (($tasks_counter)*$weight)/100.00]]
	    set update_p [db_dml update_points { *SQL* }]
	    
	    if {!$simple_p } {
		
		if { $new_p } {
		    db_foreach get_grade_tasks {} {
			set relative_weight [format %0.2f [expr (($tasks_counter)*$weight)/100.00]]
			db_dml update_tasks {*SQL*}
		    }
		}
		
	    }
	    
	}
	
	
    }
} -after_submit {
    
    set redirect_to_groups_p 0
    if { [info exists admin_groups_p] && $number_of_members > 1 } {
	set redirect_to_groups_p 1
    }
    if { $add_to_more_classes_p ne "" } {
	ad_returnredirect [export_vars -base "task-add-to-communities" { redirect_to_groups_p {task_id $revision_id} return_url }]
    } elseif { $redirect_to_groups_p } {
	ad_returnredirect [export_vars -base "../groups/one-task" { {task_id $revision_id} }]
	ad_script_abort
    } else {
	if { $simple_p } {
	    set return_url "../grades/distribution-edit?task_id=$revision_id&grade_id=$grade_id"
	    ad_returnredirect $return_url
	    ad_script_abort
	} else {
	    ad_returnredirect $return_url
	}
	
    }

} -on_request {
    template::add_event_listener -id "number_of_members" -event change -script {TaskInGroups();}    
} 

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

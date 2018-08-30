# /packages/evaluation/www/answer-add-edit.tcl

ad_page_contract {
    Page for editing and adding answers.

    @author jopez@galileo.edu
    @creation-date Mar 2004
    @cvs-id $Id: answer-add-edit.tcl,v 1.3.2.2 2016/05/20 20:30:12 gustafn Exp $
} {
    task_id:naturalnum,notnull
    grade_id:naturalnum,notnull
    answer_id:naturalnum,notnull,optional
    item_id:naturalnum,notnull,optional
    upload_file:trim,optional
    upload_file.tmpfile:tmpfile,optional
    return_url:localurl,notnull
    {comment ""}
} -validate {
    late_submit -requires { task_id:integer } {
	if { [string equal [db_string late_turn_in { *SQL* }] "f"] && [db_string compare_dates { *SQL* } -default 0] } {
	    ad_complain "[_ evaluation.lt_This_task_can_not_be_]"
	}
    }
}

db_1row task_info { *SQL* }

set user_id [ad_conn user_id]
set party_id [db_string get_party_id { *SQL* }]

set package_id [ad_conn package_id]

if { [ad_form_new_p -key answer_id] } {
	set page_title "[_ evaluation.lt_Upload_Answer_for_tas]"
} else {
	set page_title "[_ evaluation.lt_Change_Answer_for_tas]"
	db_1row item_data { *SQL* }

}

set context [list $page_title]

db_0or1row double_click { *SQL* }

ad_form -html { enctype multipart/form-data } -name answer -cancel_url $return_url -export { item_id grade_id task_id return_url } -form {

	answer_id:key

}

ad_form -extend -name answer -form {
    
    {upload_file:file,optional
	{label "[_ evaluation.File_]"} 
	{html "size 30"}
    }
    {url:text(text),optional
	{label "[_ evaluation.URL__1]"} 
	{value "http://"}
    }
    
    {comment:text(textarea),optional
	    {label "Comment text"}
	
    }
    
}

ad_form -extend -name answer -form {
    
} -edit_request {
	
	db_1row item_data { *SQL* }

} -validate {
    {url
	{ ($url eq "http://" && $upload_file ne "") || ($url ne "http://" && $upload_file eq "") || ($url ne "http://" && [util_url_valid_p $url]) }
	{ [_ evaluation.lt_Upload_a_file_OR_a_va] }
    }
    {upload_file
	{ ($url eq "http://" && $upload_file ne "") || ($url ne "http://" && $upload_file eq "") }
	{ [_ evaluation.lt_Upload_a_file_OR_a_ur] }
    }
} -on_submit {
	
	db_transaction {

		set mime_type "text/plain"
		set title ""
		# set storage_type to its default value according to a db constraint
		set storage_type "lob"
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
		}  elseif { $url ne "http://" } {
			set mime_type "text/plain"
			set title "link"
		}
		
		set title [evaluation::safe_url_name -name $title]
		if { [ad_form_new_p -key answer_id] } {
			set item_id $answer_id
		} 

		set revision_id [evaluation::new_answer -new_item_p [ad_form_new_p -key answer_id] \
							 -item_id $item_id \
							 -content_type evaluation_answers \
							 -content_table evaluation_answers \
							 -content_id answer_id \
							 -storage_type $storage_type \
							 -task_item_id $task_item_id \
							 -title $title \
							 -mime_type $mime_type \
							 -party_id $party_id]
		
		content::item::set_live_revision -revision_id $revision_id

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
			set content_length 0
			# in order to support oracle and postgres and still using only the cr_items table to store the task
			db_dml set_storage_type { *SQL* }
			db_dml content_size { *SQL* }
			
		}
	}
 
 	ad_returnredirect "answer-ok?return_url=\"$return_url\""
 	ad_script_abort
}

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

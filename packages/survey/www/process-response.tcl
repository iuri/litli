ad_page_contract {

    Insert user response into database.
    This page receives an input for each question named
    response_to_question.$question_id 

    @param   section_id             survey user is responding to
    @param   return_url            optional redirect address
    @param   group_id              
    @param   response_to_question  since form variables are now named as response_to_question.$question_id, this is actually array holding user responses to all survey questions.
    
    @author  jsc@arsdigita.com
    @author  nstrug@arsdigita.com
    @date    28th September 2000
    @cvs-id $Id: process-response.tcl,v 1.16.2.1 2016/05/21 11:04:16 gustafn Exp $

} {
  survey_id:naturalnum,notnull
  section_id:naturalnum,notnull
  {initial_response_id:naturalnum,notnull 0}
  return_url:localurl,optional
  response_to_question:array,optional,multiple,html
  new_response_id:naturalnum,notnull
} -validate {

    section_exists -requires { section_id } {
	if {![db_0or1row section_exists {}]} {
	    ad_complain "[_ survey.lt_Section_section_id_do]"
	}
    }

    check_questions -requires { section_id } {

	set question_info_list [db_list_of_lists survey_question_info_list {
	    select question_id, question_text, abstract_data_type, presentation_type, required_p
	    from survey_questions
	    where section_id = :section_id
	    and active_p = 't'
	    order by sort_order
	}]
	    
	## Validate input.
	
	set questions_with_missing_responses [list]
	
	foreach question $question_info_list { 
	    set question_id [lindex $question 0]
	    set question_text [lindex $question 1]
	    set abstract_data_type [lindex $question 2]
	    set required_p [lindex $question 4]
	    
	    #  Need to clean-up after mess with :array,multiple flags
	    #  in ad_page_contract.  Because :multiple flag will sorround empty
	    #  strings and all multiword values with one level of curly braces {}
	    #  we need to get rid of them for almost any abstract_data_type
	    #  except 'choice', where this is intended behaviour.  Why bother
	    #  with :multiple flag at all?  Because otherwise we would lost all
	    #  but first value for 'choice' abstract_data_type - see ad_page_contract
	    #  doc and code for more info.
	    #
	    if { ([info exists response_to_question($question_id)] && $response_to_question($question_id) ne "") } {
		if {$abstract_data_type ne "choice"} {
		    set response_to_question($question_id) [join $response_to_question($question_id)]
		} else {
		    if { [lindex $response_to_question($question_id) 0 ] eq "" } {
			set response_to_question($question_id) ""
		    }
	        }
	    }
	    
	    if { $abstract_data_type eq "date" } {
		foreach {name value} [ns_set array [ns_getform]] {
		    if {[regexp "^response_to_question\[.\]$question_id\[.\](.*)\$" $name _ part]} {
			set date_value($part) $value
		    }
		}
		set ok [ad_page_contract_filter_proc_date "date" date_value]
		if {$ok} {
		    set response_to_question($question_id) [ns_buildsqldate $date_value(month) \
								$date_value(day) \
								$date_value(year)]
		} else {
		    ad_complain "Please make sure your dates are valid."
		}
 	    }
	   
    
	    if { ([info exists response_to_question($question_id)] && $response_to_question($question_id) ne "") } {

		set response_value [string trim $response_to_question($question_id)]
	    } elseif {$required_p == "t"} {
		lappend questions_with_missing_responses $question_text
		continue
	    } else {
		set response_to_question($question_id) ""
		set response_value ""
	    }
	    
	    if {$response_value ne ""} {
		if { $abstract_data_type eq "number" } {
		    if { ![regexp {^(-?[0-9]+\.)?[0-9]+$} $response_value] } {
			
			ad_complain "[_ survey.lt_The_response_to_ques_n]"
			continue
		    }
		} elseif { $abstract_data_type eq "integer" } {
		    if { ![regexp {^[0-9]+$} $response_value] } {
			
			ad_complain "[_ survey.lt_The_response_to_ques_i]"
			continue
		}
		}
	    }
	    
	    if { $abstract_data_type eq "blob" } {
                set tmp_filename $response_to_question($question_id.tmpfile)
		set n_bytes [file size $tmp_filename]
		if { $n_bytes == 0 && $required_p == "t" } {
		    
		    ad_complain "[_ survey.lt_Your_file_is_zero-len]"
		}
	    }
	    
	}
	
	if { [llength $questions_with_missing_responses] > 0 } {
	    ad_complain "[_ survey.lt_You_didnt_respond_to_]"
	    foreach skipped_question $questions_with_missing_responses {
		ad_complain $skipped_question
	    }
	    return 0
	} else {
	    return 1
	}
    }

} -properties {

    survey_name:onerow
}

permission::require_permission -object_id $survey_id -privilege survey_take_survey

set user_id [ad_conn user_id]

get_survey_info -survey_id $survey_id
set type $survey_info(type)
set survey_id $survey_info(survey_id)
set survey_name $survey_info(name)


# Do the inserts.
# here we need to decide if it is an edit or multiple response, and create
# a new response, possibly linked to a previous response.

# moved to respond.tcl for double-click protection
# set response_id [db_nextval acs_object_id_seq]

if {[db_string get_response_count {}] == 0} {

    set response_id $new_response_id

    set creation_ip [ad_conn peeraddr]
    if {$initial_response_id==0} {
	set initial_response_id ""
    }

    db_transaction {

	db_exec_plsql create_response {}

	set question_info_list [db_list_of_lists survey_question_info_list {
	    select question_id, question_text, abstract_data_type, presentation_type, required_p
	    from survey_questions
	    where section_id = :section_id
	    and active_p = 't'
	    order by sort_order }]


	foreach question $question_info_list { 
	    set question_id [lindex $question 0]
	    set question_text [lindex $question 1]
	    set abstract_data_type [lindex $question 2]
	    set presentation_type [lindex $question 3]

	    set response_value [string trim $response_to_question($question_id)]

	    switch -- $abstract_data_type {
		"choice" {
		    if { $presentation_type eq "checkbox" } {
			# Deal with multiple responses. 
			set checked_responses $response_to_question($question_id)
			foreach response_value $checked_responses {
			    if { $response_value eq "" } {
				set response_value [db_null]
			    }

			    db_dml survey_question_response_checkbox_insert "insert into survey_question_responses (response_id, question_id, choice_id)
 values (:response_id, :question_id, :response_value)"
			}
		    }  else {
			if { $response_value eq "" || [lindex $response_value 0] eq "" } {
			    set response_value [db_null]
			}

			db_dml survey_question_response_choice_insert "insert into survey_question_responses (response_id, question_id, choice_id)
 values (:response_id, :question_id, :response_value)"
		    }
		}
		"shorttext" {
		    db_dml survey_question_choice_shorttext_insert "insert into survey_question_responses (response_id, question_id, varchar_answer)
 values (:response_id, :question_id, :response_value)"
		}
		"boolean" {
		    if { $response_value eq "" } {
			set response_value [db_null]
		    }

		    db_dml survey_question_response_boolean_insert "insert into survey_question_responses (response_id, question_id, boolean_answer)
 values (:response_id, :question_id, :response_value)"
		}
		"integer" -
		"number" {
		    if { $response_value eq "" } {
			set response_value [db_null]
		    } 
		    db_dml survey_question_response_integer_insert "insert into survey_question_responses (response_id, question_id, number_answer)
 values (:response_id, :question_id, :response_value)"
		}
		"text" {
		    if { $response_value eq "" } {
			set response_value [db_null]
		    }

		    db_dml survey_question_response_text_insert "
insert into survey_question_responses
(response_id, question_id, clob_answer)
values (:response_id, :question_id, empty_clob())
returning clob_answer into :1" -clobs [list $response_value]
	    }
	    "date" {
                if { $response_value eq "" } {
                    set response_value [db_null]
                }

		db_dml survey_question_response_date_insert "insert into survey_question_responses (response_id, question_id, date_answer)
values (:response_id, :question_id, :response_value)"
	    }   
            "blob" {

                if { $response_value ne "" } {
                    # this stuff only makes sense to do if we know the file exists
		    set tmp_filename $response_to_question($question_id.tmpfile)

                    set file_extension [string tolower [file extension $response_value]]
                    # remove the first . from the file extension
                    regsub {\.} $file_extension "" file_extension
                    set guessed_file_type [ns_guesstype $response_value]

                    set n_bytes [file size $tmp_filename]
                    # strip off the C:\directories... crud and just get the file name
                    if {![regexp {([^/\\]+)$} $response_value match client_filename]} {
                        # couldn't find a match
                        set client_filename $response_value
                    }
                    if { $n_bytes == 0 } {
                        error "This should have been checked earlier."
                    } else {
                         set unique_name "${response_value}_${response_id}"
                         set mime_type [ns_guesstype $client_filename]
                         set revision_id [cr_import_content -title $client_filename "" $tmp_filename $n_bytes $mime_type $unique_name ]
# we use cr_import_content now --DaveB
# this abstracts out for use the blob handling for oracle or postgresql
# we are linking the file item_id to the survey_question_response attachment_answer field now
                            db_dml survey_question_response_attachment_insert "
insert into survey_question_responses
(response_id, question_id, attachment_answer)
values
(:response_id, :question_id, :revision_id
 )"
	 	    }
                }
            }
	}
    }
}

survey_do_notifications -response_id $response_id

}

if {[info exists return_url] && $return_url ne ""} {
    ad_returnredirect "$return_url"
           ad_script_abort
} else {
     set context [_ survey.lt_Response_Submitted_for]
     ad_return_template
}	
    




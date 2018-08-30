# /www/survey/admin/responses-export.tcl
ad_page_contract {

  CSV export of responses to particular survey.

  @author  sebastian@arsdigita.com
  @date    July 2000
  @cvs-id  $Id: responses-export.tcl,v 1.13 2015/06/27 20:46:16 gustafn Exp $

} {

  survey_id:naturalnum,notnull
  {unique_users_p:boolean f}
  on_what_id:naturalnum,optional
  {start:naturalnum 1}
  {end:naturalnum 10000}
}
set csv_export ""
set package_id [ad_conn package_id]
permission::require_permission -object_id $package_id -privilege survey_admin_survey

set n_responses [db_string get_n_responses {}]
ns_log notice "DAVEB: n_responses=$n_responses"
if {$n_responses==0} {
    get_survey_info -survey_id $survey_id
    set context [list [list [export_vars -base one {survey_id}] $survey_info(name)] "[_ survey.CSV_Export]"]
    ad_return_template "no-responses"
    return
}

set question_id_list [list]
set responses_table survey_responses

set headline "email,first_names,last_name,user_id,submission_date,response_id"

db_foreach get_question_data_types {} {
    lappend question_id_list $question_id
    regsub -all {"} $question_text {""} question_text
    append headline ",\"$question_text"
    append headline "\""
    set question_data_type($question_id) $abstract_data_type
    switch -- $abstract_data_type {
	"date" {
	    set question_column($question_id) "date_answer"
	}
	"text" {
	    set question_column($question_id) "clob_answer"
	}
	"shorttext" {
	    set question_column($question_id) "varchar_answer"
	}
	"boolean" {
	    set question_column($question_id) "boolean_answer"
	}
	"integer" -
	"number" {
	    set question_column($question_id) "number_answer"
	}
	"choice" {
	    set question_column($question_id) "label"
	}
	"blob" {
	    set question_column($question_id) "attachment_answer"
	}
	default {
	    set question_column($question_id) "varchar_answer"
	}
    }

}

#  We're looping over all question responses in survey_question_responses

set current_response_id ""
set current_response ""
set current_question_id ""
set current_question_list [list]
set csv_export ""
set r 0
ReturnHeaders "application/text"
ns_write "$headline \r\n"

db_foreach get_all_survey_question_responses "" {

    if { $response_id != $current_response_id } {
	if { $current_question_id ne "" } {
	    append current_response ",\"[join $current_question_list ","]\""
	}

	if { $current_response_id ne "" } {
	    append csv_export "$current_response \r\n"
	}
	set current_response_id $response_id

	set creation_date_ansi [lc_time_system_to_conn $creation_date_ansi]
	set creation_date_pretty [lc_time_fmt $creation_date_ansi "%x %X"]
	set one_response [list $email $first_names $last_name $user_id $creation_date_pretty $response_id]
	regsub -all {"} $one_response {""} one_response
	set current_response "\"[join $one_response {","}]\""

	set current_question_id ""
	set current_question_list [list]
    }

      set response_value [set $question_column($question_id)]
      #  Properly escape double quotes to make Excel & co happy
      regsub -all {"} $response_value {""} response_value
  
      #  Remove any CR or LF characters that may be present in text fields
      regsub -all {[\r\n]} $response_value {} response_value

      if { $question_id != $current_question_id } {
  	if { $current_question_id ne "" } {
  	    append current_response ",\"[join $current_question_list ","]\""
  	}
  	set current_question_id $question_id
  	set current_question_list [list]
      }
# decode boolean answers
	if {$question_data_type($question_id)=="boolean"} {
	    set response_value [survey_decode_boolean_answer -response $response_value -question_id $question_id]
	}
	if {$question_data_type($question_id)=="blob"} {
	    set response_value [db_string get_filename {} -default ""]
	}
      lappend current_question_list $response_value
	
	incr r
	if {$r>99} {
	    ns_write "${csv_export}"
	    set csv_export ""
	    set r 0
	}

    }

  if { $current_question_id ne "" } {
      append current_response ",\"[join $current_question_list ","]\""
  }
  if { $current_response_id ne "" } {
     append csv_export "$current_response\r\n"
 }
    if {$csv_export eq ""} {
	set csv_export "\r\n"
    }
    ns_write $csv_export

ns_conn close

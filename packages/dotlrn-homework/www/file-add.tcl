ad_page_contract {

    Upload a new homework assignment.

    Don Baccus (dhogaza@pacifier.com)

} {
    folder_id:naturalnum,notnull
    name:optional
    return_url:localurl,notnull
    {homework_file_id:naturalnum,notnull 0}
} -validate {
    valid_folder -requires {folder_id:integer} {
	if {![fs_folder_p $folder_id]} {
	    ad_complain "[_ dotlrn-homework.lt_spec_parent]"
	}
    }
} -properties {
    context_bar:onevalue
    page_title:onevalue
}

# check for write permission on the folder
permission::require_permission -object_id $folder_id -privilege write

# Homework_file_id tells us whether or not we're uploading a correction file to relate
# to an existing homework file, or a new home work file

if { $homework_file_id == 0 } {
    set page_title "[_ dotlrn-homework.lt_submit_new_file]"
    set context_bar [list [_ dotlrn-homework.lt_upload_new_as]]
} else {
    set page_title "[_ dotlrn-homework.lt_submit_comm]"
    set context_bar [list "[_ dotlrn-homework.lt_upload_comm]"]
}

ad_form -name homework_form -html { enctype multipart/form-data } -export { return_url folder_id homework_file_id } -form {
    file_id:key
    {upload_file:file                    {label "[_ dotlrn-homework.lt_version_filename]"}
    }
}

if { $homework_file_id == 0 } {
    ad_form -extend -name homework_form -form {
        {name:text                           {label "[_ dotlrn-homework.Title]"}
                                             {html {size 30}}}
    }
} else {
    ad_form -extend -name homework_form -export { name } -form {}
}

ad_form -extend -name homework_form -form {

    {description:text(textarea),optional {label "[_ dotlrn-homework.Description]"}
                                         {html {rows 5 cols 50}}}
} -validate {
    {upload_file
      { [file size [template::util::file::get_property tmp_filename $upload_file]] <= [parameter::get -parameter "MaximumFileSize"] }
      "[_ dotlrn-homework.lt_your_file_is] ([util_commify_number [parameter::get -parameter MaximumFileSize]] [_ dotlrn-homework.bytes])"
    }
} -new_data {

    db_transaction {

        dotlrn_homework::new \
            -file_id $file_id \
            -new_file_p 1 \
            -parent_folder_id $folder_id \
            -title $name \
            -description $description \
            -upload_file $upload_file \
            -homework_file_id $homework_file_id \
            -package_id [ad_conn package_id]

        # Alert management.  Semantics are hardwired to Sloan's spec.  Eventually it would probably be nice
        # to make 'em configurable for non-admin users as they are now for admin users
        if { $homework_file_id == 0 } {

            # We're uploading a new homework file, send alerts associated with our folder
            dotlrn_homework::send_homework_alerts -folder_id $folder_id -file_id $file_id

            # Now set an alert for our student so they'll get pinged when a correction file is uploaded
            dotlrn_homework::request_correction_alert -homework_file_id $file_id

        } else {
            # We're uploading a correction file, send alerts associated with the related homework file
            dotlrn_homework::send_correction_alerts -folder_id $folder_id -homework_file_id $homework_file_id

        }

    } on_error {
        ad_return_exception_template -params {errmsg} "/packages/acs-subsite/www/shared/db-error"
    }

    ad_returnredirect $return_url
}

ad_return_template "homework-form"

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

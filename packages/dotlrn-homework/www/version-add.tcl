ad_page_contract {

    Upload a new version of an existing homework assignment.

    Don Baccus (dhogaza@pacifier.com)

} {
    file_id:integer,notnull
    folder_id:integer,notnull
    name:notnull
    return_url:localurl,notnull
} -validate {
    valid_folder -requires {folder_id:integer} {
	if {![fs_folder_p $folder_id]} {
	    ad_complain "[_ dotlrn-homework.lt_spec_parent]"
	}
    }
} -properties {
    context_bar:onevalue
    name:onevalue
    page_title:onevalue
}

# check for write permission on the file
permission::require_permission -object_id $file_id -privilege write

set page_title "[_ dotlrn-homework.lt_upload_new_version_of]"
set context_bar [list [_ dotlrn-homework.lt_upload_new_ass_version]]

ad_form -name homework_form -html { enctype multipart/form-data } -export { return_url name folder_id } -form {
    file_id:key
    {upload_file:file                    {label "[_ dotlrn-homework.lt_version_filename]"}}
    {description:text(textarea),optional {label "[_ dotlrn-homework.lt_version_notes]"}
                                         {html {rows 5 cols 50}}}
} -edit_request {
} -validate {
    {upload_file
      { [file size [template::util::file::get_property tmp_filename $upload_file]] <= [parameter::get -parameter "MaximumFileSize"] }
      "[_ dotlrn-homework.lt_your_file_is] ([util_commify_number [parameter::get -parameter MaximumFileSize]] [_ dotlrn-homework.bytes])"
    }
} -edit_data {

    db_transaction {

        # Alert management.  Semantics are hardwired to Sloan's spec.  Eventually it would probably be nice
        # to make 'em configurable for non-admin users as they are now for admin users

	set homework_file_id 0
        set homework_file_p [db_0or1row get_homework_info {}]

        dotlrn_homework::new -file_id $file_id -new_file_p 0 -description $description -upload_file $upload_file \
            -homework_file_id $homework_file_id

        if { $homework_file_p } {

            # We're uploading a correction file version, send alerts associated with the related homework file
            dotlrn_homework::send_correction_alerts -folder_id $folder_id -homework_file_id $homework_file_id

        } else {

            # We're uploading a new homework file version, send alerts associated with our folder
            dotlrn_homework::send_homework_alerts -folder_id $folder_id -file_id $file_id

        }

    } on_error {
        ad_return_exception_template -params {errmsg} "/packages/acs-subsite/www/shared/db-error"
    }

    ad_returnredirect $return_url
    ad_script_abort
}

ad_return_template homework-form

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

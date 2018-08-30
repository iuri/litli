ad_page_contract {

    Form to create a homework subfolder

    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 7 Nov 2000
    @cvs-id $Id: folder-create.tcl,v 1.4.2.2 2016/05/20 20:26:15 gustafn Exp $
} {
    parent_id:integer,notnull
    return_url:localurl,notnull
} -validate {
    valid_folder -requires {parent_id:integer} {
	if {![fs_folder_p $parent_id]} {
	    ad_complain [_ dotlrn-homework.lt_spec_parent]
	}
    }
} -properties {
    parent_id:onevalue
    context_bar:onevalue
    page_title:onevalue
}

set context_bar [list [_ dotlrn-homework.lt_create_folder]]
set page_title [_ dotlrn-homework.lt_create_subfolder]

set user_id [ad_conn user_id]
set creation_ip [ad_conn peeraddr]

# Check that they have admin permission on the parent folder

# Unlike the file-storage package, the homework package only allows writers
# to upload a file, not create a folder.  In other words, we allow students
# to upload homework files but only class admins can create new homework
# subfolders.

permission::require_permission -object_id $parent_id -privilege admin

ad_form -name homework_form -form {
    {return_url:text(hidden)         {value $return_url}}
    {parent_id:text(hidden)          {value $parent_id}}
    {folder_name:text                {label "[_ dotlrn-homework.lt_folder_name]"}
                                     {html {size 20}}}
} -on_submit {

    regsub -all { +} [string tolower $folder_name] {_} name

    db_transaction {

        db_exec_plsql folder_create {}

    } on_error {
	ad_return_exception_template -params {errmsg} "/packages/acs-subsite/www/shared/db-error"
    }

    ad_returnredirect $return_url

}

ad_return_template homework-form

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

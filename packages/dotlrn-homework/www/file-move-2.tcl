ad_page_contract {
    script to move a file into a new folder

    @author Kevin Scaldeferri (kevin@arsdigita.com)
    @creation-date 13 Nov 2000
    @cvs-id $Id: file-move-2.tcl,v 1.4.2.1 2015/09/11 11:40:58 gustafn Exp $
} {
    file_id:integer,notnull
    parent_id:integer,notnull
} -validate {
    valid_file -requires {file_id} {
	if {![fs_file_p $file_id]} {
	    ad_complain "[_ dotlrn-homework.lt_specified_file]"
	}
    }

    valid_folder -requires {parent_id} {
	if {![fs_folder_p $parent_id]} {
	    ad_complain "[_ dotlrn-homework.lt_spec_parent]"
	}
    }
}

# check for write permission on both the file and the target folder

permission::require_permission -object_id $file_id -privilege write
permission::require_permission -object_id $parent_id -privilege write

set creation_user [ad_conn user_id]
set creation_ip [ns_conn peeraddr]

db_transaction {

    set correction_file_id [db_string correction_file_id {} -default ""]

    db_exec_plsql file_move {}
    db_dml context_update {}

    if { $correction_file_id ne "" } {
        db_exec_plsql correction_file_move {}
        db_dml correction_context_update {}
    }

} on_error {

    ad_return_exception_template -params {errmsg} "/packages/acs-subsite/www/shared/db-error"
    return

}

ad_returnredirect "folder-contents?folder_id=$parent_id"


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

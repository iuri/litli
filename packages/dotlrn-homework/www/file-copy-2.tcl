ad_page_contract {
    script to copy a file into a new folder

    @author Kevin Scaldeferri (kevin@arsdigita.com)
    @creation-date 14 Nov 2000
    @cvs-id $Id: file-copy-2.tcl,v 1.3.2.1 2015/09/11 11:40:58 gustafn Exp $
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

# check for read permission on the file and write permission on the
# target folder

permission::require_permission -object_id $file_id -privilege read
permission::require_permission -object_id $parent_id -privilege write

set user_id [ad_conn user_id]
set ip_address [ad_conn peeraddr]

# Question - do we copy revisions or not?
# Current Answer - we copy the live revision only

db_transaction {

    set correction_file_id [db_string correction_file_id {} -default ""]

    # file_copy returns the new revision id, not the new file id, so we need to retrieve
    # the new homework and correction file ids.

    # DRB: Note for future reference - copy_file does not work for content stored in the 
    # filesystem rather than db.

    set new_homework_revision_id [db_exec_plsql file_copy {}]
    db_1row get_new_homework_info {}

    # See dotlrn_homework::new for comments about file-storage's generally lame handling of
    # permissions.

    db_dml update_homework_context {}

    permission::grant -party_id $user_id -object_id $new_homework_id -privilege write
    permission::grant -party_id $user_id -object_id $new_homework_id -privilege read

    # Copy the comment/correction file if any
    if { $correction_file_id ne "" } {

        set new_correction_revision_id [db_exec_plsql correction_file_copy {}]

        db_1row get_new_correction_info {}

        dotlrn_homework::add_correction_relation -homework_file_id $new_homework_id -correction_file_id $new_correction_id

        db_dml update_correction_context {}

        # I'm assuming the user is making their own copy of the homework and correction file for their
        # own use and that they don't want the TA or Prof messing around with it.  As opposed to move
        # which is presumably used to put stuff in the right place after having first putting stuff in
        # the wrong place.

        permission::grant -party_id $user_id -object_id $new_correction_id -privilege read

    }

} on_error {
    ad_return_complaint 1 "[_ dotlrn-homework.lt_folder_already_contains] " 
    return
}

ad_returnredirect "folder-contents?folder_id=$parent_id"

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

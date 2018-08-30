ad_page_contract {
    page to confirm and delete a file

    @author Kevin Scaldeferri (kevin@arsdigita.com)
    @creation-date 10 Nov 2000
    @cvs-id $Id: file-delete.tcl,v 1.6.2.1 2015/09/11 11:40:58 gustafn Exp $
} {
    file_id:integer,notnull
    {confirmed_p:boolean "f"}
} -validate {
    valid_file -requires {file_id} {
	if {![fs_file_p $file_id]} {
	    ad_complain "[_ dotlrn-homework.lt_specified_file]"
	}
    }
} -properties {
    file_id:onevalue
    file_name:onevalue
    blocked_p:onevalue
    context_bar:onevalue
}

# check for delete permission on the file

permission::require_permission -object_id $file_id -privilege delete

# check the file doesn't have any revisions that the user
# doesn't have permission to delete

set user_id [ad_conn user_id]

set blocked_p [ad_decode [db_string blockers "
select count(*) 
from   cr_revisions
where  item_id = :file_id
and    acs_permission.permission_p(revision_id,:user_id,'delete') = 'f'"] 0 f t]

if {$confirmed_p == "t" && $blocked_p == "f" } {
    # they confirmed that they want to delete the file

    db_1row parent_id "select parent_id from cr_items where item_id = :file_id"

    db_transaction {

        # DRB: damned permissions table has no "on delete cascade" and file storage
        # delete assumes there are perms on the revision itself.   This code breaks
        # the permissions abstraction but some day, 4.7 perhaps, we'll have proper
        # referential integrity operators in at least some of the datamodel

        db_dml version_perms_delete {}

        db_exec_plsql delete_file "
        begin
            file_storage.delete_file(:file_id);
        end;"

    }

    ad_returnredirect "folder-contents?folder_id=$parent_id"

} else {
    # they need to confirm that they really want to delete the file

    db_1row file_name {}

    set title [dotlrn_homework::decode_name $title]

    set context_bar [list [_ dotlrn-homework.Delete]]

    ad_return_template
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

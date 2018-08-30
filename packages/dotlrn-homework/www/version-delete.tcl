ad_page_contract {
    confirmation page for version deletion

    @author Kevin Scaldeferri (kevin@arsdigita.com)
    @creation-date 10 November 2000
    @cvs-id $Id: version-delete.tcl,v 1.7.2.1 2015/09/11 11:40:59 gustafn Exp $
} {
    version_id:integer,notnull
    {confirmed_p:boolean "f"}
} -validate {
    valid_version -requires {version_id} {
	if {![fs_version_p $version_id]} {
	    ad_complain "[_ dotlrn-homework.lt_spec_version]"
	}
    }
} -properties {
    version_id:onevalue
    version_name:onevalue
    title:onevalue
    context_bar:onevalue
}

# check for delete permission on the version

permission::require_permission -object_id $version_id -privilege delete

db_1row item_select "
select item_id
from   cr_revisions
where  revision_id = :version_id"

if {$confirmed_p == "t"} {
    # they have confirmed that they want to delete the version

    db_transaction {

        # DRB: damned permissions table has no "on delete cascade" and file storage
        # delete assumes there are perms on the revision itself.   This code breaks
        # the permissions abstraction but some day, 4.7 perhaps, we'll have proper
        # referential integrity operators in at least some of the datamodel

        db_dml version_perms_delete {}

        set parent_id [db_exec_plsql delete_version "
            begin
              :1 := file_storage.delete_version(:item_id,:version_id);
            end;"
        ]

        if {$parent_id > 0} {

	    # Delete the item if there is no more revision. We do this here only because of PostgreSQL's RI bug
	    db_exec_plsql delete_file "
	        begin
	          file_storage.delete_file(:item_id);
	        end;"

        }

    }

    if {$parent_id > 0} {
	# Redirect to the folder, instead of the latest revision (which does not exist anymore)
	ad_returnredirect [export_vars -base folder-contents {{folder_id $parent_id}}]
    } else {
	# Ok, we don't have to do anything fancy, just redirect to th last revision
	ad_returnredirect [export_vars -base file {{file_id $item_id} {folder_id $parent_id}}]
    }

} else {
    # they still need to confirm

    db_1row version_name {}

    set title [dotlrn_homework::decode_name $title]

    set context_bar [list [_ dotlrn-homework.lt_delete_version]]
    ad_return_template
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

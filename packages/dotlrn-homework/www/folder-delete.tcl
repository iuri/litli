ad_page_contract {
    page to confirm and delete folder.  At the moment only works
    for empty folders, but ultimately should allow recursive deletes.

    @author Kevin Scaldeferri (kevin@arsdigita.com)
    @author Don Baccus (dhogaza@pacifier.com)
    @creation-date 10 November 2000
    @cvs-id $Id: folder-delete.tcl,v 1.5.2.1 2015/09/11 11:40:59 gustafn Exp $
} {
    folder_id:integer,notnull
    {confirmed_p:boolean "f"}
} -validate {
    valid_folder -requires {folder_id:integer} {
	if {![fs_folder_p $folder_id]} {
	    ad_complain "[_ dotlrn-homework.lt_spec_folder]"
	}
    }

    no_children -requires {not_root_folder} {
	if { [db_string child_count {}] > 0 } {
	    ad_complain "[_ dotlrn-homework.lt_were_sorry]"
	}
    }
} -properties {
    folder_id:onevalue
    folder_name:onevalue
    context_bar:onevalue
}

# check for delete permission on the folder

permission::require_permission -object_id $folder_id -privilege delete

if {$confirmed_p == "t"} {
    # they have confirmed that they want to delete the folder
    db_1row parent_id {}
    db_exec_plsql folder_delete {}
    ad_returnredirect "folder-contents?folder_id=$parent_id"
} else {
    # they still need to confirm
    set folder_name [db_string folder_name {}]
    set context_bar [list [_ dotlrn-homework.Delete]]
    ad_return_template
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

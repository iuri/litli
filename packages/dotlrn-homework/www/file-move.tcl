ad_page_contract {
    page to select a new folder to move a file into (Actually, this should 
    work to move folders too)

    @author Kevin Scaldeferri (kevin@arsdigita.com)
    @creation-date 13 Nov 2000
    @cvs-id $Id: file-move.tcl,v 1.3.2.1 2015/09/11 11:40:58 gustafn Exp $
} {
    file_id:integer,notnull
    name:notnull
} -validate {
    valid_file -requires {file_id} {
	if {![fs_file_p $file_id]} {
	    ad_complain "[_ dotlrn-homework.lt_specified_file]"
	}
    }
} -properties {
    file_id:onevalue
    name:onevalue
    context_bar:onevalue
}

# check they have write permission on the file (is this really the
# right permission?)

permission::require_permission -object_id $file_id -privilege write
set context_bar "[_ dotlrn-homework.Move]"
set return_url "[ad_conn url]?[ad_conn query]"

ad_return_template



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

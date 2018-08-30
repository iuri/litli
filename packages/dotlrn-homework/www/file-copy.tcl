ad_page_contract {
    page to select a new folder to copy a file to

    @author Kevin Scaldeferri (kevin@arsdigita.com)
    @creation-date 14 Nov 2000
    @cvs-id $Id: file-copy.tcl,v 1.4.2.1 2015/09/11 11:40:58 gustafn Exp $
} {
    file_id:integer,notnull
} -validate {
    valid_file -requires {file_id} {
	if {![fs_file_p $file_id]} {
	    ad_complain "[_ dotlrn-homework.lt_specified_file]"
	}
    }
} -properties {
    file_id:onevalue
    file_name:onevalue
    context_bar:onevalue
}

# check for read permission on the file

permission::require_permission -object_id $file_id -privilege read

# set templating datasources

set file_name [dotlrn_homework::decode_name [db_string file_name {}]]

set context_bar [list [_ dotlrn-homework.Copy]]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

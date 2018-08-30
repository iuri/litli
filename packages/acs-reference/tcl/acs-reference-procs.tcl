ad_library {
    Utility procs for working with data in acs-reference

    @author Jon Griffin <jon@jongriffin.com>
    @creation-date 2001-08-28
    @cvs-id $Id: acs-reference-procs.tcl,v 1.1.30.1 2015/09/10 08:21:32 gustafn Exp $
}

ad_proc -private acs_reference_get_db_structure {
	{-table_name:required}
} {
    Query the DB to get the data structure.  Utility function.
} {

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

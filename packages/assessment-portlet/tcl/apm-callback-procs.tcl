ad_library {
    Procedures for initializing service contracts etc. for the
    assessment portlet package. Should only be executed 
    once upon installation.
    
    @creation-date Sept 2004
    @author jopez@galileo.edu
    @cvs-id $Id: apm-callback-procs.tcl,v 1.1.14.1 2015/09/10 08:28:09 gustafn Exp $
}

namespace eval apm::assessment_portlet {}
namespace eval apm::assessment_admin_portlet {}

ad_proc -public apm::assessment_portlet::after_install {} {
    Create the datasources needed by the assessment portlets.
} {
        assessment_portlet::after_install
        assessment_admin_portlet::after_install
}

ad_proc -public apm::assessment_portlet::before_uninstall {} {
    Assessment Portlet package uninstall proc
} {

    db_transaction {
        assessment_portlet::uninstall
        assessment_admin_portlet::uninstall
    }
}



# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

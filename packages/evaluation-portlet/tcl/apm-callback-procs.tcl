ad_library {
    Procedures for initializing service contracts etc. for the
    evaluation portlet package. Should only be executed 
    once upon installation.
    
    @creation-date May 2004
    @author jopez@galileo.edu
    @cvs-id $Id: apm-callback-procs.tcl,v 1.9.8.1 2015/09/12 11:06:10 gustafn Exp $
}

namespace eval evaluation_portlet {}
namespace eval evaluation_assignments_portlet {}
namespace eval evaluation_evaluations_portlet {}
namespace eval evaluation_admin_portlet {}

ad_proc -public evaluation_portlet::after_install {} {
    Create the datasources needed by the evaluation portlets.
} {
        evaluation_assignments_portlet::after_install
        evaluation_evaluations_portlet::after_install
        evaluation_admin_portlet::after_install
}

ad_proc -public evaluation_portlet::before_uninstall {} {
    Evaluation Portlet package uninstall proc
} {

    db_transaction {
        evaluation_assignments_portlet::uninstall
        evaluation_evaluations_portlet::uninstall
        evaluation_admin_portlet::uninstall
    }
}

ad_proc -private evaluation_portlet::after_upgrade {
    {-from_version_name:required}
    {-to_version_name:required}
} {
    After upgrade callback for evaluation portlets.
} {
    apm_upgrade_logic \
        -from_version_name $from_version_name \
        -to_version_name $to_version_name \
        -spec {
            2.3.0d1 2.3.0d2 {
                db_dml update_portal_datasources {}
            }
    }
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

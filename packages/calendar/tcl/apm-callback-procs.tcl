ad_library {

    Calendar Package APM callbacks library

    Procedures that deal with installing, instantiating, mounting.

    @creation-date July 2007
    @author rmorales@innova.uned.es
    @cvs-id $Id: apm-callback-procs.tcl,v 1.2.8.1 2015/09/10 08:30:14 gustafn Exp $
}

namespace eval calendar {}
namespace eval calendar::apm {}


ad_proc -public calendar::apm::package_after_upgrade {
    -from_version_name:required
    -to_version_name:required
} {
    Upgrade script for the calendar  package
} {
    apm_upgrade_logic \
    -from_version_name $from_version_name \
    -to_version_name $to_version_name \
    -spec {
        2.1.0b7 2.1.0b8 {
            db_transaction {
                db_dml update_context {}
                db_dml remove_personal_notifications {}
            } on_error {
                ns_log Error "Error:$errmsg"
            }
        }
    }
}




# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

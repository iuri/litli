ad_library {
    
    APM callback procs for calendar-portlet

    @author Don Baccus (dhogaza@pacifier.com)
}

namespace eval calendar-portlet {}

ad_proc -private calendar-portlet::after_upgrade {
    {-from_version_name:required}
    {-to_version_name:required}
} {
    After upgrade callback for calendar-portlet.
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

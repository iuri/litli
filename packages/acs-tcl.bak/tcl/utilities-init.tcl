ad_library {

    Initializes datastructures for utility procs.

    @creation-date 02 October 2000
    @author Bryan Quinn
    @cvs-id $Id: utilities-init.tcl,v 1.9.8.1 2015/09/10 08:22:01 gustafn Exp $
}

# initialize the random number generator
randomInit [ns_time]

# Create mutex for util_background_exec
nsv_set util_background_exec_mutex . [ns_mutex create oacs:bg_exec]

# if logmaxbackup in config is missing or zero, don't run auto-logrolling
set logmaxbackup [ns_config -int "ns/parameters" logmaxbackup 0]

if { $logmaxbackup } {
    ad_schedule_proc -all_servers t -schedule_proc ns_schedule_daily \
	[list 00 00] util::roll_server_log
}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

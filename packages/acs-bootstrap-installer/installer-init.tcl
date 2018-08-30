#      Initializes datastrctures for the installer.

#      @creation-date 02 October 2000
#      @author Bryan Quinn
#      @cvs-id $Id: installer-init.tcl,v 1.3.10.1 2015/09/10 08:21:15 gustafn Exp $


# Create a mutex for the installer
nsv_set acs_installer mutex [ns_mutex create oacs:installer]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

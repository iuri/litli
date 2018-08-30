# /packages/dotlrn-portlet/tcl/apm-callback-procs.tcl

ad_library {

     dotlrn-portlet APM callbacks library

     Procedures that deal with installing.

     @creation-date July 2004
     @author  Hector Amado (hr_amado@galileo.edu)
     @cvs-id $Id: apm-callback-procs.tcl,v 1.3.2.1 2015/09/11 11:41:00 gustafn Exp $
     
}

namespace eval dotlrn_portlet {}
namespace eval dotlrn_portlet::apm {}

ad_proc -private dotlrn_portlet::apm::after_install {
} {
  Gran permission to dotlrn-admin
} {


       set group_id [db_string group_id_from_name "
            select group_id from groups where group_name='dotlrn-admin'" -default ""]
        if {$group_id ne "" } {

        #Admin privs
        permission::grant \
             -party_id $group_id \
	     -object_id [apm_package_id_from_key dotlrn-portlet]  \
             -privilege "admin"
       } 

}

ad_proc -private dotlrn_portlet::apm::before_uninstall {
} {
  Revoke the group permissions, dotlrn-admin
} {

       set group_id [db_string group_id_from_name "
            select group_id from groups where group_name='dotlrn-admin'" -default ""]
        if {$group_id ne "" } {

        permission::revoke \
            -party_id $group_id \
            -object_id [apm_package_id_from_key dotlrn-portlet]  \
            -privilege "admin"
       }
}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

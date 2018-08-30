ad_library {
    Procedures for registering implementations for the
    dotlrn assessment package. 
    
    @creation-date 2004-10-20
    @author jopez@galileo.edu
    @cvs-id $Id: apm-callback-procs.tcl,v 1.1.14.1 2015/09/11 11:40:55 gustafn Exp $
}

namespace eval dotlrn_assessment {}

ad_proc -public dotlrn_assessment::install {} {
    dotLRN Assessment package install proc
} {
    register_portal_datasource_impl
}

ad_proc -public dotlrn_assessment::uninstall {} {
    dotLRN Assessment package uninstall proc
} {
    unregister_portal_datasource_impl
}

ad_proc -public dotlrn_assessment::register_portal_datasource_impl {} {
    Register the service contract implementation for the dotlrn_applet service contract
} {
    set spec {
        name "dotlrn_assessment"
	contract_name "dotlrn_applet"
	owner "dotlrn-assessment"
        aliases {
	    GetPrettyName dotlrn_assessment::get_pretty_name
	    AddApplet dotlrn_assessment::add_applet
	    RemoveApplet dotlrn_assessment::remove_applet
	    AddAppletToCommunity dotlrn_assessment::add_applet_to_community
	    RemoveAppletFromCommunity dotlrn_assessment::remove_applet_from_community
	    AddUser dotlrn_assessment::add_user
	    RemoveUser dotlrn_assessment::remove_user
	    AddUserToCommunity dotlrn_assessment::add_user_to_community
	    RemoveUserFromCommunity dotlrn_assessment::remove_user_from_community
	    AddPortlet dotlrn_assessment::add_portlet
	    RemovePortlet dotlrn_assessment::remove_portlet
	    Clone dotlrn_assessment::clone
	    ChangeEventHandler dotlrn_assessment::change_event_handler
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}

ad_proc -public dotlrn_assessment::unregister_portal_datasource_impl {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "dotlrn_applet" \
        -impl_name "dotlrn_assessment"
}


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

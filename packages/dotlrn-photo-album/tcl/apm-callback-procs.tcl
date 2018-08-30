ad_library {
    Procedures for registering implementations for the
    dotlrn photo album package. 
    
    @author Jeff Davis (davis@xarg.net)
}

namespace eval dotlrn_photo_album {}

ad_proc -private dotlrn_photo_album::install {} {
    dotLRN Photo_Album package install proc
} {
    register_portal_datasource_impl
}

ad_proc -private dotlrn_photo_album::uninstall {} {
    dotLRN Photo_Album package uninstall proc
} {
    unregister_portal_datasource_impl
}

ad_proc -private dotlrn_photo_album::register_portal_datasource_impl {} {
    Register the service contract implementation for the dotlrn_applet service contract
} {
    set spec {
        name "dotlrn_photo_album"
	contract_name "dotlrn_applet"
	owner "dotlrn-photo-album"
        aliases {
	    GetPrettyName dotlrn_photo_album::get_pretty_name
	    AddApplet dotlrn_photo_album::add_applet
	    RemoveApplet dotlrn_photo_album::remove_applet
	    AddAppletToCommunity dotlrn_photo_album::add_applet_to_community
	    RemoveAppletFromCommunity dotlrn_photo_album::remove_applet_from_community
	    AddUser dotlrn_photo_album::add_user
	    RemoveUser dotlrn_photo_album::remove_user
	    AddUserToCommunity dotlrn_photo_album::add_user_to_community
	    RemoveUserFromCommunity dotlrn_photo_album::remove_user_from_community
	    AddPortlet dotlrn_photo_album::add_portlet
	    RemovePortlet dotlrn_photo_album::remove_portlet
	    Clone dotlrn_photo_album::clone
	    ChangeEventHandler dotlrn_photo_album::change_event_handler
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}

ad_proc -private dotlrn_photo_album::unregister_portal_datasource_impl {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "dotlrn_applet" \
        -impl_name "dotlrn_photo_album"
}

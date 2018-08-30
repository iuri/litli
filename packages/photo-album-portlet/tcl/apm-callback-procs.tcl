ad_library {
    Procedures for initializing service contracts etc. for the
    photo album portlet package. Should only be executed 
    once upon installation.
    
    @creation-date  17 June 2003
    @author Jeff Davis (davis@xarg.net)
    @cvs-id $Id: apm-callback-procs.tcl,v 1.2 2003/10/15 10:11:18 lars Exp $
}


namespace eval photo_album_portlet {}
namespace eval photo_album_admin_portlet {}

ad_proc -private photo_album_portlet::after_install {} {
    Create the datasources needed by the photo album portlet.
} {
    
    db_transaction {
	set ds_id [portal::datasource::new \
                   -name "photo_album_portlet" \
                   -description "Photo Album Portlet"]

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shadeable_p \
            -value t

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key hideable_p \
            -value t

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key user_editable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shaded_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key link_hideable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p f \
            -key package_id \
            -value ""

	register_portal_datasource_impl
        
        photo_album_admin_portlet::after_install

    }
}



ad_proc -private photo_album_portlet::register_portal_datasource_impl {} {
    Create the service contracts needed by the photo-album portlet.
} {
    set spec {
        name "photo_album_portlet"
	contract_name "portal_datasource"
	owner "photo-album-portlet"
        aliases {
	    GetMyName photo_album_portlet::get_my_name
	    GetPrettyName  photo_album_portlet::get_pretty_name
	    Link photo_album_portlet::link
	    AddSelfToPage photo_album_portlet::add_self_to_page
	    Show photo_album_portlet::show
	    Edit photo_album_portlet::edit
	    RemoveSelfFromPage photo_album_portlet::remove_self_from_page
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}



ad_proc -private photo_album_portlet::uninstall {} {
    Photo Album Portlet package uninstall proc
} {
    unregister_implementations

    photo_album_admin_portlet::unregister_implementations
}



ad_proc -private photo_album_portlet::unregister_implementations {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "portal_datasource" \
        -impl_name "photo_album_portlet"
}



ad_proc -private photo_album_admin_portlet::after_install {} {
    Create the datasources needed by the photo album portlet.
} {
    
    db_transaction {
	set ds_id [portal::datasource::new \
                   -name "photo_album_admin_portlet" \
                   -description "Photo Album Admin Portlet"]

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shadeable_p \
            -value f

	portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key hideable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key user_editable_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key shaded_p \
            -value f

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p t \
            -key link_hideable_p \
            -value t

        portal::datasource::set_def_param \
            -datasource_id $ds_id \
            -config_required_p t \
            -configured_p f \
            -key package_id \
            -value ""

	register_portal_datasource_impl
    }
}



ad_proc -private photo_album_admin_portlet::register_portal_datasource_impl {} {
    Create the service contracts needed by the photo-album admin portlet.
} {
    set spec {
        name "photo_album_admin_portlet"
	contract_name "portal_datasource"
	owner "photo-album-portlet"
        aliases {
	    GetMyName photo_album_admin_portlet::get_my_name
	    GetPrettyName  photo_album_admin_portlet::get_pretty_name
	    Link photo_album_admin_portlet::link
	    AddSelfToPage photo_album_admin_portlet::add_self_to_page
	    Show photo_album_admin_portlet::show
	    Edit photo_album_admin_portlet::edit
	    RemoveSelfFromPage photo_album_admin_portlet::remove_self_from_page
        }
    }
    
    acs_sc::impl::new_from_spec -spec $spec
}



ad_proc -private photo_album_admin_portlet::before_uninstall {} {
    Photo Album Portlet package uninstall proc
} {
    unregister_implementations
}



ad_proc -private photo_album_admin_portlet::unregister_implementations {} {
    Unregister service contract implementations
} {
    acs_sc::impl::delete \
        -contract_name "portal_datasource" \
        -impl_name "photo_album_admin_portlet"
}

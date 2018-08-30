ad_library {

    Procedures to support the photo album admin portlet

    @creation-date  17 June 2003
    @author Jeff Davis (davis@xarg.net)
    @cvs-id $Id: photo-album-admin-portlet-procs.tcl,v 1.2 2005/02/24 13:33:24 jeffd Exp $
}

namespace eval photo_album_admin_portlet {}

ad_proc -private photo_album_admin_portlet::get_my_name {
} {
    return "photo_album_admin_portlet"
}



ad_proc -public photo_album_admin_portlet::get_pretty_name {
} {
    return "[_ photo-album-portlet.Administration]"
}



ad_proc -private photo_album_admin_portlet::my_package_key {
} {
    return "photo-album-portlet"
}



ad_proc -public photo_album_admin_portlet::link {
} {
    return ""
}



ad_proc -public photo_album_admin_portlet::add_self_to_page {
    {-portal_id:required}
    {-page_name ""}
    {-package_id:required}
} {
    Adds a photo-album admin PE to the given portal
    
    @param portal_id The page to add self to
    @param package_id The package_id of the photo-album package
    
    @return element_id The new element's id
} {
    return [portal::add_element_parameters \
                -portal_id $portal_id \
                -portlet_name [get_my_name] \
                -key package_id \
                -value $package_id
           ]
}



ad_proc -public photo_album_admin_portlet::remove_self_from_page {
    {-portal_id:required}
} {
    Removes a photo-album admin PE from the given page
} {
    portal::remove_element \
        -portal_id $portal_id \
        -portlet_name [get_my_name]
}



ad_proc -public photo_album_admin_portlet::show {
    cf
} {
    portal::show_proc_helper \
        -package_key [my_package_key] \
        -config_list $cf \
        -template_src "photo-album-admin-portlet"
    
}

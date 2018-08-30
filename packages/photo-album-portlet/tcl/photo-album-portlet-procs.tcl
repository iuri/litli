ad_library {
    Procedures to support the photo-album portlet

    @creation-date  17 June 2003
    @author Jeff Davis (davis@xarg.net)
    @cvs-id $Id: photo-album-portlet-procs.tcl,v 1.2 2005/02/24 13:33:24 jeffd Exp $
}

namespace eval photo_album_portlet {}


ad_proc -private photo_album_portlet::get_my_name {
} {
    return "photo_album_portlet"
}



ad_proc -private photo_album_portlet::my_package_key {
} {
    return "photo-album-portlet"
}



ad_proc -public photo_album_portlet::get_pretty_name {
} {
    return "[_ photo-album-portlet.Photo_Album]"
}



ad_proc -public photo_album_portlet::link {
} {
    return ""
}



ad_proc -public photo_album_portlet::add_self_to_page {
    {-portal_id:required}
    {-package_id:required}
    {-param_action:required}
} {
    Adds a photo-album PE to the given portal.
    
    @param portal_id The page to add self to
    @param package_id The community with the folder
    
    @return element_id The new element's id
} {
    return [portal::add_element_parameters \
                -portal_id $portal_id \
                -portlet_name [get_my_name] \
                -value $package_id \
                -force_region [parameter::get_from_package_key \
                                   -parameter "photo_album_portlet_force_region" \
                                   -package_key [my_package_key]] \
                -pretty_name [get_pretty_name] \
                -param_action $param_action
        ]
}



ad_proc -public photo_album_portlet::remove_self_from_page {
    {-portal_id:required}
    {-package_id:required}
} {
    Removes a photo-album PE from the given page or the package_id of the
    photo-album package from the portlet if there are others remaining
    
    @param portal_id The page to remove self from
    @param package_id
} {
    portal::remove_element_parameters \
        -portal_id $portal_id \
        -portlet_name [get_my_name] \
        -value $package_id
}



ad_proc -public photo_album_portlet::show {
    cf
} {
    portal::show_proc_helper \
        -package_key [my_package_key] \
        -config_list $cf \
        -template_src "photo-album-portlet"
}

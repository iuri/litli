ad_library {
    Photo Album install callbacks

    @creation-date 2004-05-20

    @author Jeff Davis davis@xarg.net
    @cvs-id $Id: photo-album-install-procs.tcl,v 1.1 2004/06/01 19:13:05 jeffd Exp $
}

namespace eval photo_album::install {}

ad_proc -private photo_album::install::package_install {} { 
    package install callback
} {
    photo_album::search::album::register_fts_impl
    photo_album::search::photo::register_fts_impl
}

ad_proc -private photo_album::install::package_uninstall {} { 
    package uninstall callback
} {
    photo_album::search::unregister_implementations
}

ad_proc -private photo_album::install::package_upgrade {
    {-from_version_name:required}
    {-to_version_name:required}
} {
    Package before-upgrade callback
} {
    apm_upgrade_logic \
        -from_version_name $from_version_name \
        -to_version_name $to_version_name \
        -spec {
            5.2.2d1 5.2.2d2 {
                # just need to install the search callback
                photo_album::search::album::register_fts_impl
                photo_album::search::photo::register_fts_impl
            }
        }
}

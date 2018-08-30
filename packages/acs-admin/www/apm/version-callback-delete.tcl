ad_page_contract {

    @author Peter Marklund
    @creation-date 28 January 2003
    @cvs-id $Id: version-callback-delete.tcl,v 1.2.2.1 2015/09/10 08:21:03 gustafn Exp $  
} {
    version_id:naturalnum,notnull    
    type:notnull
}

set package_key [apm_package_key_from_version_id $version_id]
apm_remove_callback_proc -type $type -package_key $package_key

ad_returnredirect "version-callbacks?version_id=$version_id"
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

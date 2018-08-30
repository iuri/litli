ad_page_contract { 
    Enables a version of the package.
    
    @param version_id The package to be processed.
    @author Jon Salz [jsalz@arsdigita.com]
    @creation-date 9 May 2000
    @cvs-id $Id: version-enable.tcl,v 1.4.2.1 2015/09/10 08:21:04 gustafn Exp $
} {
    {version_id:naturalnum,notnull}

}

apm_version_enable -callback apm_dummy_callback $version_id

ad_returnredirect "version-view?version_id=$version_id"

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

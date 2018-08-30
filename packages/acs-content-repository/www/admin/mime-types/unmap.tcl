ad_page_contract {
   
    @author Emmanuelle Raffenne (eraffenne@gmail.com)
    @creation-date 22-feb-2010
    @cvs-id $Id: unmap.tcl,v 1.1.6.3 2016/05/20 19:55:32 gustafn Exp $

} {
    extension:notnull
    mime_type:notnull
    {return_url:localurl ""}
}

if { $return_url eq "" } {
    set return_url "index"
}

db_dml extension_unmap {}

ad_returnredirect $return_url

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

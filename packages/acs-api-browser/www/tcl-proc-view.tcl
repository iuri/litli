ad_page_contract {
    Will redirect you to the server containing the documentation if it can be found
    @cvs-id $Id: tcl-proc-view.tcl,v 1.10.2.6 2017/02/06 12:44:41 gustafn Exp $
} {
    tcl_proc:token,notnull
} -properties {
    title:onevalue
    context:onevalue
    tcl_proc:onevalue
} -validate {
    csrf { csrf::validate }    
}

set url [apidoc::get_doc_url -cmd $tcl_proc \
             -index $::apidoc::ns_api_html_index \
             -root $::apidoc::ns_api_root \
             -host $::apidoc::ns_api_host]

if {$url ne ""} {
    ad_returnredirect -allow_complete_url $url
    ad_script_abort
} 

set title "[ns_info name] Tcl API Search for: \"$tcl_proc\""
set context [list "Tcl API Search: $tcl_proc"]
set doc_url [lindex $::apidoc::ns_api_html_index 0]
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

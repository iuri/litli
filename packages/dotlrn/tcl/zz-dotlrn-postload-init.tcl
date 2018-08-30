#if { [security::https_available_p] } {
#    ad_register_filter preauth GET "[dotlrn::get_url]/admin/*" ad_restrict_to_https
#}
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

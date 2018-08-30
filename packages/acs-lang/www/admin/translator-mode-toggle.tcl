ad_page_contract {
    Toggle translator mode on/off.
    
    @author Lars Pind (lars@collaboraid.biz)
    @creation-date October 24, 2002
    @cvs-id $Id: translator-mode-toggle.tcl,v 1.2.12.3 2016/05/20 19:55:32 gustafn Exp $
} {
    {return_url:localurl "."}
}

lang::util::translator_mode_set [expr {![lang::util::translator_mode_p]}] 

ad_returnredirect $return_url


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

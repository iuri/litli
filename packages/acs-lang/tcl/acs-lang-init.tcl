ad_library {
    Do initialization at server startup for the acs-lang package.

    @creation-date 23 October 2000
    @author Peter Marklund (peter@collaboraid.biz)
    @cvs-id $Id: acs-lang-init.tcl,v 1.9.24.1 2015/09/10 08:21:25 gustafn Exp $
}

# Cache I18N messages in memory for fast lookups
lang::message::cache

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

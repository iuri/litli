ad_library {

    dotlrn-homework notifications

    @creation-date 2002-07-24
    @author Don Baccus (dhogaza@pacifier.com)
    @cvs-id $Id: dotlrn-homework-notifications.tcl,v 1.1.1.1.24.1 2015/09/11 11:40:57 gustafn Exp $

}

namespace eval dotlrn_homework::notification {

   # We don't really use either of these at the moment though this might change
   # in the future ...

    ad_proc -public get_url {
        object_id
    } {

    }

    ad_proc -public process_reply {
        reply_id
    } {
    }

}

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

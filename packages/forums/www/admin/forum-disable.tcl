ad_page_contract {
    
    Disable a Forum

    @author Ben Adida (ben@openforce.net)
    @creation-date 2002-05-28
    @cvs-id $Id: forum-disable.tcl,v 1.7.2.1 2015/09/12 11:06:29 gustafn Exp $

} {
    forum_id:naturalnum,notnull
}

forum::disable -forum_id $forum_id

ad_returnredirect "."




# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

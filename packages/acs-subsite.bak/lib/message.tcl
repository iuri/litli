ad_page_contract {
    This include expects "message" to be set as html
    and if no title is present uses "Message".  Used to inform of actions
    in registration etc.

    @cvs-id $Id: message.tcl,v 1.2.2.1 2015/09/10 08:21:34 gustafn Exp $
}
if {(![info exists title] || $title eq "")} {
    set page_title Message
}
set context [list $title]

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

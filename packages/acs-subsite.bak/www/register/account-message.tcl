ad_page_contract {
    Inform the user of an account status message.
    
    @cvs-id $Id: account-message.tcl,v 1.2.2.3 2016/05/20 20:02:44 gustafn Exp $
} {
    {message:html ""}
    {return_url:localurl ""}
}

set page_title "Logged in"
set context [list $page_title]

set system_name [ad_system_name]


# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

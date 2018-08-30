ad_page_contract {
    
    Create a Forum

    @author Ben Adida (ben@openforce.net)
    @creation-date 2002-05-25
    @cvs-id $Id: forum-new.tcl,v 1.15.14.1 2015/09/12 11:06:29 gustafn Exp $

} -query {
    {name ""}
}

set context [list [_ forums.Create_New_Forum]]

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

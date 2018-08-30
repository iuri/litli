#/chat/www/noactive.tcl
ad_page_contract {
    Display noactive room message.

    @author Agustin Lopez (Agustin.Lopez@uv.es)
    @creation-date October 10, 2004
    @cvs-id $Id: noactive.tcl,v 0.1d 2004/10/10
} -properties {
    context_bar:onevalue
}

set context_bar [list "[_ chat.Unauthorized_privilege]"]

ad_return_template

#/chat/www/unauthorized.tcl
ad_page_contract {
    Display unauthorized message.

    @author David Dao (ddao@arsdigita.com)
    @creation-date November 24, 2000.
    @cvs-id $Id: unauthorized.tcl,v 1.3 2006/03/14 12:16:09 emmar Exp $
} -properties {
    context_bar:onevalue
}

set context_bar [list "[_ chat.Unauthorized_privilege]"]

ad_return_template
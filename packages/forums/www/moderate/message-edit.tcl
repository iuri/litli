ad_page_contract {
    
    Form to edit a message

    @author Ben Adida (ben@openforce.net)
    @creation-date 2002-05-25
    @cvs-id $Id: message-edit.tcl,v 1.9.2.2 2016/05/20 20:38:58 gustafn Exp $

} {
    message_id:naturalnum,notnull
    {return_url:localurl "../message-view"}
}

forum::message::get -message_id $message_id -array message
forum::get -forum_id $message(forum_id) -array forum

ad_return_template

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:

#/chat/www/chat.tcl
ad_page_contract {

    Decide which template to use HTML or AJAX.

    @author David Dao (ddao@arsdigita.com)
    @creation-date November 22, 2000
    @cvs-id $Id: chat.tcl,v 1.13.4.2 2016/11/22 18:34:35 antoniop Exp $
} {
    room_id:naturalnum,notnull
    {client "ajax"}
    {message:html ""}
} -properties {
    context:onevalue
    user_id:onevalue
    user_name:onevalue
    message:onevalue
    room_id:onevalue
    room_name:onevalue 
    width:onevalue
    height:onevalue
    host:onevalue
    port:onevalue
    moderator_p:onevalue
    msgs:multirow
}

if { [catch {set room_name [chat_room_name $room_id]} errmsg] } {
    ad_return_complaint 1 "[_ chat.Room_not_found]"
    ad_script_abort
}

set doc(title) $room_name
set doc(type) {<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">}

set context [list $doc(title)]

auth::require_login
set user_id [ad_conn user_id]
set read_p  [permission::permission_p -object_id $room_id -privilege "chat_read"]
set write_p [permission::permission_p -object_id $room_id -privilege "chat_write"]
set ban_p   [permission::permission_p -object_id $room_id -privilege "chat_ban"]
set moderate_room_p [chat_room_moderate_p $room_id]

if { $moderate_room_p == "t" } {
    set moderator_p [permission::permission_p -object_id $room_id -privilege "chat_moderator"]
} else {
    # This is an unmoderate room, therefore everyone is a moderator.
    set moderator_p "1"
}

if { ($read_p == 0 && $write_p == 0) || ($ban_p == 1) } {
    #Display unauthorize privilege page.
    ad_returnredirect unauthorized
    ad_script_abort
}

# Get chat screen name.
set user_name [chat_user_name $user_id]

# Determine which template to use for html or ajax client
switch $client {
    "html" {
        set template_use "html-chat"
        # forward to ajax if necessary
        if { $message ne "" } {
            set session_id [ad_conn session_id]
            ::chat::Chat c1 -volatile -chat_id $room_id -session_id $session_id
            c1 add_msg $message
        }
    }
    "ajax" {
        set template_use "ajax-chat-script"
    }
}

ad_return_template $template_use


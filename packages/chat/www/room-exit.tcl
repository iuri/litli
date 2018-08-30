#/chat/www/room-exit.tcl
ad_page_contract {
    Post log off message.

    @author David Dao (ddao@arsdigita.com)
    @creation-date November 25, 2000
    @cvs-id $Id: room-exit.tcl,v 1.5.6.2 2016/10/28 18:57:36 antoniop Exp $
} {
    room_id:naturalnum,notnull
}

set user_id [ad_conn user_id]
set read_p [permission::permission_p -object_id $room_id -privilege "chat_read"]
set write_p [permission::permission_p -object_id $room_id -privilege "chat_write"]
set ban_p [permission::permission_p -object_id $room_id -privilege "chat_ban"]

if { ($read_p == 0 && $write_p == 0) || ($ban_p == 1) } {
    #Display unauthorize privilege page.
    ad_returnredirect unauthorized
    ad_script_abort
}

# apisano: I don't think this code should be here anymore, as
# message about user leaving the room is already issued by
# the parent chat class in xotcl-core when we issue the logout
# method	
# chat_message_post $room_id $user_id "[_ chat.has_left_the_room]." "1"

# send to AJAX
set session_id [ad_conn session_id]
::chat::Chat c1 -volatile -chat_id $room_id -session_id $session_id
c1 logout

ad_returnredirect index
#ad_returnredirect [dotlrn::get_url]

#/chat/www/room-delete-2.tcl
ad_page_contract {
    Delete the chat room.

    @author David Dao (ddao@arsdigita.com)
    @creation-date November 16, 2000
    @cvs-id $Id: room-delete-2.tcl,v 1.5.6.2 2017/06/09 17:47:19 antoniop Exp $
} {
    room_id:naturalnum,notnull
}

permission::require_permission -object_id $room_id -privilege chat_room_delete

if { [catch {chat_room_delete $room_id} errmsg] } {
    ad_return_complaint 1 "[_ chat.Delete_room_failed]: $errmsg"
    ad_script_abort
}

ad_returnredirect . 





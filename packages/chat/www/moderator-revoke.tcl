#/chat/www/moderator-revoke.tcl
ad_page_contract {

    Display confirmation before remove moderator privilege from a room.

    @author David Dao (ddao@arsdigita.com)
    @creation-date November 22, 2000
    @cvs-id $Id: moderator-revoke.tcl,v 1.3.12.1 2016/06/20 08:40:23 gustafn Exp $
} {
    room_id:naturalnum,notnull
    party_id:naturalnum,notnull
}

permission::require_permission -object_id $room_id -privilege chat_moderator_revoke

set context_bar [list [list "room?room_id=$room_id" "[_ chat.Room_Information]"] "[_ chat.Revoke_moderator]"]

set party_pretty_name [db_string get_party_name {}]

set pretty_name [chat_room_name $room_id]

ad_return_template
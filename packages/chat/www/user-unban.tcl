#/chat/www/user-unban.tcl
ad_page_contract {
    
    Display confirmation before unban user.

    @author David Dao (ddao@arsdigita.com)
    @creation-date November 22, 2000
    @cvs-id $Id: user-unban.tcl,v 1.3.12.1 2016/06/20 08:40:23 gustafn Exp $
} {
    room_id:naturalnum,notnull
    party_id:naturalnum,notnull
}

permission::require_permission -object_id $room_id -privilege chat_user_unban

set context_bar [list [list "room?room_id=$room_id" "[_ chat.Room_Information]"] "[_ chat.Unban_user]"]

set party_pretty_name [db_string get_party_name {}]


set pretty_name [chat_room_name $room_id]

ad_return_template
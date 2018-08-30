#/chat/www/moderator-grant.tcl
ad_page_contract {

    Add moderator to a room.
    @author David Dao (ddao@arsdigita.com)
    @creation-date November 16, 2000
    @cvs-id $Id: moderator-grant.tcl,v 1.3.12.1 2016/06/20 08:40:23 gustafn Exp $
} {
    room_id:naturalnum,notnull
} -properties {
    context_bar:onevalue
    title:onevalue
    action:onevalue
    submit_label:onevalue
    room_id:onevalue
    description:onevalue
    parties:multirow
}

permission::require_permission -object_id $room_id -privilege chat_moderator_grant

set context_bar [list "[_ chat.Grant_moderator]"]
set submit_label "[_ chat.Grant]"
set title "[_ chat.Grant_moderator]"
set action "moderator-grant-2"
set description "[_ chat.Grant_moderator_for] <b>[chat_room_name $room_id]</b> [_ chat.to]"
db_multirow parties list_parties {}

ad_return_template grant-entry


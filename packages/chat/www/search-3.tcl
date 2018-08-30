ad_page_contract {

} {
    type:notnull
    room_id:naturalnum,notnull
    party_id:naturalnum,notnull
}

if {$type eq "user"} {
  permission::require_permission -object_id $room_id -privilege chat_user_grant
  chat_user_grant $room_id $party_id
} else {
  permission::require_permission -object_id $room_id -privilege chat_user_ban
  chat_user_ban $room_id $party_id
}
ad_returnredirect "room?room_id=$room_id"


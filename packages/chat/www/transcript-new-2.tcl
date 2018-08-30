#/chat/www/transcript-new-2.tcl
ad_page_contract {
    Save transcript.
} {
    room_id:naturalnum,notnull
    transcript_name:trim,notnull
    {description:trim ""}
    {delete_messages:optional "off"}
    {deactivate_room:optional "off"}
    contents:trim,notnull,html
} 

permission::require_permission -object_id $room_id -privilege chat_transcript_create

set package_id [ad_conn package_id]
set user_id [ad_conn user_id]
set creation_ip [ad_conn peeraddr]

set transcript_id [chat_transcript_new \
    -description $description \
    -context_id $package_id \
    -creation_user $user_id \
    -creation_ip $creation_ip \
    $transcript_name $contents $room_id
]

if { $delete_messages eq "on" } {
    chat_room_message_delete $room_id
    # forward the information to AJAX
    ::chat::Chat flush_messages -chat_id $room_id
}

if { $deactivate_room eq "on" } {
    db_dml "update_chat" "update chat_rooms set active_p = 'f' where room_id = $room_id"
}

ad_returnredirect "chat-transcript?room_id=$room_id&transcript_id=$transcript_id"


#/chat/www/transcript-delete-2.tcl
ad_page_contract {
    Delete chat transcript.
} {
    room_id:naturalnum,notnull
    transcript_id:naturalnum,notnull
    
}

permission::require_permission -object_id $transcript_id -privilege chat_transcript_delete



if { [catch {chat_transcript_delete $transcript_id} errmsg] } {
    ad_return_complaint 1 "[_ chat.Delete_transcript_failed]: $errmsg"
    ad_script_abort
}

ad_returnredirect "room?room_id=$room_id"

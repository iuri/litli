
db_1row get_transcript {
    select pretty_name as transcript_name,
           description,
           contents,
           room_id
    from chat_transcripts
    where transcript_id=:transcript_id
}

set edit_p [permission::permission_p -object_id $room_id -privilege "chat_transcript_edit"]

set edit_url [export_vars -base "transcript-edit" {transcript_id room_id}]

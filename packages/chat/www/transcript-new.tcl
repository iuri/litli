#/chat/www/transcript-new.tcl
ad_page_contract {
    Display available all available chat messages.
} {
    room_id:naturalnum,notnull
} -properties {
    context_bar:onevalue
    title:onevalue
    action:onevalue
    room_id:onevalue
    transcript_id:onevalue
    transcript_name:onevalue
    description:onevalue
    contents:onevalue
}

permission::require_permission -object_id $room_id -privilege chat_transcript_create

set title "[_ chat.Create_transcript]"
set context [list [list "room?room_id=$room_id" "[_ chat.Room_Information]"] $title]

set transcript_id ""
set transcript_name "[_ chat.transcript_of_date] [clock format [clock seconds] -format "%d.%m.%y %H:%M:%S"]"
set description ""
set contents ""
set action "transcript-new-2"
set submit_label "[_ chat.Create_transcript]"
set active_p [room_active_status $room_id]

#Build a list of all message.
db_foreach get_archives_messages {} {
    append contents "\[$creation_date\] <b>[chat_user_name $creation_user]</b>: $msg<br>\n"
}

ad_return_template "transcript-entry"


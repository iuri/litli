ad_page_contract {

    Show available chat transcripts

    @author Peter Alberer (peter@alberer.com)
    @creation-date March 26, 2006
} {
    room_id:naturalnum,notnull
} 

if { [catch {set room_name [chat_room_name $room_id]} errmsg] } {
    ad_return_complaint 1 "[_ chat.Room_not_found]"
    ad_script_abort
}

set active [room_active_status $room_id]


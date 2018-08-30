ad_page_contract {
    mostra mensagens do chat arquivadas
} {
   room_id:naturalnum,notnull
   {transcript_id:naturalnum,optional 0}
} 

set page_title "[_ chat.Transcript]"   
set context [list $page_title]
set user_id [ad_conn user_id]

set read_p  [permission::permission_p -object_id $room_id -privilege "chat_read"]
set write_p [permission::permission_p -object_id $room_id -privilege "chat_write"]
set ban_p   [permission::permission_p -object_id $room_id -privilege "chat_ban"]

if { ($read_p == 0 && $write_p == 0) || ($ban_p == 1) } {
    #Display unauthorize privilege page.
    ad_returnredirect unauthorized
    ad_script_abort
}   

if { [catch {set room_name [chat_room_name $room_id]} errmsg] } {
    ad_return_complaint 1 "[_ chat.Room_not_found]"
}

template::head::add_style -style "#messages { 
    border: 1px dotted black; 
    padding: 5px;
    margin-top:10px; 
    font-size: 12px; 
    color: #666666; 
    font-family: Trebuchet MS, Lucida Grande, Lucida Sans Unicode, Arial, sans-serif; 
}
#messages .timestamp {vertical-align: top; color: #CCCCCC; }
#messages .user {text-align: right; vertical-align: top; font-weight:bold; }
#messages .message {vertical-align: top}
#messages .line {margin:0px;}"

ad_return_template

ad_page_contract {
    mostra mensagens do chat
} {
   page:optional
}   -properties {
    room_id:onevalue
}
   
set user_id [ad_conn user_id]
set read_p  [permission::permission_p -object_id $room_id -privilege "chat_read"]
set write_p [permission::permission_p -object_id $room_id -privilege "chat_write"]
set ban_p   [permission::permission_p -object_id $room_id -privilege "chat_ban"]
set active  [room_active_status $room_id]

# get the "rich" client settings
set richclient(short) [parameter::get -parameter "DefaultClient"]
set richclient(msg) "[_ chat.${richclient(short)}_client_msg]"
set richclient(title) "[_ chat.[string totitle $richclient(short)]]"

if { ($read_p == 0 && $write_p == 0) || ($ban_p == 1) || ($active == "f") } {
    #Display unauthorize privilege page.
    ad_returnredirect unauthorized
    ad_script_abort
}

if { [catch {set room_name [chat_room_name $room_id]} errmsg] } {
    ad_return_complaint 1 "[_ chat.Room_not_found]"
    ad_script_abort
}

::chat::Chat c1 -volatile -encoder noencode -chat_id $room_id
set html_chat [c1 get_all]
set html_users [c1 get_users]

template::head::add_style -style "#messages { margin-right:15px; float:left; width:70%; height:250px; overflow:auto; border:1px solid black; padding:5px; font-size: 12px; color: #666666; font-family: Trebuchet MS, Lucida Grande, Lucida Sans Unicode, Arial, sans-serif; }
#messages .timestamp {vertical-align: top; color: #CCCCCC; }
#messages .user {margin: 0px 5px; text-align: right; vertical-align: top; font-weight:bold;}
#messages .message {vertical-align: top;}
#messages .line {margin:0px;}
#users { float:right; width:25%; height:250px; border:1px solid black; padding:5px; font-size: 12px; color: #666666; font-family: Trebuchet MS, Lucida Grande, Lucida Sans Unicode, Arial, sans-serif; }
#users .user {text-align: left; vertical-align: top; font-weight:bold; }
#users .timestamp {text-align: right; vertical-align: top; }
"

set room_enter_url [export_vars -base "room-enter" {room_id {client $richclient(short)}}]

ad_return_template

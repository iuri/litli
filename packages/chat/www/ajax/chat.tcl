ad_page_contract {
  a tiny chat client

  @author Gustaf Neumann (gustaf.neumann@wu-wien.ac.at)
  @creation-date Jan 31, 2006
  @cvs-id $Id: chat.tcl,v 1.4.6.1 2016/11/22 18:34:35 antoniop Exp $
} -query {
  m
  id
  s
  {msg:optional,allhtml ""}
}

set ban_p [permission::permission_p -object_id $id -privilege "chat_ban"]
if {$ban_p} {
  ns_return 200 text/html "
   <HTML>
     <BODY>\
       <div id='messages'>[_ chat.You_dont_have_permission_room]</div>\
     </BODY>
   </HTML>"
  ad_script_abort
}

set message_output ""
set user_output "-"

::chat::Chat c1 -volatile -chat_id $id -session_id $s

switch -- $m {
  add_msg {
      set message_output [c1 add_msg $msg]
  }
  login - get_new - get_all {
      set message_output [c1 $m]
  }
  get_updates {
      set message_output [c1 get_new]
      set user_output [c1 get_users]
  }
  get_users {
      c1 encoder noencode
      set user_output [c1 get_users]
  }
  default {
      ns_log error "--c unknown method $m called."
  }
}

set output "
<HTML>
<style type='text/css'>
#messages { font-size: 12px; color: #666666; font-family: Trebuchet MS, Lucida Grande, Lucida Sans Unicode, Arial, sans-serif; }
#messages .timestamp {vertical-align: top; color: #CCCCCC; }
#messages .user {margin: 0px 5px; text-align: right; vertical-align: top; font-weight:bold;}
#messages .message {vertical-align: top;}
#messages .line {margin:0px;}
#users { width: 100%; font-size: 12px; color: #666666; font-family: Trebuchet MS, Lucida Grande, Lucida Sans Unicode, Arial, sans-serif; }
#users .user {text-align: left; vertical-align: top; font-weight:bold; }
#users .timestamp {text-align: right; vertical-align: top; }
</style>
<body style='margin:0px; padding:5px;'>"

if { $message_output ne "" } {
    append output "<div id='messages'>$message_output</div>\n"
}

if { $user_output ne "-" } {
    append output "<table id='users'><tbody>$user_output</tbody></table>\n"
}

append output "
</body>
</HTML>"

ns_return 200 text/html $output

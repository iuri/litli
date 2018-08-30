ad_library {
    chat - chat procs

    @creation-date 2006-02-02
    @author Gustaf Neumann
    @author Peter Alberer
    @cvs-id $Id: chat-ajax-procs.tcl,v 1.12.2.8 2017/04/21 20:21:49 gustafn Exp $
}

namespace eval ::chat {
    ::xo::ChatClass Chat -superclass ::xo::Chat

    Chat instproc init {} {
	:instvar chat_id
	if {[chat_room_exists_p $chat_id]} {
	    chat_room_get -room_id $chat_id -array c
	    set :login_messages_p  $c(login_messages_p)
	    set :logout_messages_p $c(logout_messages_p)
	    set :timewindow        $c(messages_time_window)
	}
	next
    }

  Chat instproc render {} {
    my orderby time
    set result ""
    foreach child [my children] {
      set msg       [$child msg]
      set user_id   [$child user_id]
      set color     [$child color]
      set timelong  [clock format [$child time]]
      set timeshort [clock format [$child time] -format {[%H:%M:%S]}]
      set userlink  [my user_link -user_id $user_id -color $color]
      append result "
        <p class='line'>
          <span class='timestamp'>$timeshort</span>
	  <span class='user'>$userlink:</span>
	  <span class='message'>[my encode $msg]</span>
        </p>\n"
    }
    return $result
  }

  Chat proc login {-chat_id -package_id} {
      auth::require_login
      if {![info exists package_id]} {
          set package_id [ad_conn package_id]
      }
      if {![info exists chat_id]} {
          set chat_id $package_id
      }

      set context "id=$chat_id&s=[ad_conn session_id].[clock seconds]"
      set jspath "packages/chat/www/ajax/chat.js"

      if { ![file exists [acs_root_dir]/$jspath] } {
          return -code error "File [acs_root_dir]/$jspath does not exist"
      }
      set file [open [acs_root_dir]/$jspath]; set js [read $file]; close $file

      set path      [lindex [site_node::get_url_from_object_id -object_id $package_id] 0]
      set login_url [ns_quotehtml "${path}ajax/chat?m=login&$context"]
      set send_url  "${path}ajax/chat?m=add_msg&$context&msg="
      set users_url [ns_quotehtml "${path}ajax/chat?m=get_users&$context"]
      set html_url [ns_quotehtml [ad_conn url]?[ad_conn query]]
      regsub {client=ajax} $html_url {client=html} html_url

      return "\
      <script type='text/javascript' nonce='$::__csp_nonce'>
      $js
      // register the data sources (for sending messages, receiving updates)
      var pushMessage = registerDataConnection(pushReceiver, '$path/ajax/chat?m=get_new&$context', false);
      var pullUpdates = registerDataConnection(updateReceiver, '$path/ajax/chat?m=get_updates&$context', true);
      </script>
      <form id='ichat_form' name='ichat_form' action='#'>
      <iframe name='ichat' id='ichat' title='#chat.Conversation_area#'
          frameborder='0' src='$login_url'
          style='width:70%; border:1px solid black; margin-right:15px;' height='257'>
      </iframe>
      <iframe name='ichat-users' id='ichat-users' title='#chat.Participants_list#'
          frameborder='0' src='$users_url'
          style='width:25%; border:1px solid black;' height='257'>
      </iframe>
      <noframes>
        <p>#chat.Your_browser_doesnt_support_#</p>
        <p><a href='$html_url'>#chat.Go_to_html_version#</a></p>
      </noframes>
      <div style='margin-top:10px;'>
      #chat.message# <input tabindex='1' type='text' size='80' name='msg' id='chatMsg'>
      <input type='submit' value='#chat.Send_Refresh#'>
      </div>
      </form>

      <script type='text/javascript' nonce='$::__csp_nonce'>
      // Get a first update of users when the iframe is ready, then register a 5s interval to get new ones
      document.getElementById('ichat-users').addEventListener('load', function (event) {
          updateDataConnections();
      }, false);
      document.getElementById('ichat_form').addEventListener('submit', function (event) {
          event.preventDefault();
          pushMessage.chatSendMsg(\"$send_url\");
      }, false);
      var updateInterval = setInterval(updateDataConnections,5000);
      </script>
    "
  }

    # if chat doesn't exist anymore, send a message that will inform
    # the user of being looking at an invalid chat
    Chat instproc check_valid_room {} {
	if {![chat_room_exists_p [:chat_id]]} {
	    ns_return 500 text/plain "chat-errmsg: [_ chat.Room_not_found]"
	    ad_script_abort
	}
    }

    Chat instproc get_new {} {
	:check_valid_room
	next
    }

    Chat instproc add_msg {
	{-get_new:boolean true}
	{-uid ""}
	msg
    } {
	if {![chat_room_exists_p [:chat_id]]} {
	    return
	}

	# ignore empty messages
	if {$msg eq ""} return

	# code around expects the return value of the original method
	set retval [next]

	# This way messages can be persisted immediately every time a
	# message is sent
	if {[:current_message_valid]} {
	    chat_message_post [:chat_id] [:user_id] $msg 1
	}

	return $retval
    }
}

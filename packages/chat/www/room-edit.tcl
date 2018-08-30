#/chat/www/room-edit.tcl
ad_page_contract {
    Display a form to edit room information.

    @author Peter Alberer (peter@alberer.com)
    @creation-date March 26, 2006
} {
    room_id:naturalnum,optional
}

permission::require_permission -object_id [ad_conn package_id] -privilege chat_room_edit

if { ![info exists room_id] } {
    set title "[_ chat.Create_a_new_room]"
} else {
    set title "[_ chat.Edit_room]"
}

set context [list $title]

set four_hours [expr {60 * 60 * 4}]

ad_form -name "edit-room" -edit_buttons [list [list [_ chat.Update_room] next]] -has_edit 1 -form {
    {room_id:key}
    {moderated_p:boolean(hidden)
        {value "f"}
    }
    {pretty_name:text(text)
        {label "#chat.Room_name#" }
    }
    {description:text(textarea),optional
        {label "#chat.Description#" }
        {html {rows 6 cols 65}}
    }
    {active_p:boolean(radio)
        {label "#chat.Active#" }
        {options {{"#acs-kernel.common_Yes#" t} {"#acs-kernel.common_no#" f}}}
        {value "t"}
    }
    {archive_p:boolean(radio)
        {label "#chat.Archive#" }
        {options {{"#acs-kernel.common_Yes#" t} {"#acs-kernel.common_no#" f}}}
        {value "t"}
    }
    {auto_flush_p:boolean(radio)
        {label "#chat.AutoFlush#" }
        {options {{"#acs-kernel.common_Yes#" t} {"#acs-kernel.common_no#" f}}}
        {value "t"}
        {help_text "[_ chat.AutoFlushHelp]"}
    }
    {auto_transcript_p:boolean(radio)
        {label "#chat.AutoTranscript#" }
        {options {{"#acs-kernel.common_Yes#" t} {"#acs-kernel.common_no#" f}}}
        {value "f"}
        {help_text "[_ chat.AutoTranscriptHelp]"}
    }
    {login_messages_p:boolean(radio)
        {label "#chat.LoginMessages#" }
        {options {{"#acs-kernel.common_Yes#" t} {"#acs-kernel.common_no#" f}}}
        {value "f"}
        {help_text "[_ chat.LoginMessagesHelp]"}
    }
    {logout_messages_p:boolean(radio)
        {label "#chat.LogoutMessages#" }
        {options {{"#acs-kernel.common_Yes#" t} {"#acs-kernel.common_no#" f}}}
        {value "f"}
        {help_text "[_ chat.LogoutMessagesHelp]"}
    }
    {messages_time_window:integer
        {label "#chat.MessagesTimeWindow#" }
        {help_text "[_ chat.MessagesTimeWindowHelp]"}
	{value "$four_hours"}
    }

} -new_data {
    if {[catch {
	set room_id [chat_room_new \
			 -moderated_p          $moderated_p \
			 -description          $description \
			 -active_p             $active_p \
			 -archive_p            $archive_p \
			 -auto_flush_p         $auto_flush_p \
			 -auto_transcript_p    $auto_transcript_p \
			 -login_messages_p     $login_messages_p \
			 -logout_messages_p    $logout_messages_p \
			 -messages_time_window $messages_time_window \
			 -context_id           [ad_conn package_id] \
			 -creation_user        [ad_conn user_id] \
			 -creation_ip          [ad_conn peeraddr] $pretty_name]
    } errmsg]} {
        ad_return_complaint 1 "[_ chat.Create_new_room_failed]: $errmsg"
        break
    }
    set comm_id ""
    if {[info commands dotlrn_community::get_community_id] ne ""} {
	set comm_id [dotlrn_community::get_community_id]
    }
    if {$comm_id ne ""} {
	chat_user_grant $room_id $comm_id
    } else {
	#-2 Registered Users
	#chat_user_grant $room_id -2
	#0 Unregistered Visitor
	#chat_user_grant $room_id 0
	#-1 The Public
	chat_user_grant $room_id -2
    }
} -edit_request {
    if {[catch {
	chat_room_get -room_id $room_id -array r
	set pretty_name          $r(pretty_name)
	set description          $r(description)
	set moderated_p          $r(moderated_p)
	set archive_p            $r(archive_p)
	set auto_flush_p         $r(auto_flush_p)
	set auto_transcript_p    $r(auto_transcript_p)
	set login_messages_p     $r(login_messages_p)
	set logout_messages_p    $r(logout_messages_p)
	set messages_time_window $r(messages_time_window)
    } errmsg]} {
	ad_return_complaint 1 "[_ chat.Room_not_found]."
        break
    }
} -edit_data {
    if {[catch {
	chat_room_edit \
	    $room_id \
	    $pretty_name \
	    $description \
	    $moderated_p \
	    $active_p \
	    $archive_p \
	    $auto_flush_p \
	    $auto_transcript_p \
	    $login_messages_p \
	    $logout_messages_p \
	    $messages_time_window
    } errmsg]} {
        ad_return_complaint 1 "[_ chat.Could_not_update_room]: $errmsg"
        break
    }
} -after_submit {
    ad_returnredirect "room?room_id=$room_id"
    ad_script_abort
}

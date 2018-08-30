#/chat/www/transcript-edit.tcl
ad_page_contract {
    Retrieve transcript content.

    @author David Dao (ddao@arsdigita.com)
    @creation-date November 28, 2000
    @cvs-id $Id: transcript-edit.tcl,v 1.6.6.2 2017/06/09 17:47:19 antoniop Exp $
} {
    transcript_id:naturalnum,notnull
    room_id:naturalnum,notnull
} 

permission::require_permission -object_id $transcript_id -privilege chat_transcript_edit
set context_bar [list "[_ chat.Edit_transcript]"]

set submit_label "[_ chat.Edit]"
set active_p [room_active_status $room_id]

db_1row get_transcript_info {
    select pretty_name, description, contents
    from chat_transcripts
    where transcript_id = :transcript_id
}

ad_form -name "edit-transcription" -edit_buttons [list [list [_ chat.Edit] next]] -has_edit 1 -form {
    {room_id:integer(hidden)
        {value $room_id}
    }    
    {transcript_id:integer(hidden)
        {value $transcript_id}
    }    
    {pretty_name:text(text)
        {label "#chat.Transcript_name#" }
        {value $pretty_name}
    }
    {description:text(textarea),optional
        {label "#chat.Description#" }
        {html {rows 6 cols 65}}
        {value $description}
    }
    {contents:text(textarea)
        {label "#chat.Transcript#" }
        {html {rows 6 cols 65}}
        {value $contents}
    }
} -on_submit {
    if { [catch {chat_transcript_edit $transcript_id $pretty_name $description $contents} errmsg] } {
        ad_return_complaint 1 "[_ chat.Could_not_update_transcript]: $errmsg"
        ad_script_abort
    }
    ad_returnredirect "chat-transcript?transcript_id=$transcript_id&room_id=$room_id"    
}

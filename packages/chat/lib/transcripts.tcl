
set transcript_create_p [permission::permission_p -object_id $room_id -privilege chat_transcript_create]
set transcript_delete_p [permission::permission_p -object_id $room_id -privilege chat_transcript_delete]
set transcript_view_p   [permission::permission_p -object_id $room_id -privilege chat_transcript_view]

# List available chat transcript
db_multirow -extend {
    creation_date_pretty
    viewer
    transcript_url
    delete_url
} chat_transcripts list_transcripts {} {
    set creation_date_pretty [lc_time_fmt $creation_date "%q %X"]
    set transcript_url [export_vars -base "chat-transcript" {room_id transcript_id}]
    set delete_url [export_vars -base "transcript-delete" {room_id transcript_id}]
}

set actions {}
if {$transcript_create_p} {
    lappend actions \
	[_ chat.Create_transcript] [export_vars -base "transcript-new" {room_id}] ""
}

list::create \
    -name "chat_transcripts" \
    -multirow "chat_transcripts" \
    -key transcript_id \
    -pass_properties { transcript_delete_p room_id } \
    -row_pretty_plural [_ chat.Transcripts] \
    -actions $actions \
    -elements {
        pretty_name {
            label "#chat.Name#"
            link_url_col transcript_url
            link_html {title "[_ chat.View_transcript]"}
        }
        creation_date_pretty {
            label "#chat.creation_date#"
        }
        actions {
            label "#chat.actions#"
            html { align "center" }
            display_template {
                <if @transcript_delete_p@ eq "1">
                  <a href="@chat_transcripts.delete_url@">
                    <img src="/shared/images/Delete16.gif" alt="#chat.Delete_transcript#">
                  </a>
                </if>
            }
        }
    }

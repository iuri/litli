<master>
<property name="context">#chat.Transcripts#</property>
<property name="doc(title)">#chat.transcripts_of_room# "@room_name;noquote@"</property>

<if @active@ eq "t">
<p><a class="button" href="chat-transcript?room_id=@room_id@">#chat.current_transcript#</a></p>
</if>
<else>
<br>
</else>

<include src="/packages/chat/lib/transcripts" room_id=@room_id@>

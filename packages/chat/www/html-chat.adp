<master>
<property name="context">@context;literal@</property>
<property name="&doc">doc</property>

<h1>@doc.title@</h1>
<p>
<a href="room-exit?room_id=@room_id@" class=button title="#chat.exit_msg#">#chat.Log_off#</a>
<a href="chat-transcript?room_id=@room_id@" class=button title="#chat.transcription_msg#" >#chat.Transcript#</a>
<a href="@room_enter_url@" class=button title="@richclient.msg@" >@richclient.title@</a>
</p>

<div id='messages'>
@html_chat;noquote@
<a id="xj220" name="#xj220"></a>
</div>

<div id='users'>
    <table width="100%"><tbody>@html_users;noquote@</tbody></table>
</div>

<br clear="all"><br>

<form method=post action="chat#xj220">
#chat.message#: <input tabindex='1' type='text' size='80' name='message' id='chatMsg'>
<input type="hidden" name="room_id" value="@room_id@">
<input type="hidden" name="client" value="html">
<input type="submit" value="#chat.Send_Refresh#">
<input type="submit" value="#chat.Refresh#">
</form>


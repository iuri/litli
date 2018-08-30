<!--
     Display detail information about available room.

     @author David Dao (ddao@arsdigita.com)
     @creation-date November 13, 2000
     @cvs-id $Id: room.adp,v 1.9.4.4 2017/01/18 18:24:23 gustafn Exp $
-->
<master>
<property name="context">@context_bar;literal@</property>
<property name="doc(title)">#chat.Room_Information#</property>

<h1>#chat.Room_Information#</h1>
<if @room_view_p;literal@ true>
<table border="0" cellpadding="2" cellspacing="2">
    <tr class="form-element">
        <td class="form-label">#chat.Room_name#</td>
        <td>@pretty_name@</td>
    </tr>
    <tr class="form-element">
        <td class="form-label">#chat.Description#</td>
        <td>@description@</td>
    </tr>
    <tr class="form-element">
        <td class="form-label">#chat.Active#</td>
        <td>@active_p@</td>
    </tr>
    <tr class="form-element">
        <td class="form-label">#chat.Archive#</td>
        <td>@archive_p@</td>
    </tr>   
    <tr class="form-element">
        <td class="form-label">#chat.AutoFlush#</td>
        <td>@auto_flush_p@</td>
    </tr>  
    <tr class="form-element">
        <td class="form-label">#chat.AutoTranscript#</td>
        <td>@auto_transcript_p@</td>
    </tr>
    <tr class="form-element">
        <td class="form-label">#chat.LoginMessages#</td>
        <td>@login_messages_p@</td>
    </tr>          
    <tr class="form-element">
        <td class="form-label">#chat.LogoutMessages#</td>
        <td>@logout_messages_p@</td>
    </tr>          
    <tr class="form-element">
        <td class="form-label">#chat.MessagesTimeWindow#</td>
        <td>@messages_time_window@</td>
    </tr>
    <tr class="form-element">
        <td class="form-label">#chat.message_count#</td>
        <td>@message_count@</td>
    </tr>
</table>
<if @room_edit_p;literal@ true>
  <a class="button" href="room-edit?room_id=@room_id@">#chat.Edit#</a>
  <a class="button" href="/permissions/one?object_id=@room_id@">#acs-kernel.common_Permissions#</a>
</if>
<if @room_delete_p;literal@ true>
  <a class="button" href="message-delete?room_id=@room_id@">#chat.Delete_all_messages_in_the_room#</a>
  <a class="button" href="room-delete?room_id=@room_id@">#chat.Delete_room#</a>
</if>
</if>
<else>
  <p><em>#chat.No_information_available#</em></p>
</else>

<h2>#chat.Users_ban#</h2>
<listtemplate name="banned_users"></listtemplate>
   
<h2>#chat.Transcripts#</h2>
<if @transcript_create_p;literal@ true>
<include src="/packages/chat/lib/transcripts" room_id=@room_id@>
</if>

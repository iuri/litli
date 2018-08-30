<!--
    Display confirmation for delete chat messages in the room.

    @author David Dao (ddao@arsdigita.com)
    @creation-date January 18, 2001
    @cvs-id $Id: message-delete.adp,v 1.10.2.1 2016/06/20 08:40:23 gustafn Exp $
-->
<master>
<property name="context">@context_bar;literal@</property>
<property name="doc(title)">#chat.Confirm_message_delete#</property>

<form method="post" action="message-delete-2">
<div><input type="hidden" name="room_id" value="@room_id@"></div>
<p>#chat.Are_you_sure_you_want_to_delete# @message_count@ #chat.messages_in# @pretty_name@?</p>
<div><input type="submit" value="#acs-kernel.common_Yes#"></div>
</form>

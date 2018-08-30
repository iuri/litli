<!--
    Display confirmation.

    @author David Dao (ddao@arsdigita.com)
    @creation-date November 22, 2000
    @cvs-id $Id: user-unban.adp,v 1.6.2.1 2016/06/20 08:40:23 gustafn Exp $
-->
<master>
<property name="context">@context_bar;literal@</property>
<property name="doc(title)">#chat.Confirm_unban_user#</property>

<form method=post action=user-unban-2>       
<input type="hidden" name="room_id" value="@room_id@">
<input type="hidden" name="party_id" value="@party_id@">
#chat.Are_you_sure_you_want_to_unban#  <strong>@party_pretty_name@</strong> #chat.from# @pretty_name@?
<p><input type="submit" value="#chat.Unban#">
 
</form>

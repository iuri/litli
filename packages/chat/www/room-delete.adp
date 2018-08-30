<!--
    Display confirmation for deleting chat room.

    @author David Dao (ddao@arsdigita.com)
    @creation-date November 22, 2000
    @cvs-id $Id: room-delete.adp,v 1.9.2.1 2016/06/20 08:40:23 gustafn Exp $
-->
<master>
<property name="context">@context_bar;literal@</property>
<property name="doc(title)">#chat.Confirm_room_delete#</property>

<form method="post" action="room-delete-2">	
<div><input type="hidden" name="room_id" value="@room_id@"></div>
<p>#chat.Are_you_sure_you_want_to_delete# @pretty_name@?</p>
<div><input type="submit" value="#acs-kernel.common_Yes#"></div>
</form>



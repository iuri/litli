<master>
<property name="context">@context_bar;literal@</property>
<property name="doc(title)">@room_name;literal@</property>

<center>
   <applet code=adChatApplet.class archive=chat.jar width=@width@ height=@height@>
   <param name="user_id" value="@user_id@">
   <param name="user_name" value="@user_name@">
   <param name="room_id" value="@room_id@">
   <param name="host" value="@host@">
   <param name="port" value="@port@">
   <if @moderator_p;literal@ true>
   <param name="moderator" value="true">
   </if>
   </applet>
</center>
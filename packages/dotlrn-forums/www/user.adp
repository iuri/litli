<master>
<property name="doc(title)">#dotlrn-forums.lt_Forums_Posting_histor#</property>
<property name="context_bar">@context_bar;literal@</property>

<p>
  #dotlrn-forums.Posting_history_for#
  <strong>
    <if @useScreenNameP@>@screen_name@</if>
    <else>
      <%
        if {![permission::permission_p -object_id [acs_magic_object security_context_root] -privilege admin]} {
            adp_puts [acs_community_member_link -user_id $user(user_id)]
        } else {
            adp_puts [acs_community_member_admin_link -user_id $user(user_id)]
        }
      %>
    </else>
  </strong>
</p>

<p>
<center>
@dimensional_chunk@
</center>
</p>

<center>

<if @view@ eq "date">

  <table bgcolor="#cccccc" width="95%">

    <tr>
      <th align="left" width="30%">#dotlrn-forums.Forum#</th>
      <th align="left">#dotlrn-forums.Subject#</th>
      <th align="center" width="20%">#dotlrn-forums.Posted#</th>
    </tr>

<if @messages:rowcount@ gt 0>
<multiple name="messages">

  <if @messages.rownum@ odd>
    <tr bgcolor="#eeeeee">
  </if>
  <else>
    <tr bgcolor="#d9e4f9">
  </else>

      <td><a href="@messages.url@forum-view?forum_id=@messages.forum_id@">@messages.forum_name@</a></td>
      <td><a href="@messages.url@message-view?message_id=@messages.message_id@">@messages.subject@</a></td>
      <td align="center">@messages.posting_date_pretty@</td>

    </tr>

</multiple>
</if>
<else>
    <tr>
      <td colspan="3">
        <em>#dotlrn-forums.No_Postings#</em>
      </td>
    </tr>
</else>

  </table>

</if>

<if @view@ eq forum>

<multiple name="messages">

  <table bgcolor="#cccccc" width="95%">

    <tr bgcolor="#eeeeee">
      <th align="left" colspan="2">@messages.forum_name@<br><br></th>
    </tr>

    <tr>
      <th align="left">#dotlrn-forums.Subject#</th>
      <th align="center" width="20%">#dotlrn-forums.Posted#</th>
    </tr>

<group column="forum_name">

  <if @messages.rownum@ odd>
    <tr bgcolor="#eeeeee">
  </if>
  <else>
    <tr bgcolor="#d9e4f9">
  </else>

      <td><a href="@messages.url@message-view?message_id=@messages.message_id@">@messages.subject@</a></td>
      <td align="center">@messages.posting_date_pretty@</td>

    </tr>

</group>

  </table>
  <br>

</multiple>

</if>

</center>


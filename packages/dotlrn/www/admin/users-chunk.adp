<%

    #
    #  Copyright (C) 2001, 2002 MIT
    #
    #  This file is part of dotLRN.
    #
    #  dotLRN is free software; you can redistribute it and/or modify it under the
    #  terms of the GNU General Public License as published by the Free Software
    #  Foundation; either version 2 of the License, or (at your option) any later
    #  version.
    #
    #  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
    #  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
    #  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
    #  details.
    #

%>

<%
    # The structure of this table is determined by the type of user we
    # are displaying.  It doesn't make much sense to display access
    # level, guest status, and admin status for pending users.  Instead we
    # will offer links to common actions. 

    # Note: There is some redundant logic inside the table and in
    # other files that display access and guest status fields as N/A
    # for pending users.  Previous to the change, this page was
    # displaying "Limited" and "Yes", respectively, which are wrong
    # and confused our site administrator.
    # The N/A logic is a failsafe in case these columns come back for
    # some reason.  aegrumet@mit.edu 2002-08-08.

%>

<center>
<table bgcolor="#cccccc" cellpadding="5" cellspacing="3" width="95%">
  <tr>
    <th align="left" width="50%">#dotlrn.User#</th>
    <if @type@ eq "pending">
    <th align="left">#dotlrn.Actions#</th>
    </if>
    <else>
    <th align="left">#dotlrn.Access#</th>
    <th align="left">#dotlrn.Guest#</th>
    <if @oacs_site_wide_admin_p;literal@ true>
    <th align="left">#dotlrn.Site-wide_Admin#</th>
    </if>
    </else>
  </tr>

<if @users:rowcount@ gt 0>
<multiple name="users">

<if @users.rownum@ odd>
  <tr bgcolor="#eeeeee">
</if>
<else>
  <tr bgcolor="#d9e4f9">
</else>
    <td align="left">
  <if @type@ eq "deactivated">
      <a href="user?user_id=@users.user_id@">@users.last_name@, @users.first_names@</a> (<a href="mailto:@users.email@">@users.email@</a>)
  </if>
  <else>
    <if @type@ eq "pending">
      <a href="user?user_id=@users.user_id@">@users.last_name@, @users.first_names@</a> (<a href="mailto:@users.email@">@users.email@</a>)
    </if>
    <else>
      <a href="user?user_id=@users.user_id@">@users.last_name@, @users.first_names@</a> (<a href="mailto:@users.email@">@users.email@</a>)
    </else>
  </else>
    </td>
<if @type@ eq "pending">
    <td align="left">

    <if @oacs_site_wide_admin_p;literal@ true>
    <% # We had to escape to Tcl to get the desired behavior. AG %>
    <small><a href="@users.state_change_url@">#dotlrn.lt_approve_and_add_to_do#</a> | </if>
    <a href="@users.nuke_url@">#acs-kernel.common_delete#</a></small>
    </td>
</if>
<else>
    <td align="center">@users.access_level@</td>
    <td align="center">
     <if @type@ eq "pending">
     #dotlrn.NA#
     </if>
     <else>
     <if @users.guest_p;literal@ true>#dotlrn.Yes#</if><else>#dotlrn.No#</else>
     </else>
    </td>

<if @oacs_site_wide_admin_p;literal@ true>
 <td align="center">
  <if @user_id@ ne @users.user_id@>
    <if @users.site_wide_admin_p;literal@ true>
      <strong>#dotlrn.Yes#</strong> | <a href="@users.swa_revoke_url@" title="#dotlrn.Revoke_site_wide_admin#">#dotlrn.No#</a>
    </if>
    <else>
      <a href="@users.swa_grant_url@" title="#dotlrn.Grant_site_wide_admin#">#dotlrn.Yes#</a> | <strong>#dotlrn.No#</strong>
    </else>
  </if>
      <else>#dotlrn.Yes#</else>
    </td>
</if>
</else>
  </tr>

</multiple>
</if>
<else>
  <tr bgcolor="#eeeeee">
    <td align="left" colspan="4"><em>#dotlrn.No_Users#</em></td>
  </tr>
</else>

</table>
</center>





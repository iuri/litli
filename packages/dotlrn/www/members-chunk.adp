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

<h3>#dotlrn.Members_of# <%= [dotlrn_community::get_community_name $community_id] %></h3>

<ul>
<multiple name="users">
<group column="role">  <li>
    <%= [acs_community_member_link -user_id $users(user_id) -label "$users(first_names) $users(last_name)"] %>
    <if @read_private_data_p@ eq 1 or @user_id@ eq @users.user_id@>
      (<a href="mailto:@users.email@">@users.email@</a>)
    </if>
    &nbsp;
    <em>@users.role@</em>
    <if @admin_p@ eq 1 or @user_id@ eq @users.user_id@>
      &nbsp;
      [<small>
        <include src="deregister-link" url="deregister?user_id=@users.user_id@&amp;referer=@referer@" label="#dotlrn.Drop_Membership#">
      </small>]
    </if>
  </li>
</group>
<br>

</multiple>

<if @admin_p@ eq 1 and @subcomm_p@ eq 0>
  <br>
  <li>
    <form method="get" action="member-add">
      #dotlrn.Add_A_Member# <input type="text" name="search_text"><input type="submit" value="#dotlrn.search#">
      <input type="hidden" name="referer" value="@referer@">
    </form>
  </li>
</if>

<% set dotlrn_admin_url [dotlrn::get_admin_url] %>

<if @site_wide_admin_p;literal@ true>
  <br>
  <li>
    <a href="@dotlrn_admin_url@/users-add-to-community?users=@user_list@&amp;referer=@referer@">
      #dotlrn.lt_Add_members_to_anothe#
    </a>
  </li>
</if>

</ul>

<if @admin_p@ eq 1 and @pending_users:rowcount@ gt 0>

<h3>#dotlrn.Membership_Requests#</h3>

<ul>
<multiple name="pending_users">
  <li>
    <%= [acs_community_member_link -user_id $pending_users(user_id) -label "$pending_users(first_names) $pending_users(last_name)"] %>
<if @read_private_data_p@ eq 1 or @user_id@ eq @pending_users.user_id@>
    (<a href="mailto:@pending_users.email@">@pending_users.email@</a>)
</if>
    &nbsp;
    <em>@pending_users.role@</em>
    &nbsp;
    [<small>
      <include src="approve-link" url="approve?user_id=@pending_users.user_id@&amp;referer=@referer@">
      |
      <include src="reject-link" url="reject?user_id=@pending_users.user_id@&amp;referer=@referer@">
    </small>]
  </li>
</multiple>
</ul>

</if>

<if @admin_p@ eq 1 and @subcomm_p@ eq 1 and @n_parent_users@ gt 0>

  <hr>

  <h3>#dotlrn.Add_New_Members#</h3>

    <p>
      #dotlrn.lt_The_following_members# 
    </p>

    <p>
      #dotlrn.lt_First_check_the_box_o#
    </p>

<formtemplate id="parent_users_form">
  <table width="75%" border="0">

    <tr>
      <td width="5%"><strong>#acs-kernel.common_add#</strong></td>
      <td width="95%">
        <table width="100%" border="0">
          <tr>
            <td width="15%" align="center"><strong>#dotlrn.Member#</strong></td>
            <td width="15%" align="center"><strong>#dotlrn.Administrator#</strong></td>
            <td>&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>

<formgroup id="selected_users">
    <tr>
      <td>@formgroup.widget@</td>
      <td>@formgroup.label@</td>
    </tr>
</formgroup>

    <tr>
      <td>&nbsp;</td>
      <td><input type="submit" value="#dotlrn.add_selected_members#"></td>
    </tr>

  </table>
</formtemplate>

</if>




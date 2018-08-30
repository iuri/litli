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

<master>
<property name="doc(title)">#dotlrn.Manage_Membership#</property>
<property name="link_all">1</property>
<property name="context">@context;literal@</property>

<h1>#dotlrn.Manage_Membership#</h1>

<if @admin_p@ eq 1 and @subcomm_p@ eq 0>
  <div style="padding: 5px 0px;">
  <form method="get" action="member-add" class="inline-form">
    <div><input type="hidden" name="referer" value="@return_url@"></div>
    <div class="form-item-wrapper">      
      <label for="search_text">
        #dotlrn.Add_A_Member# 
        <input type="text" name="search_text" id="search_text">
      </label>
    </div>
    <div class="form-button">
      <input type="submit" value="#dotlrn.search#">
    </div>
  </form>
  </div>
</if>


<listtemplate name="members"></listtemplate>

<if @admin_p;literal@ true>
  <if @pending_users:rowcount@ gt 0 or @approval_policy_p@ eq 1>
    <h2>#dotlrn.Membership_Requests#</h2>
    <listtemplate name="pending_users"></listtemplate>
  </if>
</if>

<if @admin_p@ eq 1 and @subcomm_p@ eq 1 and @n_parent_users@ gt 0>

  <h2>#dotlrn.Add_New_Members#</h2>

    <p>
      #dotlrn.lt_The_following_members#
    </p>

    <p>
      #dotlrn.lt_First_check_the_box_o#
    </p>

<formtemplate id="parent_users_form">
  <table>

    <thead>
      <tr>
        <th>#dotlrn.Dont_Add#</th>
        <th>#dotlrn.Member#</th>
        <th>#dotlrn.Administrator#</th>
        <th>#dotlrn.Users#</th>
      </tr>
    </thead>
    <tbody>

<%
    foreach user $parent_user_list {
        set this_user_id [ns_set get $user user_id]
        set this_first_names [ns_set get $user first_names]
        set this_last_name [ns_set get $user last_name]
        set this_email [ns_set get $user email]
%>

    <tr>
<formgroup id="selected_user.@this_user_id@">
      <td align="center">@formgroup.widget;noquote@</td>
</formgroup>
      <td>@this_last_name@, @this_first_names@</td>
    </tr>

<%
    }
%>

    <tr>
      <td colspan="4" align="center"><input type="submit" value="#dotlrn.add_selected_members#"></td>
    </tr>
    </tbody>
  </table>
</formtemplate>

</if>

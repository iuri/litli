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

<if @admin_p@ eq 1 and @subcomm_p@ eq 0>
<form method="get" action="member-add">
   #dotlrn.Add_A_Member# <input type="text" name="search_text"><input type="submit" value="#dotlrn.search#">
   <input type="hidden" name="referer" value="@referer@">
</form>


<form method="post" action="deregister-confirm">
</if>

<table  width="85%" class="table-display" cellpadding="5" cellspacing="0">
    <tr class="table-header">
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td><a href="@referer@?order=first_names&amp;order_direction=@first_names_order_direction@">
	#dotlrn.First_Name#</a> @first_names_order_html;noquote@
      </td>	
      <td><a href="@referer@?order=last_name&amp;order_direction=@last_name_order_direction@">
	#dotlrn.Last_Name#</a> @last_name_order_html;noquote@
      </td>
      <td><a href="@referer@?order=email&amp;order_direction=@email_order_direction@">
	#dotlrn.Email_1#</a> @email_order_html;noquote@
      </td>
      <td>#dotlrn.Role#</td>
      <td>#dotlrn.Actions#</td>
    </tr>
<multiple name="current_members">
<if @current_members.rownum@ odd>
    <tr class="odd">
</if>
<else>
    <tr class="even">
</else>
  <td>
   <if @admin_p;literal@ true>
	<input type="checkbox" name="user_id" value="@current_members.user_id@">
   </if>
 </td>
  <td>
    <if @current_members.portrait_p@ true or @current_members.bio_p@ true>
      <a href="@current_members.community_member_url@"><img src="/resources/acs-subsite/profile-16.png" height="16" width="16" alt="#acs-subsite.Profile#" title="#acs-subsite.lt_User_has_portrait_title#" border="0"></a>
    </if>
  </td>
  <td><%=[acs_community_member_link -user_id  @current_members.user_id@ -label @current_members.first_names@] %></td>
  <td><%=[acs_community_member_link -user_id  @current_members.user_id@ -label @current_members.last_name@]%></td>
  <td>
        <a href="mailto:@current_members.email@">
	@current_members.email@</a>	
   </td>
  <td><%=[template::util::nvl [dotlrn_community::get_role_pretty_name -community_id @community_id@ -rel_type @current_members.rel_type@] "Student"]%>
  </td>
  <td align="center">
  <if @admin_p;literal@ true>
     &nbsp; <a href="deregister?user_id=@current_members.user_id@&amp;referer=@referer@">#dotlrn.Drop_Membership#</a> | <a href="member-add-2?user_id=@current_members.user_id@&amp;referer=@referer@">#dotlrn.User_Admin_Page#</a>
  </if>
  <else> 
     <if @show_drop_button_p;literal@ true> 
       <if @my_user_id@ eq @current_members.user_id@>
	  <a href="deregister?user_id=@current_members.user_id@&amp;referer=@referer@">#dotlrn.Drop_Membership#</a>
      </if>
    </if> 
      <else>
	   &nbsp;
      </else>
  </else>
</td>
</tr>
</multiple>
</table>

<p>

<if @admin_p;literal@ true>
<input type="hidden" name="referer" value="@referer@">
<input type="submit" value="#dotlrn.Drop_selected_members#">
</form>
</if>

<ul>

<if @admin_p@ eq 1 and @subcomm_p@ eq 0>
  <br>

  </li>
</if>
<if @site_wide_admin_p;literal@ true>
<% set dotlrn_admin_url [dotlrn::get_admin_url] %>
  <br>
  <li>
    <a href="@dotlrn_admin_url@/community-members-add-to-community?source_community_id=@community_id@&amp;referer=@referer@">
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
    (<a href="mailto:@pending_users.email@">@pending_users.email@</a>)
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
      <td width="15%" align="center"><strong>#dotlrn.Dont_Add#</strong></td>
      <td width="15%" align="center"><strong>#dotlrn.Member#</strong></td>
      <td width="15%" align="center"><strong>#dotlrn.Administrator#</strong></td>
      <td>&nbsp;</td>
    </tr>

<%
    foreach user $parent_user_list {
        set this_user_id [ns_set get $user user_id]
        set this_first_names [ns_set get $user first_names]
        set this_last_name [ns_set get $user last_name]
        set this_email [ns_set get $user email]
%>

    <tr>
<formgroup id="selected_user.@this_user_id@" cols="3">
      <td width="15%" align="center">@formgroup.widget;noquote@</td>
</formgroup>
      <td>@this_last_name@, @this_first_names@ (@this_email@)</td>
    </tr>

<%
    }
%>

    <tr><td colspan="4">&nbsp;</td></tr>

    <tr>
      <td><input type="submit" value="#dotlrn.add_selected_members#"></td>
      <td colspan="3">&nbsp;</td>
    </tr>

  </table>
</formtemplate>

</if>

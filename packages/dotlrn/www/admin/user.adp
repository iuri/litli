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

<property name="&doc">doc</property>
<property name="context">@context;literal@</property>

<h1>#dotlrn.General_Information#</h1>

<ul>

  <li>
    #dotlrn.Person_name#
    <strong>@first_names@ @last_name@</strong>
  <if @site_wide_admin_p;literal@ true> 
    [<a href="/user/basic-info-update?@export_edit_vars@">#dotlrn.Edit#</a>]
  </if>
  </li>

  <li>
    #dotlrn.Email#
    <strong><a href="mailto:@email@">@email@</a></strong>
  <if @site_wide_admin_p;literal@ true>
    [<a href="/user/basic-info-update?@export_edit_vars@">#dotlrn.Edit#</a>]
  </if> 
  </li>

  <li>
    #dotlrn.Screen_name#
    <strong>@screen_name@</strong>
  <if @site_wide_admin_p;literal@ true>
    [<a href="/user/basic-info-update?@export_edit_vars@">#dotlrn.Edit#</a>]
  </if>
  </li>

  <li>
    #dotlrn.User_ID#
    <strong>@user_id@</strong>
  </li>

  <li>
    #dotlrn.Registration_date#
    <strong>@registration_date@</strong>
  </li>

<if @last_visit@ not nil>
  <li>
    #dotlrn.Last_Visit#
    <strong>@last_visit@</strong>
  </li>
</if>
<else>
  <li>
    #dotlrn.lt_Last_Visit_None_#: 
    [<a href="@remove_user_url@">#dotlrn.Nuke#</a>]
  </li>
</else>

<if @portrait_p;literal@ true>
  <li>
    #dotlrn.Portrait# <strong><a href="/shared/portrait?user_id=@user_id@">@portrait_title@</a></strong>
  </li>
</if>

  <li>
    #dotlrn.Member_state#
    <strong>@member_state@</strong>
        <if @site_wide_admin_p;literal@ true>
          [
          <multiple name="change_state_links">
            <if @change_state_links.rownum@ gt 1>|</if>
            <a href="@change_state_links.url@">@change_state_links.label@</a>
          </multiple>
          ]
        </if>
  </li>

</ul>

<h1>#dotlrn.dotLRN_Information#</h1>

<if @dotlrn_user_p;literal@ true>

<ul>

  <li>
    #dotlrn.User_type#
    <strong><%= [lang::util::localize @pretty_type@] %></strong>
  </li>

  <li>
          #dotlrn.Access_level#
          <strong>@browse_label@</strong> 
          [<a href="@browse_toggle_url@">@browse_toggle_label@</a>]
  </li>

  <li>
          #dotlrn.Guest#
          <strong>@guest_label@</strong> 
          [<a href="@guest_toggle_url@">@guest_toggle_label@</a>]
  </li>

  <li>
    #dotlrn.ID#
    <if @id@ nil><strong>#dotlrn.ltnone_set_upgt#</strong></if><else><strong>@id@</strong></else>
  </li>

  <li>
    <a href="user-edit?@export_edit_vars@">#dotlrn.Edit#</a> #dotlrn.lt_dotLRN_properties_for#
  </li>

</ul>

<if @member_classes:rowcount@ gt 0>
    <h2>#dotlrn.class_memberships#</h2>

    <ul>
<multiple name="member_classes">
      <li>
        <a href="@member_classes.url@">@member_classes.pretty_name@</a>
        @member_classes.term_name@ @member_classes.term_year@
        (@member_classes.role_pretty_name@)
      </li>
</multiple>
    </ul>
</if>

<if @member_clubs:rowcount@ gt 0>
    <h2>#dotlrn.community_memberships#</h2>

    <ul>
<multiple name="member_clubs">
      <li>
        <a href="@member_clubs.url@">@member_clubs.pretty_name@</a>
        (@member_clubs.role_pretty_name@)
      </li>
</multiple>
    </ul>
</if>

<if @member_subgroups:rowcount@ gt 0>
    <h2>#dotlrn.subcommunity_memberships#</h2>

    <ul>
<multiple name="member_subgroups">
      <li>
        <a href="@member_subgroups.url@">@member_subgroups.pretty_name@</a>
        (@member_subgroups.role_pretty_name@)
      </li>
</multiple>
    </ul>
</if>

  <ul>
    <li>
      <a href="@add_to_comm_url@">#dotlrn.add_to_another_group#</a>
    </li>
  </ul>

</if>
<else>
<p>
<if @member_state@ eq "approved">
  <a href="@add_to_dotlrn_url@">#dotlrn.add_to_dotlrn#</a>
</if>
<else>
#dotlrn.lt_This_user_is_currentl#.
</else>
</p>
</else>

<if @portrait_p@ true or @administrative_action_p@ true>
<h1>#dotlrn.lt_Administrative_Action#</h1>

<ul>
  <if @portrait_p;literal@ true>
    <li><a href="/user/portrait/index.tcl?@export_edit_vars@">#dotlrn.lt_Manage_this_users_por#</a></li>
  </if>
 <if @site_wide_admin_p;literal@ true>
  <li><a href="@toggle_swa_url@">@toggle_text@</a></li>
 </if>
 <if @site_wide_admin_p@ true or @dotlrn_admin_p@ true>
  <li><a href="password-update?@export_edit_vars@">#dotlrn.lt_Update_this_users_pas#</a></li>
  <li><a href="become?user_id=@user_id@">#dotlrn.Become_this_user#</a></li>
 </if> 
</ul>
</if>

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


<comment>Group properties section</comment>

<ul>
  <li><a href="community-edit" title="#dotlrn-portlet.edit_gr_props#">#dotlrn-portlet.edit_gr_props#</a> - #dotlrn-portlet.change_name_etc#
    <ul>
<if @customize_portal_layout_p@ true or @dotlrn_admin_p@ true >
      <li><a href="one-community-portal-configure" title="#dotlrn-portlet.lt_Customize_Portal_Layo#">#dotlrn-portlet.lt_Customize_Portal_Layo#</a></li>
      <li><a href="element-list" title="#dotlrn-portlet.lt_Change_Name_Portlet#">#dotlrn-portlet.lt_Change_Name_Portlet#</a></li>
</if>
      <li><a href="change-site-template?referer=@referer@" title="#dotlrn.Customize_Template#">#dotlrn.Customize_Template#</a></li>
      <li>
        #dotlrn-portlet.lt_Change_Bulk_Mail_Poli# -
          <if @members_can_spam_p;literal@ true><strong>#dotlrn-portlet.All_members#</strong></if><else><a href="spam-policy-toggle?policy=all" title="#dotlrn-portlet.change_bm_policy_to_all_members#">#dotlrn-portlet.All_members#</a></else>
          | <if @members_can_spam_p;literal@ false><strong>#dotlrn-portlet.Only_admins#</strong></if><else><a href="spam-policy-toggle?policy=admins" title="#dotlrn-portlet.change_bm_policy_to_only_admins#">#dotlrn-portlet.Only_admins#</a></else>
          #dotlrn-portlet.lt_can_send_bulk_mail_to#
      </li>
    </ul>
  </li>
</ul>

<comment>Membership section</comment>

<ul>
<if @manage_membership_p@ true or @dotlrn_admin_p@ true >
  <li><a href="members" title="#dotlrn-portlet.goto_Manage_Membership#">#dotlrn-portlet.Manage_Membership#</a> - #dotlrn-portlet.lt_AddRemove_pretty_name#
    <ul>
    <if @member_email_enabled_p@ defined>
      <li><a href="member-email" title="#dotlrn-portlet.Edit_Welcome_Message#">#dotlrn-portlet.Edit_Welcome_Message#</a>
       - <if @member_email_enabled_p@ true"><strong>#acs-subsite.Enabled#</strong></if>
         <else><a href="member-email-toggle" title="#dotlrn-portlet.enable_welcome_message#">#acs-subsite.Enabled#</a></else> |
         <if @member_email_enabled_p;literal@ false><strong>#acs-subsite.Disabled#</strong></if>
         <else><a href="member-email-toggle" title="#dotlrn-portlet.disable_welcome_message#">#acs-subsite.Disabled#</a></else>
    </if>
    <else>
      <li><a href="member-email" title="#dotlrn-portlet.lt_Create_Welcome_Messag#">#dotlrn-portlet.lt_Create_Welcome_Messag#</a>
    </else>
      </li>
</if>

<if @enrollment_policy_p@ true or @dotlrn_admin_p@ true >
      <li>
        #dotlrn-portlet.lt_Change_Enrollment_Pol# -
          <if @join_policy@ eq "open"><strong>#dotlrn-portlet.Open#</strong></if><else><a href="join-policy-toggle?policy=open" title="#dotlrn-portlet.set_policy_open#">#dotlrn-portlet.Open#</a></else>
        | <if @join_policy@ eq "closed"><strong>#dotlrn-portlet.Closed#</strong></if><else><a href="join-policy-toggle?policy=closed" title="#dotlrn-portlet.set_policy_closed#">#dotlrn-portlet.Closed#</a></else>
        |&nbsp;<if @join_policy@ eq "needs approval"><strong>#dotlrn-portlet.Needs_Approval#</strong></if><else><a href="join-policy-toggle?policy=needs%20approval" title="#dotlrn-portlet.set_policy_approval#">#dotlrn-portlet.Needs_Approval#</a></else>
      </li>
</if>
<if @subcommunity_p;literal@ false>
  <if @club_p;literal@ false>
    <if @create_limited_user_p@ true or @dotlrn_admin_p@ true >
      <li>
        <a href="@limited_user_add_url@" title="#dotlrn-portlet.lt_Create_a_new_Limited_#">#dotlrn-portlet.lt_Create_a_new_Limited_#</a> - #dotlrn-portlet.lt_Only_use_this_to_crea# </li>
      </if>
   </if>


   <if @create_guest_user_p@ true or @dotlrn_admin_p@ true >
      <li><a href="@club_limited_user_add_url@" title="#dotlrn-portlet.lt_Create_a_new_Limited__1#">#dotlrn-portlet.lt_Create_a_new_Limited__1#</a>
        - #dotlrn-portlet.lt_Only_use_this_to_crea_1#
      </li>
   </if>
</if>
    </ul>
  </li>
</ul>

<comment>subgroups section</comment>

<ul>
  <li>@sub_pretty_plural@
    <ul>
<multiple name="subgroups">
      <li>
        <a href="@subgroups.url@" title="#dotlrn-portlet.goto_subgroups_pretty_name#">@subgroups.pretty_name@</a>
        [
          <a href="@subgroups.url@one-community-admin" title="#dotlrn-portlet.Administer#">#dotlrn-portlet.Administer#</a>
          |
          <a href="subcommunity-archive?community_id=@subgroups.community_id@" title="#dotlrn-portlet.Archive#">#dotlrn-portlet.Archive#</a>
        ]
      </li>
</multiple>
      <li><p><a href="subcommunity-new" title="#dotlrn-portlet.New_sub_pretty_name#">#dotlrn-portlet.New_sub_pretty_name#</a></p></li>
    </ul>
  </li>
</ul>

<comment>manage applets section </comment>
<if @manage_applets_p@ true or @dotlrn_admin_p@ true >
<ul>
  <li><a href="applets" title="#dotlrn-portlet.Manage_Applets#">#dotlrn-portlet.Manage_Applets#</a></li>
</ul>
</if>

<comment>.LRN admin actions section</comment>
<if @dotlrn_admin_p;literal@ true>
<ul>
  <li><a href="@dotlrn_admin_url@" title="#dotlrn-portlet.goto_admin_pretty_name#">@admin_pretty_name@</a>
    <ul>
      <li><a href="dotlrn-group-admin-faq" title="#dotlrn-portlet.goto_Administrator_FAQ#">#dotlrn-portlet.Administrator_FAQ#</a></li>
      <li><a href="clone" title="#dotlrn-portlet.Copy_this_group#">#dotlrn-portlet.Copy_this_group#</a></li>
  <if @archived_p;literal@ true>
      <li><a href="@dotlrn_admin_url@/archived-communities" title="#dotlrn-portlet.goto_archived_communities#"><span style="color:red">#dotlrn-portlet.lt_This_group_is_archive#</span></a></li>
  </if>
  <else>
      <li><a href="subcommunity-archive" title="#dotlrn-portlet.Archive_this_group#">#dotlrn-portlet.Archive_this_group#</a></li>
  </else>
  <if @club_p;literal@ false>
      <li><a href="class-term-change?pretty_name=@pretty_name;noquote@" title="#dotlrn-portlet.Change_term_of_pretty_name#">#dotlrn-portlet.Change_term#</a></li>
  </if>
      <li>
        #dotlrn-portlet.lt_Guests_Can_View_Membership_Info# -
  <if @guests_can_view_private_data_p;literal@ true><strong>#acs-kernel.common_yes#</strong>&nbsp;|&nbsp;<a href="privacy-policy-toggle?policy=no" title="#dotlrn-portlet.Toggle_privacy_policy_to_no#">#acs-kernel.common_No#</a></if><else><a href="privacy-policy-toggle?policy=yes" title="#dotlrn-portlet.Toggle_privacy_policy_to_yes#">#acs-kernel.common_Yes#</a>&nbsp;|&nbsp;<strong>#acs-kernel.common_no#</strong></else>
      </li>
    </ul>
  </li>
</ul>
</if>

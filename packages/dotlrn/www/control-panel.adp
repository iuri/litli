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
<property name="link_control_panel">0</property>
<property name="context">@context;literal@</property>

<div id="main-content-sim">
	<div class="main-content-padding">

    <div class="portlet-wrapper">
		<div class="portlet-header">
			<div class="portlet-title-no-controls">
				<h1>#acs-subsite.Your_Account#</h1>
      		</div>
		</div>


		<div class="portlet" style="position:relative;">

          <if @portrait_p;literal@ true>
            <div style="position: absolute; top: 10px; left: 10px;">
              <img src="@portrait_image_src@" alt="#acs-subsite.Your_Portrait#">
            </div>
          </if>

          <include src="@user_info_template;literal@" >

          <div style="clear: both;">
            <ul>
              <li><a href="@community_member_url@">#acs-subsite.lt_What_other_people_see#</a></li>
            </ul>

            <ul>
              <li>
                <a href="@portrait_url@">
                  <if @portrait_p;literal@ true>#acs-subsite.Manage_Portrait#</if>
                  <else>#acs-subsite.Upload_Portrait#</else>
                </a>
              </li>

			  <li><a href="@email_privacy_url@">#acs-subsite.Change_my_email_P#</a></li>

			  <li><a href="@change_password_url@" title="#acs-subsite.Change_my_Password#">#acs-subsite.Change_my_Password#</a></li>
            </ul>

            <ul>
              <li><a href="@close_account_url@" title="#acs-subsite.Close_your_account#">#acs-subsite.Close_your_account#</a></li>

            </ul>
          </div>

		</div> <!-- /portlet -->
	</div><!-- /portlet-wrapper -->

</div>
</div>

<div id="sidebar-1-sim">
	<div class="sidebar-1-padding">

    <div class="portlet-wrapper">
    	<div class="portlet-header">
			<div class="portlet-title-no-controls">
				<h1>#dotlrn.Preferences#</h1>
			</div>
		</div>
		<div class="portlet">

        <!-- Tools -->
        <if @notifications_url@ not nil>
          <ul>
            <li><a href="@notifications_url@" title="#acs-subsite.Manage_your_notifications#">#acs-subsite.Manage_your_notifications#</a></li>
          </ul>
        </if>

        <ul>
          <li><a href="configure" title="#dotlrn.Customize_Layout#">#dotlrn.Customize_Layout#</a></li>

          <if @allowed_to_change_site_template_p;literal@ true>
            <li><a href="@site_template_url@" title="#dotlrn.Customize_Template#">#dotlrn.Customize_Template#</a></li>
          </if>
        </ul>


        <!-- who's online -->
        <if @invisible_p;literal@ true>
          <p>#acs-subsite.Currently_invisible_msg#</p>
          <ul>
            <li><a href="@make_visible_url@" title="#acs-subsite.Make_yourself_visible_label#">#acs-subsite.Make_yourself_visible_label#</a></li>
        </if>
        <else>
          #acs-subsite.Currently_visible_msg#
          <ul>
            <li><a href="@make_invisible_url@" title="#acs-subsite.Make_yourself_invisible_label#">#acs-subsite.Make_yourself_invisible_label#</a></li>
        </else>
          <li><a href="@whos_online_url@">#acs-subsite.Whos_Online_link_label#</a></li>
        </ul>
		</div> <!-- /portlet -->
	</div><!-- /portlet-wrapper -->

	<div class="portlet-wrapper">
    	<div class="portlet-header">
			<div class="portlet-title-no-controls">
				<h1>#dotlrn.Support#</h1>
			</div>
		</div>
		<div class="portlet">
			<ul>
				<li><a href="@dotlrn_url@/help" title="#dotlrn.help#">#dotlrn.help#</a></li>
				<li><a href="mailto:@system_owner@">#dotlrn.Contact_us#</a></li>
			</ul>
		</div> <!-- /portlet -->
	</div><!-- /portlet-wrapper -->

</div>
</div>

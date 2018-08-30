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

<if @config.shaded_p@ ne "t">

<if @community_id@ eq 0>
  #dotlrn-portlet.lt_No_community_was_spec#
</if>
<else>
  <%= [dotlrn_community::get_role_pretty_plural -community_id $community_id -rel_type dotlrn_instructor_rel] %>:
    <ul>
    <if @n_profs@ gt 0>
      <multiple name="users">
        <if @users.rel_type@ eq "dotlrn_instructor_rel">
        <li>     
          <%= [acs_community_member_link -user_id $users(user_id) -label "$users(first_names) $users(last_name)"] %>
          <if @read_private_data_p@ eq 1 or @user_id@ eq @users.user_id@>
            (<%= [email_image::get_user_email -user_id $users(user_id) -return_url @return_url@] %>)
          </if>
	</li>
        </if>
    </multiple>
  </if>
  <else>
    <li>#dotlrn-portlet.no_instructor_members#</li>
  </else>
  </ul>
<if @n_tas@ gt 0>
  <%= [dotlrn_community::get_role_pretty_plural -community_id $community_id -rel_type dotlrn_ta_rel] %>:
  <ul>
    <multiple name="users">
      <if @users.rel_type@ eq "dotlrn_ta_rel">
        <li>     
          <%= [acs_community_member_link -user_id $users(user_id) -label "$users(first_names) $users(last_name)"] %>
          <if @read_private_data_p@ eq 1 or @user_id@ eq @users.user_id@>
            (<%= [email_image::get_user_email -user_id $users(user_id) -return_url @return_url@] %>)
          </if>
        </li>
      </if>
    </multiple>
  </ul>
</if>

  <if @n_cas@ gt 0>
    <%= [dotlrn_community::get_role_pretty_plural -community_id $community_id -rel_type dotlrn_ca_rel] %>:
    <ul>
      <multiple name="users">
        <if @users.rel_type@ eq "dotlrn_ca_rel">
          <li>     
            <%= [acs_community_member_link -user_id $users(user_id) -label "$users(first_names) $users(last_name)"] %>
            <if @read_private_data_p@ eq 1 or @user_id@ eq @users.user_id@>
            (<%= [email_image::get_user_email -user_id $users(user_id) -return_url @return_url@] %>)
            </if>
          </li>
        </if>
      </multiple>
    </ul>
  </if>

  <if @read_private_data_p;literal@ true>
    <br>
    <a href="members" title="#dotlrn-portlet.Member_List#">#dotlrn-portlet.Member_List#</a>
  </if>
  <else>
    <br>#dotlrn-portlet.no_course_assistant_members#
  </else>
</else>

</if>
<else>
    #new-portal.when_portlet_shaded#
</else>


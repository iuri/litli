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


  <if @user_can_browse_p@ and @self_registration_p@>
    <div style="text-align: right">
      <a href="@dotlrn_url@/manage-memberships" title="#dotlrn.lt_JoinDrop_a_Class_or_C#" class="button">#dotlrn.lt_JoinDrop_a_Class_or_C#</a>
    </div>
  </if>

  <if @communities:rowcount@ gt 0>

    <multiple name="communities">
      @communities.previous_type_ul_tags;noquote@

      <if @show_subtitle_p;literal@ true>
        <ul class="mktree" style="padding-left: 5px;">
          <li id="dotlrn-main-@communities.simple_community_type@">
            <h2 style="display: inline; margin: 5px 0 0 0;">
              <if @communities.simple_community_type@ eq "dotlrn_class_instance">
                <%= [parameter::get -localize -parameter class_instances_pretty_plural] %>
              </if>
              <else>
                <%= [parameter::get -localize -parameter clubs_pretty_plural] %>
              </else>

            </h2>

            <ul id="tree-@communities.simple_community_type@">
          </if>
          <else>
            <ul>
          </else>

            <li>
              <group column="simple_community_type">

                @communities.intra_type_ul_tags;noquote@

                <a href="@communities.url@" title="#dotlrn.goto_communities_pretty_name_portal#">@communities.pretty_name@</a>
                <if @communities.archived_p;literal@ true><span style="color:red">#dotlrn.archived#</span></if>
                <if @show_buttons_p;literal@ true>
                  <if @show_drop_button_p;literal@ true>
                    <a href="@communities.url@deregister-self-confirm?referer=@referer@">#dotlrn.drop_membership_link#</a>
                  </if>
                  <if @communities.admin_p;literal@ true>
                    <a href="@communities.url@one-community-admin">#dotlrn.administer_link#</a>
                  </if>
                </if>
              </group>
            </li>
          </ul>
      <if @show_subtitle_p;literal@ true>
        </li>
      </ul>
      </if>

    </multiple>

    @final_ul_tags;noquote@

  </if>

  <master>
    <property name="&doc">doc</property>
    <property name="context">@context;literal@</property>

    <h1>#dotlrn.Site_Map#</h1>

    <ul>
      <li><a href="@dotlrn_url@">#dotlrn.Home#</a>
        <ul>
          <multiple name="home_pages">
            <li><a href="@home_pages.url@">@home_pages.pretty_name@</a></li>
          </multiple>
        </ul>
      </li>
      <li><a href="@dotlrn_url@/courses">#dotlrn.Courses#</a>
        <if @courses:rowcount@ gt 0>
          <ul>
            <multiple name="courses">
              <li>@courses.pretty_name@
                <ul>
                  <group column="community_id">
                    <li>
                      <a href="@courses.url@?page_num=@courses.sort_key@">@courses.page_name@</a>
                    </li>
                  </group>
                  <if @courses.admin_p;literal@ true>
                    <li>
                      <a href="@courses.url@one-community-admin">#dotlrn.Admin#</a>
                    </li>
                  </if>
                </ul>
              </li>
            </multiple>
          </ul>
        </if>
      </li>
      <li><a href="@dotlrn_url@/communities">#dotlrn.Communities#</a>
        <if @communities:rowcount@ gt 0>
          <ul>
            <multiple name="communities">
              <li>@communities.pretty_name@
                <ul>
                  <group column="community_id">
                    <li>
                      <a href="@communities.url@?page_num=@communities.sort_key@">@communities.page_name@</a>
                    </li>
                  </group>
                  <if @communities.admin_p;literal@ true>
                    <li>
                      <a href="@communities.url@one-community-admin">#dotlrn.Admin#</a>
                    </li>
                  </if>
                </ul>
              </li>
            </multiple>
          </ul>
        </if>
      </li>
      <li><a href="@dotlrn_url@/control-panel">#dotlrn.control_panel#</a>
        <ul>
          <li>#acs-subsite.My_Account#
            <ul>
              <li><a href="@community_member_url@">#acs-subsite.lt_What_other_people_see#</a></li>
              <li><a href="@portrait_url@">#acs-subsite.Manage_Portrait#</a></li>
              <li><a href="@email_privacy_url@">#acs-subsite.Change_my_email_P#</a></li>

              <li><a href="@password_update_url@" title="#acs-subsite.Change_my_Password#">#acs-subsite.Change_my_Password#</a></li>

              <if @account_status@ ne "closed">
                <li><a href="/pvt/unsubscribe" title="#acs-subsite.Close_your_account#">#acs-subsite.Close_your_account#</a></li>
              </if>
            </ul>
          </li>
          <li>#dotlrn.Preferences#
            <ul>
              <if @notifications_url@ not nil>
                <li><a href="@notifications_url@" title="#acs-subsite.Manage_your_notifications#">#acs-subsite.Manage_your_notifications#</a></li>
              </if>

              <li><a href="configure" title="#dotlrn.Customize_Layout#">#dotlrn.Customize_Layout#</a></li>

              <if @allowed_to_change_site_template_p;literal@ true>
                <li><a href="@site_template_url@" title="#dotlrn.Customize_Template#">#dotlrn.Customize_Template#</a>
              </if>
				
              <if @invisible_p;literal@ true>
                <li><a href="@make_visible_url@" title="#acs-subsite.Make_yourself_visible_label#">#acs-subsite.Make_yourself_visible_label#</a></li>
              </if>
              <else>
                <li><a href="@make_invisible_url@" title="#acs-subsite.Make_yourself_invisible_label#">#acs-subsite.Make_yourself_invisible_label#</a></li>
              </else>
              <li><a href="@whos_online_url@">#acs-subsite.Whos_Online_link_label#</a></li>
            </ul>
          </li>
          <li>
            <a href="@dotlrn_url@/help" title="#dotlrn.help#">#dotlrn.help#</a>
          </li>
        </ul>
      </li>

      <if @dotlrn_admin_p>
        <li>
          <a href="@dotlrn_admin_url@">#dotlrn.Administration#</a>
          <include src="/packages/dotlrn/lib/admin-chunk">
        </li>
      </if>

    </ul>

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

<if @shaded_p;literal@ false>
    <if @forums:rowcount@ gt 0>
      <multiple name="forums">
        <h2>@forums.parent_name@</h2>
        <ul>
          <group column="package_id">
            <li>
              <if @useReadingInfo@>
                <if @forums.count_unread@ gt 0><strong></if>
                <a href="@forums.url@forum-view?forum_id=@forums.forum_id@">@forums.name@</a>
                <if  @forums.count_unread@ gt 0></strong>(@forums.count_unread@)</if>
              </if>
              <else>
                <a href="@forums.url@forum-view?forum_id=@forums.forum_id@">@forums.name@</a>
                <if @forums.new_p;literal@ true>
                  <span class="new_flag">#forums-portlet.resources_acs-subsite_new_gif#</span>
                </if>
              </else>
            </li>
          </group>
        </ul>
      </multiple>
    </if>
    <else>
      <p>#forums.No_Forums#</p>
    </else>
</if>
<else>
    #new-portal.when_portlet_shaded#
</else>




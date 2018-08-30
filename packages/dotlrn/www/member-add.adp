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
<property name="doc(title)">#dotlrn.Add_A_Member#</property>
<property name="context">@context;literal@</property>

<h1>#dotlrn.Add_A_Member#</h1>

<if @users:rowcount@ eq 0>
  <p>#dotlrn.there_are_no_users_matching#</p>
</if>
<else>

    #dotlrn.lt_The_results_of_your_s#

    <ul>
      <multiple name="users">
        <li>
        <if @users.member_p;literal@ true>
          #dotlrn.user_already_member#
        </if>
        <else>
          <a href="@users.member_add_url@" title="#dotlrn.add# @users.last_name@, @users.first_names@">@users.last_name@, @users.first_names@</a>
        </else>
        </li>
      </multiple>
    </ul>
</else>

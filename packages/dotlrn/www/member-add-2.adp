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
<property name="focus">member-add-2.rel_type</property>

<h1>#dotlrn.Add_A_Member#</h1>

<if @member_p;literal@ true>

<p>#dotlrn.lt_strongfirst_names_las#</p>

</if>
<else>
<p>#dotlrn.lt_You_are_adding_strong#</p>
</else>

<form method="get" action="member-add-3" name="member-add-2">
  <div>
  <input type="hidden" name="user_id" value="@user_id@">
  <input type="hidden" name="referer" value="@referer@">
  </div>

  <div>
  <label for="rel_type">
    #dotlrn.Role#

    <select name="rel_type" id="rel_type">
 
    <if @allowed_to_add_student@ false and @dotlrn_admin@ false>
      <multiple name="roles">
        <if @roles.rel_type@ ne "dotlrn_student_rel">
          <option value="@roles.rel_type@">
            <%= [lang::util::localize @roles.pretty_name@] %>
          </option>
        </if>
      </multiple>
    </if>
  <else> 
    <multiple name="roles">
      <option value="@roles.rel_type@"><%= [lang::util::localize @roles.pretty_name@] %></option>
    </multiple>
  </else>
  </select>
  </label>
  <input type="submit" value="#acs-kernel.common_add#">
  </div>

</form>

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

    <h1>#dotlrn.AddDrop_Memberships#</h1>

    <p>
      <small>
        <a href="#current" title="#dotlrn.goto_current_clubs#">#dotlrn.lt_Current_clubs_pretty_#</a>
        |
        <a href="#join_classes" title="#dotlrn.goto_join_class#">#dotlrn.lt_Join_a_class_instance#</a>
        |
        <a href="#join_clubs" title="#dotlrn.goto_join_clubs#">#dotlrn.lt_Join_a_clubs_pretty_n#</a>
      </small>
    </p>

    <if @n_member_classes@ gt 0 or @member_clubs:rowcount@ gt 0>
      <hr>
      <h2><a name="current">#dotlrn.lt_Your_Current_Membersh#</a></h2>

      <if @n_member_classes@ gt 0>
        <formtemplate id="member_form" class="inline-form">
          <div>@departments_pretty_name@:&nbsp;<formwidget id="member_department_key"></div>
          <div>#dotlrn.Term#&nbsp;<formwidget id="member_term_id"></div>
        </formtemplate>
      </if>

      <if @member_classes:rowcount@ gt 0>
        <listtemplate name="member_classes"></listtemplate>
      </if>
      <else>
        <p><small>#dotlrn.No_classes#</small></p>
      </else>
  
      <if @member_clubs:rowcount@ gt 0>
        <listtemplate name="member_clubs"></listtemplate>
      </if>
      <else>
        <p><small>#dotlrn.no_clubs#</small></p>
      </else>
    </if>

    <if @n_non_member_classes@ gt 0 or @non_member_clubs:rowcount@ gt 0>
      <hr>
      <h2><a name="join_class">#dotlrn.Join_A_Group#</a></h2>

      <if @n_non_member_classes@ gt 0>
        <formtemplate id="non_member_form" class="inline-form">
          <div>@departments_pretty_name@:&nbsp;<formwidget id="non_member_department_key"></div>
          <div>#dotlrn.Term#&nbsp;<formwidget id="non_member_term_id"></div>
        </formtemplate>

        <a name="join_classes"></a>
        <if @non_member_classes:rowcount@ gt 0>
          <listtemplate name="non_member_classes"></listtemplate>
        </if>
        <else>
          <p><small>#dotlrn.No_classes#</small></p>
        </else>

      </if>

      <a name="join_clubs"></a>
      <if @non_member_clubs:rowcount@ gt 0>
        <listtemplate name="non_member_clubs"></listtemplate>
      </if>
      <else>
        <p><small>#dotlrn.no_clubs#</small></p>
      </else>
    </if>

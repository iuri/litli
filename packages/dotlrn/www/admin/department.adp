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

<master src="dotlrn-admin-master">
<property name="doc(title)">@pretty_name;literal@</property>
<property name="context_bar">@context_bar;literal@</property>

<ul>

  <li>
    #dotlrn.External_URL_1#
<if @external_url@ not nil>
    <a href="@external_url@">@external_url@</a>
</if>
<else>
    &lt;#dotlrn.none_set_up#&gt;
</else>
  </li>

  <li>
    #dotlrn.Description_1#
<if @description@ not nil>
    @description@
</if>
<else>
    &lt;#dotlrn.none_set_up#&gt;
</else>
  </li>

  <br>

  <li>
    <a
    href="department-edit?department_key=@department_key@&amp;referer=@referer@">#dotlrn.lt_Edit_department_prope#</a>
  </li>

</ul>

<br>

<include src="classes-chunk" page="@page;literal@" department_key="@department_key;literal@">

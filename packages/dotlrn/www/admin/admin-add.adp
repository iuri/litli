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
<property name="context_bar">@context_bar;literal@</property>

<h1>#dotlrn.Add_an_Admin#</h1>

<if @users:rowcount@ eq 0>
     #dotlrn.there_are_no_users_matching#
  </tr>
</if>
<else>
#dotlrn.lt_The_results_of_your_s#
</else>

<ul>
<multiple name="users">
  <li><a href="admin-add-2?user_id=@users.user_id@&amp;referer=@referer@">@users.last_name@, @users.first_names@ (@users.email@)</a> 
 
  </li>
</multiple>
</ul>



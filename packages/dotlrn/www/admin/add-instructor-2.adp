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
<property name="doc(title)">#dotlrn.dotLRN_Admin#</property>
<property name="context_bar">@context_bar;literal@</property>

<h1>#dotlrn.Add_a_Professor#</h1>

<p>#dotlrn.lt_The_results_of_your_s#</p>
<ul>
  <multiple name="users">
    <li>
      <a href="add-instructor-3?user_id=@users.user_id@&amp;community_id=@community_id@&amp;referer=@referer@">@users.last_name@, @users.first_names@ (@users.email@)
    </li>
  </multiple>
</ul>







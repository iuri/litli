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

<h1><if @title@ nil>#dotlrn.My_Communities#</if><else>@title@</else></h1>

<table>
<multiple name="communities">
  <tr>
    <td><a href="@communities.url@">@communities.pretty_name@</a></td>
    <td>@communities.role_pretty_name@</td>
    <td><if @communities.admin_p;literal@ true><a href="@communities.url@one-community-admin">#dotlrn.administer_link#</a></if></td>
    <td><include src="deregister-link" url="deregister?community_id=@communities.community_id@&amp;referer=@referer@"></td>
  </tr>
</multiple>
<if @user_can_browse_p;literal@ true>
  <tr>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3"><a href="manage-memberships">#dotlrn.Join_A_Group#</a></td>
  </tr>
</if>
</table>

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

<formtemplate id="user_search">
  <formwidget id="type">
  <formwidget id="referer">

<table cellspacing="3" cellpadding="3">

  <tr>
    <th align="left">#dotlrn.Search_Text#</th>
    <td><formwidget id="search_text"></td>
    <td><input type="submit" value="#dotlrn.Search#"></td>
  </tr>

</table>

</formtemplate>

<include src="users-chunk" type="@type;literal@" &users="users" referer="@referer;literal@">




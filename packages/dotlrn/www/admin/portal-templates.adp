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
<property name="doc(title)">@title;literal@</property>
<property name="context_bar">@context_bar;literal@</property>

<table width="50%" cellpadding="3" cellspacing="3">
  <tr>
    <th align="left">#dotlrn.Template#</th>
    <th align="left">#dotlrn.Actions#</th>
  </tr>
<multiple name=templates>
  <tr>
    <td>
      <a href="@url@/portal-show.tcl?portal_id=@templates.portal_id@&amp;referer=@referer@">@templates.name@</a>
    </td>
    <td>
      [<small>
        <a href="@url@/portal-config?portal_id=@templates.portal_id@&amp;referer=@referer@">#dotlrn.Edit#</a>
      </small>]
    </td>
  </tr>
</multiple>
</table>




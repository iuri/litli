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

<if @package_id@ eq "">
  <small>No community specified</small>
</if>
<else>
<ul>
<multiple name="content">
  <li>
    <a href="@content.edit_url@" title="#static-portlet.edit_content_pretty_name#">@content.pretty_name@</a>
  </li>
</multiple>
</ul>
<ul>
  <li>
    <a href="@create_url@" title="#static-portlet.create_new_element_pretty_name#">#static-portlet.new_static_admin_portlet#</a>
  </li>
</ul>
</else>

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

<if @active_applets:rowcount@ gt 0>
<h3>#dotlrn.Active_Applets#</h3>
<ul>

<multiple name="active_applets">
  <li>@active_applets.applet_pretty_name@ - (#dotlrn.cannot_be_removed#)</li>
</multiple>
</ul>
</if>

<if @all_applets:rowcount@ gt 0>
<p></p>

<h3>#dotlrn.Applets_to_Add#</h3>
<ul>
<multiple name="all_applets">
  <li>
    @all_applets.applet_pretty_name@
    [<small>
      <a href="applet-add?applet_key=@all_applets.applet_key@">#dotlrn.add#</a>
    </small>]
  </li>
</multiple>
</ul>
</if>




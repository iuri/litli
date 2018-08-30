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

<ul>
<li><a href="@url@" title="#dotlrn-forums.display_all_forums#">#dotlrn-forums.All_forums#</a> (<a href="@url@admin/" title="#dotlrn-forums.goto_forums_admin#">#dotlrn-forums.administer#</a>)</li>
<multiple name="forums">
  <li>
    <a href="@url@admin/forum-edit?forum_id=@forums.forum_id@" title="#dotlrn-forums.goto_forums_name#">@forums.name@</a>
    <if @forums.enabled_p;literal@ false><strong>(disabled)</strong></if>
    <br>
    #dotlrn-forums.Auto_subscribe_label#:
    <if @forums.autosubscribe_p;literal@ true>
      <strong>#acs-kernel.common_yes#</strong> | <a href="@dotlrn_url@/unsubscribe-members?@forums.query_vars@" title="#dotlrn-forums.do_not_autosubscribe_members#">#acs-kernel.common_No#</a>
    </if>
    <else>
      <a href="@dotlrn_url@/subscribe-members?@forums.query_vars@" title="#dotlrn-forums.autosubscribe_members#">#acs-kernel.common_yes#</a> | <strong>#acs-kernel.common_No#</strong>
    </else>
  </li>
</multiple>
</ul>
<ul>
  <li>
    <a href="@url@admin/forum-new?name=@encoded_default_name@" title="#dotlrn-forums.Create_New_Forum#">#dotlrn-forums.New_Forum#</a>
  </li>
</ul>

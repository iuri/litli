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

<if @config.shaded_p@ ne "t">
<ul>
  <li><a href="@spam_url@" title="#bm-portlet.spam_name_History#">#bm-portlet.spam_name_History#</a></li>
  <li><a href="spam-recipients?referer=one-community-admin" title="#bm-portlet.New_spam_name#">#bm-portlet.New_spam_name#</a></li>
</ul>
</if>
<else>
  <small>
    #new-portal.when_portlet_shaded#
  </small>
</else>

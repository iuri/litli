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

<if @weblogs:rowcount@ eq 0>
<a href="weblog-new">#dotlrn.Create_a_Web_Log#</a>
</if>
<else>
<ul>
<multiple name="weblogs">

	<li>#dotlrn.Post_to# <a href="@weblog_url@?forum_id=@weblogs.forum_id@">@weblogs.name@</a>	
</multiple>
</ul>
</else>

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
<property name="doc(title)">@title;literal@</property>

<p>
#static-portlet.Back_to# <a href="@referer@">@portal_name@</a>
</p>

<if @new_p;literal@ true>
<p><big><strong>#static-portlet.Create_a_new#</strong></big></p>
<p>#static-portlet.Use_this_form#</p>
</if>
<else>
<p><big><strong>@editing_text@</strong></big></p>
<p>[<a href="element-delete?content_id=@content_id@&amp;referer=@referer@&amp;portal_id=@portal_id@"><strong>@delete_text@</strong></a>]</p>
</else>

<P>#static-portlet.lt_strongNotestrong_You_#</p>
<formtemplate id="static_element"></formtemplate>

<p>#static-portlet.You_may_upload#</p>
<formtemplate id="static_file"></formtemplate>

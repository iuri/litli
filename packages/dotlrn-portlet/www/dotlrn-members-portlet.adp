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
<if @read_private_data_p;literal@ true>
<listtemplate name="users"></listtemplate>
<if @spam_p@ true or @admin_p@ eq 1>
<p>

<if @spam_p;literal@ true>
  <a href="@spam_url@" title="#dotlrn-portlet.Email_Members#" class="button">#dotlrn-portlet.Email_Members#</a>
</if>
<if @admin_p;literal@ true>
  	<a href="members" title="#dotlrn-portlet.Sortmanage#" class="button">#dotlrn-portlet.Sortmanage#</a>
</if>
</p>
</if>
</if>
<else>
        <% # The user is not allowed to read the member list - he/she is may be a guest %>
	#dotlrn-portlet.lt_Sorry_this_functional#
</else>
</if>
<else>
   <% # The portal is shaded - should not be displayed %>
   <br>
</else>

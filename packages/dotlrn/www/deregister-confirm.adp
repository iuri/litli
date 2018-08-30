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
<property name="doc(title)">#dotlrn.Confirm_Drop#</property>

<h1>#dotlrn.Confirm_Drop#</h1>

<p>#dotlrn.lt_You_are_about_to_dele#</p>

<if @num_users@ lt 30>
	#dotlrn.lt_Note_This_process_is_#  
</if>
<else>
	#dotlrn.lt_Note_This_process_is__1#  
</else>

<p>
<if @num_users@ lt @num_users_display_limit@>
   #dotlrn.lt_Do_you_really_want_to#
</if>
<else>
   #dotlrn.lt_Do_you_really_want_to_1#
</else>
</p>
<form method="post" action="deregister" class="form-inline">
<input type="hidden" name="referer" value="@referer@">
@hidden_user_ids;noquote@
<ul>
<if @num_users@ lt 99>
 <multiple name="users_pending_drop">
 <li>@users_pending_drop.first_names@ @users_pending_drop.last_name@
 </multiple>
</if>
</ul>
	<input type="submit" value="#dotlrn.Yes#">
</form>
<form method="post" class="form-inline" action="@referer@" style="margin-top: 0px;">
	<input type="submit" value="#dotlrn.No#">
</form>

<p>
#dotlrn.lt_Note_The_script_will_#
</p>

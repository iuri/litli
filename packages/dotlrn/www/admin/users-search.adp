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
<property name="doc(title)">#dotlrn.Users_Search#</property>
<property name="context_bar">@context_bar;literal@</property>

<p></p>

<if @is_request@ ne 0>
    <formtemplate id="user_search"></formtemplate>
</if>
<else>
  <if @n_users@ gt 0>
    <formtemplate id="user_search_results">
    </formtemplate>
  </if>
  <else>
    <p>
      #dotlrn.lt_Your_search_returned_#
    </p>
  </else>
</else>




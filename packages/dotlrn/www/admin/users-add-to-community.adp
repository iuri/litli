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
<property name="doc(title)">#dotlrn.Add_Users_to_Group#</property>
<property name="context_bar">@context_bar;literal@</property>


<p style="color:red"><strong>#dotlrn.Note#</strong></p>

<p>#dotlrn.lt_This_action_will_take# <strong><%= [expr [llength $users] * 3] %></strong> #dotlrn.seconds#</p>

<formtemplate id="select_community"></formtemplate>




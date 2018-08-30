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

<!--
  @author Hector Amado (hr_amado@galileo.edu)
  @creation-date 2004-06-28
-->

<master src="dotlrn-admin-master">
<property name="doc(title)">#dotlrn.Administrators#</property>
<property name="context_bar">@context_bar;literal@</property>

<h1>#dotlrn.Administrators#</h1>

 <form method="get" action="admin-add">
   #dotlrn.Add_an_Admin# <input type="text" name="search_text"><input type="submit" value="#dotlrn.search#">
   <input type="hidden" name="referer" value="@referer@">
</form>

<listtemplate name="dotlrn_admins"></listtemplate>





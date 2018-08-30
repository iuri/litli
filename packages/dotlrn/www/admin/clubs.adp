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
<property name="doc(title)">@title;literal@</property>
<property name="context_bar">@context_bar;literal@</property>

<center>

  <br>

<if @clubs:rowcount@ gt 0>

  <listtemplate name="clubs"></listtemplate>

</if>
<else>
 </center>
 <p align="right"><a href="club-new" class="button">#dotlrn.new_community#</a> </p>
 <center>
 <table>
  <tr bgcolor="#eeeeee">
    <td align="left" colspan="4">
      <em>#dotlrn.no_communities#</em>
    </td>
  </tr>
 </table>
</else>
<br>
</center>

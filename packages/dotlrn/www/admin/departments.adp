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
    <br>
    <center>
      <form action="departments" method="GET">
        #dotlrn.Search_departments_with# 
	  <input name="keyword" placeholder="#dotlrn.Please_type_a_keyword#">
          <input type="submit" value="#dotlrn.Go#">
      </form>
    </center>
    <if @departments:rowcount@ gt 0>
        <br>
      <center>
	<listtemplate name="departments"></listtemplate>
      </center>
    </if>
    <else>
      
      <p align="right"><a href="department-new?referer=@referer@" class="button">#dotlrn.new_department#</a> </p>
      <center>
	<table>
	  <tr bgcolor="#eeeeee">
	    <td align="left" colspan="2">
	      <em>#dotlrn.no_departments#</em>
	    </td>
	  </tr>
	</table>
      </center>
    </else>
    
    <br>

      



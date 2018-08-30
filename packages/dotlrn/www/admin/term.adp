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

    <if @term_id@ ne -1>
      <ul>

	<li>
	  #dotlrn.Name#
	  @term_name@
	</li>

	<li>
	  #dotlrn.Year#
	  @term_year@
	</li>

	<li>
	  #dotlrn.Start_date#
	  @start_date@
	</li>

	<li>
	  #dotlrn.End_date#
	  @end_date@
	</li>

      </ul>
      <ul>

	  <li>
	    <a href="@term_edit_url@">#dotlrn.Edit#</a> #dotlrn.term_properties#
	  </li>

      </ul>

    </if>

    <center>

      <table bgcolor="#cccccc" cellpadding="5" width="95%">
	<tr bgcolor="#eeeeee">
	  <th align="left" width="50%">
	    <formtemplate id="department_form">
	      <%= [parameter::get -localize -parameter departments_pretty_name] %>:&nbsp;<formwidget id="department_key">
	    </formtemplate>
	  </th>
	  <th align="left" width="50%">
	    <formtemplate id="term_form">
	      #dotlrn.term#:&nbsp;<formwidget id="term_id">
	    </formtemplate>
	  </th>
	</tr>
      </table>

      <br>

	<if @classes:rowcount@ gt 0>
	  
	  <div style="text-align:center;">
	    <form action="term" method="GET">
	      #dotlrn.Search_classes_with# 
              <input name="keyword" placeholder="#dotlrn.Please_type_a_keyword#">
              <input type="hidden" name="term_id" value="@term_id@">
	      <input type="hidden" name="department_key" value="@department_key@">
              <input type="submit" value="#dotlrn.Go#">
	    </form>
	  </div>
      <br>
	  <listtemplate name="classes"></listtemplate>

	</if>
	<else>
	  <table>
	    <tr bgcolor="#eeeeee">
	      <td>
		<em>#dotlrn.no_class_instances#</em>
	      </td>
	    </tr>
	  </table>
	</else>

	<br>

    </center>

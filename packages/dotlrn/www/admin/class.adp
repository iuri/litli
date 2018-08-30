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
    <property name="doc(title)">@pretty_name;literal@</property>
    <property name="context_bar">@context_bar;literal@</property>

	<h1>#dotlrn.Subject# : @pretty_name@</h1>
	<p>#dotlrn.description#:
	
	<if @description@ not nil>
	  @description@
	</if>
	<else>
	  &lt;#dotlrn.no_description#&gt;
	</else>
	</p>


	  <a href="@class_edit_url@" class="button">#dotlrn.edit_subject_properties#</a>

	<br><br>

	  <formtemplate id="term_form">
	      #dotlrn.term#:&nbsp;<formwidget id="term_id">
	  </formtemplate>
	 
	<br>

	<if @can_instantiate@>
		  <a href="class-instance-new?class_key=@class_key@" class="button">#dotlrn.new_class_instance#</a> 
      </if>
      <else>
		<include src="need-term-note">
      </else>

      <br><br>
	  <form action="class" method="GET">
            #dotlrn.Search_classes_with#
            <input name="keyword" placeholder="#dotlrn.Please_type_a_keyword#">
            <input type="hidden" name="class_key" value="@class_key@">
            <input type="hidden" name="term_id" value="@term_id@">
            <input type="submit" value="#dotlrn.Go#">
	  </form>

<br>

	<if @class_instances:rowcount@ gt 0>
	  <listtemplate name="class_instances"></listtemplate>

	</if>
	<else>
	  <table>
	    <tr bgcolor="#eeeeee">
	      <td align="left" colspan="4">
		<em>#dotlrn.no_class_instances#</em>
	      </td>
	    </tr>
	  </table>
	</else>







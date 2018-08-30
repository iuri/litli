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

<h1>@title@</h1>

<if @archived_comms:rowcount@ gt 0>
	<div id="alert-message">
		<div class="alert">
			#dotlrn.Note_the_term_column#
		</div>
	</div>
<table width="100%">
  <tr>
    <th align="left" width="25%">#dotlrn.Parent#</th>
    <th align="left" width="50%">#dotlrn.Name#</th>
    <th align="left">#dotlrn.Description#</th>
    <th align="left">#dotlrn.Term#</th>
    <th align="left">#dotlrn.Created#</th>
    <th align="left">#dotlrn.Unarchive#</th>
  </tr>
<multiple name="archived_comms">
<if @archived_comms.rownum@ odd>
  <tr class="odd">
</if><else>
  <tr class="even">
</else>
    <td>
      <if @archived_comms.parent_community_id@ not eq ""><a href="@archived_comms.parent_url@">@archived_comms.parent_pretty_name@</a></if>
    </td>
    <td>
      <a href="@archived_comms.url@">@archived_comms.pretty_name@</a></td>
    <td>@archived_comms.description@</td>
    <td>
        @archived_comms.term_name@ @archived_comms.term_year@
        <% # look for a parent term if no child term is found %>
        <if @archived_comms.term_name@ eq "">@archived_comms.parent_term_name@ @archived_comms.parent_term_year@</if>
    </td>
    <td><em>@archived_comms.creation_date@</em></td>
    <td><em><a href="@archived_comms.unarchive_url@">#dotlrn.unarchive#</a></em></td>
  </tr>
</multiple>
</table>
</if>
<else>
  #dotlrn.no_arhived_groups#
</else>

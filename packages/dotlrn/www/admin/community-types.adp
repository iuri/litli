<master src="dotlrn-admin-master">
  <property name="doc(title)">@title;literal@</property>
  <property name="context_bar">@context_bar;literal@</property>
  
    <table cellpadding="5" width="95%">
      <tr>
	<td align="left">
	  <nobr>
	    <small>[
	      <a href="community-type">#dotlrn.new_community_type#</a>
	      ]</small>
	  </nobr>
	</td>
      </tr>
    </table>
    
    <br>
    <listtemplate name="community_types"></listtemplate>

    <if @community_types:rowcount@ gt 10>
      <br>

	<table cellpadding="5" width="95%">
	  <tr>
	    <td align="left">
	      <nobr>
		<small>[
		    <a href="community-type">#dotlrn.new_community_type#</a>
		  ]</small>
	      </nobr>
	    </td>
	  </tr>
	</table>
    </if>

	  

  <if @show_p;literal@ true>
    <table id="dotlrn-toolbar" cellspacing="0" cellpadding="0" width="100%" border="0" >
      <tr>
	<td id="title">
	  <a href="http://www.dotlrn.org/"> .LRN</a>
	</td>

	<td class="dt-action-list">
	  <a href="@dotlrn_url@" title="Dotlrn Home">Home</a>
	  <span style="color: #cccccc;">|</span>
	  
	  <a href="@dotlrn_admin_url@/terms" title="#dotlrn.Terms#">#dotlrn.Terms#</a>
	  <span style="color: #cccccc;">|</span>
	  
	  <a href="@dotlrn_admin_url@/departments" title="#dotlrn.departments_pretty_plural#">#dotlrn.departments_pretty_plural#</a>
	  <span style="color: #cccccc;">|</span>
	  
	  <a href="@dotlrn_admin_url@/classes" title="#dotlrn.classes_pretty_plural#">#dotlrn.classes_pretty_plural#</a>
	  <span style="color: #cccccc;">|</span>
	  
	  <a href="@dotlrn_admin_url@/term?term_id=-1" title="#dotlrn.Classes#">#dotlrn.Classes#</a>
	  <span style="color: #cccccc;">|</span>
	  
	  <a href="@dotlrn_admin_url@/clubs" title="#dotlrn.clubs_pretty_plural#">#dotlrn.clubs_pretty_plural#</a>
	  <span style="color: #cccccc;">|</span>

	  <a href="@dotlrn_admin_url@/users" title="#dotlrn.Users#">#dotlrn.Users#</a>
	  <span style="color: #cccccc;">|</span>

	  <a href="@dotlrn_admin_url@/" title="Dotlrn admin">#dotlrn.Admin#</a>
	  <span style="color: #cccccc;">|</span>
  
	  <a href="@info_url@" title="@info_title@">@info_title@</a>
	</td>
    <td id="search">
        <form action="@dotlrn_admin_url@/toolbar-actions" method="POST">
          <input type="hidden" name="action" value="search" />
          <label for="keyword">#dotlrn.Search#</label>
          <input id="keyword" name="keyword" placeholder="#dotlrn.Search_Text#" />
        in:<select name="search_type"><option value="users">#dotlrn.Users#</option><option value="departments">#dotlrn.departments_pretty_plural#</option><option value="subjects">#dotlrn.classes_pretty_plural#</option><option value="classes">#dotlrn.Classes#</option></select>
            <input type="submit" value="#dotlrn.Search#" />
        </form>
    </td>
	<td>
	  <a href="@hide_me_url@" style="font-size:80%;" title="Hide me">Hide me</a>
	</td>	
      </tr>
      
      <if @info_show_p;literal@ true>
	<tr>
	  <td colspan="4" class="general-info">
	    <ul>
	      <li><em>my user_id:</em> <span> @user_id@ </span> </li>
	      <li><em>context_id:</em> <span> @package_id@ </span></li>
	      <li><em>community_id:</em> <span> @community_id@  </span> </li>
	      <li><em>portal_id:</em> <span> @portal_id@ </span> </li>
          <li><em>package_id:</em> <span>@package_id@</span> </li>
	    </ul>
	  </td>
	</tr>
	
      </if>
    </table>
  </if>

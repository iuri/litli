<master>
<% set user_id [auth::require_login] %>
<% permission::require_permission -object_id $user_id -privilege admin %>
<h2>#dotlrn.Administration_Cockpit#</h2>
<table width="90%" id="context-bar">
<tr>
<td width="40%" VALIGN="top">
<listtemplate name="online_users"></listtemplate>
#dotlrn.Total_count# @count@
</td>
<td width="20%" VALIGN="top">
<ul>
<li><h2>@admin_pretty_name@</h2>
<ul>
<li><a href="/dotlrn/?">My Space</a>
<li><a href="/acs-admin/">OpenACS Admin</a>
<li><a href="/dotlrn/admin">DotLRN Admin</a>
<ul>
  <li><a href="/dotlrn/admin/terms">#dotlrn.Terms#</a></li>
  <li><a href="/dotlrn/admin/departments">#dotlrn.departments_pretty_plural#</a></li>
  <li><a href="/dotlrn/admin/classes">#dotlrn.classes_pretty_plural#</a></li>
  <li><a href="/dotlrn/admin/term?term_id=-1">#dotlrn.class_instances_pretty_plural#</a></li>
  <li><a href="/dotlrn/admin/clubs">#dotlrn.clubs_pretty_plural#</a></li>
  <li><a href="/dotlrn/admin/portal-templates">#dotlrn.portal_templates#</a></li>
  <li><a href="/dotlrn/admin/archived-communities">#dotlrn.Archive#</a></li>
  <li><a href="/dotlrn/admin/edit-preapproved-emails">#dotlrn.lt_Pre-approved_Email_Se#</a></li>
</ul>
</ul>
<li><h2>Packages</h2>
<ul>
<li><a href="/acs-admin/install">Install Packages</a>
<li><a href="/admin/applications/">Installed Applications</a>
<li><a href="/acs-service-contract/">Service Contracts</a>
</ul>
<li><h2>Site Structure</h2>
<ul>
<li><a href="/admin/site-map/">Site Map</a>
</ul>
</ul>

</td>
<td width="20%" VALIGN="top">
<ul>
<li><h2>Documentation</h2>
<ul>
<li><a href="/doc/">Open ACS Documentation</a>
<li><a href="/dotlrn/help">DotLRN Documentation</a>
<li><a href="http://openacs.org/doc/openacs-HEAD/">CVS Head</a>
<li><a href="http://openacs.org/packages/">Packages</a>
</ul>
<li><h2>User Management</h2>
<ul>
<li><a href="/acs-admin/auth">Authorities</a>
<li><a href="/acs-admin/users/">ACS Users</a>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="50%">
			<form method="post" action="/acs-admin/users/one">
			<input type="text" size="6" name="user_id" value="">
			<input type="submit" name="formbutton:ok" value="OK">
			</form>
		</td>
		<td width="50%">
			<FORM METHOD="get" ACTION="/acs-admin/users/search">
    			<input type="hidden" name="target" value="one">
    			<input type="hidden" name="only_authorized_p" value="0">
    			<input type="text" size="6" name="keyword">
                  	<input type="submit" value="Find">
  			</FORM>
		</td>
	</tr>
	</table>
<li><a href="/dotlrn/admin/users">DotLRN Users</a>
	<table border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<form method="post" action="/dotlrn/admin/user">
			<input type="text" size="6" name="user_id" value="">
			<input type="submit" name="formbutton:ok" value="OK">
			</form>
		</td>
	</tr>
	</table>
<li><a href="/members/">Members</a>
</ul>
<li><h2>User Monitoring</h2>
<ul>
<li><a href="/acs-admin/monitor">Active HTTP-Connections</a> | <a href="/monitor/monitor">Current Requests</a>
<li><a href="/shared/whos-online">User Online</a>
</ul>
<li><h2>System Monitor</h2>
<ul>
<li><a href="/procs-chunk.adp">Scheduled Procs</a>
<li><a href="/acs-admin/cache">Cache Info</a>
<li><a href="/acs-admin/cache/index">Util Memoize Caches</a>
<li><a href="/acs-service-contract/">Service Contracts</a>
<if @monitor_exists_p;literal@ true>
	<li><a href="@monitor_url@scheduled-procs">Scheduled Procs</a>
	<li>Watch Errors - Last
		<table><tr><td>
		<FORM ACTION=@monitor_url@watchdog/index>    
		  <INPUT NAME=kbytes SIZE=4 value="200">
          <INPUT TYPE=SUBMIT VALUE="KB">
		</FORM>
		</td>
		<td>
		<FORM ACTION=@monitor_url@watchdog/index>
		  <INPUT NAME=num_minutes SIZE=4 value="">
          <INPUT TYPE=SUBMIT VALUE="min">
		</FORM>
		</td></tr></table>
<li><a href="@monitor_url@filters">Filters</a>
<li><a href="@monitor_url@top/">Set Monitor System</a>
</if>
<li><a href="http://uptime.openacs.org/">Uptime Monitor</a>
</ul>
</ul>
</ul>
</td>
<td width="20%" VALIGN="top">
<ul>
<li><h2>Development</h2>
<ul>
<if @ds_exists_p;literal@ true>
	<li><a href="@ds_url@">Developer Support</a>(<a href="@ds_url@shell">Shell</a>)
</if>
<li><a href="http://openacs.org/bugtracker/openacs/">Bug Tracker</a>
<li><a href="/acs-admin/apm">Package Manager</a>
<li><a href="/api-doc/">API Browser</a>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="50%">
				   <table>
				     <tr bgcolor="#DDDDDD">
				      <form action="/api-doc/proc-search" method="get">
				      <td valign="top">
				       <strong>OpenACS Tcl API Search</strong>
				       <input type="text" size="16" name="query_string" value=""><br>
				       <input type="submit" value="All" name="search_type">
				       <input type="submit" value="Best" name="search_type">
				       <p><a href="/api-doc/proc-browse">Browse OpenACS Tcl API</a></p>
				      </td>
				      <td>       
				       <table cellspacing="0" cellpadding="0">
				         <tr><td align="right">Name contains:</td>
				           <td><input type="radio" name="name_weight" value="5" checked="checked"> </td></tr>
				         <tr><td align="right">Exact name:</td>
				           <td><input type="radio" name="name_weight" value="exact"></td></tr>
				         <tr><td align="right">&nbsp;</td><td>&nbsp;</td></tr>
				         <tr><td align="right">Parameters:</td>
				           <td><input type="checkbox" name="param_weight" value="3" checked="checked"></td></tr>
				         <tr><td align="right">Documentation:</td>
				           <td><input type="checkbox" name="doc_weight" value="2" checked="checked"></td></tr>
				         <tr><td align="right">Source:</td>
				           <td><input type="checkbox" name="source_weight" value="1"></td></tr>
				       </table>
				      </td>
				      </form>
				     </tr>				
				  <tr bgcolor="#DDDDDD">
				   <form action="/api-doc/tcl-proc-view" method="get">
				   <td colspan="2">
				    <strong>AOLserver Tcl API Search</strong>
				    <input type="text" size="6" name="tcl_proc">
				    <input type="submit" value="Go"><br>
				    (enter <em>exact</em> procedure name)<br>
				    <a href="http://www.aolserver.com/docs/devel/tcl/api/">Browse AOLserver Tcl API</a>
				   </td>
				   </form>
				  </tr>
				  <tr bgcolor="#DDDDDD">
				  <form action="/api-doc/tcl-doc-search" method="get">
				   <td colspan="2">
				    <strong>Tcl Documentation Search</strong>
				    <input type="text" size="6" name="tcl_proc">
				    <input type="submit" value="Go"><br>
				    (enter <em>exact</em> procedure name)<br>
				    <a href="http://tcl.tk/man/tcl8.3/TclCmd/contents.htm">Browse the Tcl documentation</a>
				   </td>
				   </form>
				  </tr>				 
				   <tr bgcolor="#DDDDDD">
				   <form action="http://www.postgresql.org/search.cgi" method="get">
				    <td colspan="2">
				       <strong>PostgreSQL 7.3 Search</strong>
				       <input type="hidden" name="ul" value="http://www.postgresql.org/docs/7.3/static/">
				       <input type="text" size="6" name="q">
				       <input type="submit" value="Go"><br>
				     	<a href="http://www.postgresql.org/docs/7.3/interactive/index.html">Browse the PostgreSQL 7.3 documentation</a>
				    </td>
				    </form>
				   </tr>
				</table>
			</td>
		</tr>
		</table>
<li><a href="/acs-lang/admin/">i18n Administration</a>
<li><a href="http://translate.openacs.org">Translation Server</a>
<li><a href="/test/admin">Automated Testing</a>
<li><a href="http://test.openacs.org/">Test Servers</a>
<li><a href="http://openacs.org/projects/dotlrn/download/">DotLRN-Download</a>
<li><a href="http://openacs.org/forums/">Forums</a>
<ul>
<li><a href="http://openacs.org/forums/forum-view?forum_id=14013">OpenACS Forum</a>
<li><a href="http://openacs.org/forums/forum-view?forum_id=14017">dotLRN Forum</a>
</ul>
</ul>
</ul>
</td>
</tr>
</table>

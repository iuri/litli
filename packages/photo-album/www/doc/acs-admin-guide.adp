
<property name="context">{/doc/photo-album {Photo Album}} {ACS Administration Guide}</property>
<property name="doc(title)">ACS Administration Guide</property>
<master>
<div class="NAVHEADER"><table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr><th colspan="3" align="center">Photo Album</th></tr><tr>
<td width="10%" align="left" valign="bottom"><a href="release-notes">Prev</a></td><td width="80%" align="center" valign="bottom"></td><td width="10%" align="right" valign="bottom"><a href="dev-guide">Next</a></td>
</tr>
</table></div>
<div class="chapter">
<h1><a name="acs-admin-guide" id="acs-admin-guide">Chapter 3. ACS
Administration Guide</a></h1><p>Installation and Operation Notes</p><ul>
<li><p class="listitem">
<em class="emphasis">Imagemagick</em> The
convert and identify binaries must be installed within the location
specified by the parameter ImageMagickPath. The user that the
webserver is running under must have execute privileges for the
files. A link to a download page for ImageMagick can be found in
the design document.</p></li><li><p class="listitem">
<em class="emphasis">Image Storage
Directory</em> The photo album store image binaries in the file
system. The webserver user must have read, write, and execute
privileges for the directory specified in the parameter PhotoDir.
This directory must be in the acs root directory for the server.
The webserver user must also have write privilege on any file
created in this directory or it will not be able to delete
images.</p></li><li><p class="listitem">
<em class="emphasis">Permission Checks for
Serving Images</em> The parameter CheckPermissionOnImageServeP
controls if images/index.vuh queries the database to check if user
has read permission on a photo prior to serving it. Setting this to
true will slow server performance because it causes an extra trip
to the database for every image served. Default album pages serve
12 thumbnails per page, which translates into 12 extra trips to the
database. Users should not be presented a link/img tag for an image
for which they do not have read privileges. Unless you are really
concerned about someone url hacking to a private image (which they
would need to know the full path), I suggest leaving this parameter
set to false.</p></li>
</ul>
</div>
<div class="NAVFOOTER">
<hr size="1" noshade="noshade" align="left" width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
<td width="33%" align="left" valign="top"><a href="release-notes">Prev</a></td><td width="34%" align="center" valign="top"><a href="index">Home</a></td><td width="33%" align="right" valign="top"><a href="dev-guide">Next</a></td>
</tr><tr>
<td width="33%" align="left" valign="top">Release Notes for Photo
Album 4.0.1 Final Release</td><td width="34%" align="center" valign="top"> </td><td width="33%" align="right" valign="top">Developer&#39;s
guide</td>
</tr>
</table>
</div>

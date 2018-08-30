
<property name="context">{/doc/photo-album {Photo Album}} {Release Notes for Photo Album 4.0.1 Final Release}</property>
<property name="doc(title)">Release Notes for Photo Album 4.0.1 Final Release</property>
<master>
<div class="NAVHEADER"><table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr><th colspan="3" align="center">Photo Album</th></tr><tr>
<td width="10%" align="left" valign="bottom"><a href="for-everyone">Prev</a></td><td width="80%" align="center" valign="bottom"></td><td width="10%" align="right" valign="bottom"><a href="acs-admin-guide">Next</a></td>
</tr>
</table></div>
<div class="chapter">
<h1><a name="release-notes" id="release-notes">Chapter 2. Release
Notes for Photo Album 4.0.1 Final Release</a></h1><p>Changes from 4.0.1 beta to 4.0.1 final.</p><ul>
<li><p class="listitem">Removed photo level permission checks. Load
testing showed that allowing different photos within the same album
to have different permissions made the queries to get the photos in
a large album very slow. I changed the application logic so that
all photos in album have same permission and permission check is
done at the album level.</p></li><li><p class="listitem">Tunned numerous queries base on load testing
results against a database filed with 10,000 photos.</p></li><li><p class="listitem">Made compatible with acs-kernal 4.1.1 and
acs-templating 4.1.</p></li><li><p class="listitem">Added caching of primary keys of photos in an
album and package root folder_id.</p></li><li><p class="listitem">Added optional permission check when serving
images.</p></li><li><p class="listitem">Added separate optional page to display the
base sized photo.</p></li><li><p class="listitem">When uploading a photo, the thumbnail is now
created from the viewer sized image rather from the base sized
image. Creating a small image from a medium-sized image is much
faster than creating a small image from a large image and does not
noticeably change the image quality.</p></li><li><p class="listitem">Minor revisions to plsql packages to improve
compatibility with acs-content-repository.</p></li><li><p class="listitem">Added more detailed documentation in both html
and docbook format.</p></li><li><p class="listitem">Fixed name conflicts with photo album lite.</p></li>
</ul><p>Besides upgrading the rest of your acs intall to 4.1.1, you will
need to mannually run <tt class="computeroutput">photo-album/sql/plsql-packages.sql</tt> through
sqlplus to update the packages inside oracle when upgrading from
the beta to final version of the photo-album.</p>
</div>
<div class="NAVFOOTER">
<hr size="1" noshade="noshade" align="left" width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
<td width="33%" align="left" valign="top"><a href="for-everyone">Prev</a></td><td width="34%" align="center" valign="top"><a href="index">Home</a></td><td width="33%" align="right" valign="top"><a href="acs-admin-guide">Next</a></td>
</tr><tr>
<td width="33%" align="left" valign="top">Introduction</td><td width="34%" align="center" valign="top"> </td><td width="33%" align="right" valign="top">ACS Administration
Guide</td>
</tr>
</table>
</div>


<property name="context">{/doc/photo-album {Photo Album}} {ACS 4 Photo Album Package Design Documentation}</property>
<property name="doc(title)">ACS 4 Photo Album Package Design Documentation</property>
<master>
<div class="NAVHEADER"><table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr><th colspan="3" align="center">Photo Album</th></tr><tr>
<td width="10%" align="left" valign="bottom"><a href="dev-guide">Prev</a></td><td width="80%" align="center" valign="bottom">Chapter 4.
Developer&#39;s guide</td><td width="10%" align="right" valign="bottom"> </td>
</tr>
</table></div>
<div class="sect1">
<h1 class="sect1"><a name="design" id="design">4.2. ACS 4 Photo
Album Package Design Documentation</a></h1><div class="TOC"><dl>
<dt><strong>Table of Contents</strong></dt><dt>4.2.1. <a href="design">Essentials</a>
</dt><dt>4.2.2. <a href="design">Introduction</a>
</dt><dt>4.2.3. <a href="design">Historical
Considerations</a>
</dt><dt>4.2.4. <a href="design">Competitive
Analysis</a>
</dt><dt>4.2.5. <a href="design">Design
Tradeoffs</a>
</dt><dt>4.2.6. <a href="design">API</a>
</dt><dd><dl>
<dt>4.2.6.1. <a href="design">PL/SQL
API</a>
</dt><dt>4.2.6.2. <a href="design">Procedural
API</a>
</dt>
</dl></dd><dt>4.2.7. <a href="design">Data
Model Discussion</a>
</dt><dt>4.2.8. <a href="design">User
Interface</a>
</dt><dt>4.2.9. <a href="design">Configuration/Parameters</a>
</dt><dt>4.2.10. <a href="design">Future
Improvements/Areas of Likely Change</a>
</dt><dt>4.2.11. <a href="design">Authors</a>
</dt><dt>4.2.12. <a href="design">Revision
History</a>
</dt>
</dl></div><p>by Tom Baginski, <a href="mailto:bags\@arsdigta.com" target="_top">bags\@arsdigita.com</a>
</p><div class="sect2">
<h2 class="sect2"><a name="design-essentials" id="design-essentials">4.2.1. Essentials</a></h2><ul>
<li><p class="listitem">User accessible directory depends on where
package is mounted in site.</p></li><li><p class="listitem">No separate administration directories</p></li><li><p class="listitem">Tcl procedures:
packages/photo-album/tcl/photo-album-procs.tcl (link to proc
depends on install)</p></li><li><p class="listitem">Data model:
packages/photo-album/sql/photo-album-create.sql (link to data model
depends on install)</p></li><li><p class="listitem"><a href="dev-guide">ACS 4.0
Photo Album Application Requirements</a></p></li>
</ul>
</div><div class="sect2">
<h2 class="sect2"><a name="design-introduction" id="design-introduction">4.2.2. Introduction</a></h2><p>The basic content element of the photo album system is a photo.
When a user uploads a photo, the system stores attribute data such
as caption, story, and title as a single content element. Each
photo associated with several (three to start) image elements that
store the actual binary files. The image elements, which are
created by the server, are standard sized versions of the original
photo used for display. Photos and images can have descriptive
attributes associated with them. The attributes and binary files
can be revised and the system will retain past versions.</p><p>Photos are grouped together into albums which can contain 0 or
more photos. The albums can have descriptive attribute information
that can be revised with history tracking. The albums can be
displayed as a unit that allows user to browse through the photos
in the album.</p><p>Albums can be grouped together into folders that can contain 0
or more albums or other folders.</p><p>An instance of the package include pages to display the folders,
albums, and photos along with admin pages. Instances can be mounted
to different subsite and managed independently. The grouping is
included within the instance so that the albums maintain a
consistent url even if they are re-sorted to different folders
within the instance (as long as the subsite url isn&#39;t
changed).</p><p>The display, grouping, and administration functionality of the
photo album package will be included in the initial release of the
package. This is intended to be one part of a larger system that
will allow bulk uploading and purchasing of photos. These two
feature have already been implemented on aD customer sites. ACS 4
versions of these features will be either incorporated into a
future version of the photo album package or added as individual
packages that depend on the photo album.</p><p>The basic tasks of the photo album revolve around storing and
displaying content and associated attributes. As such, this package
will take advantage of the exiting features of the content
repository service package. The content repository can store
multiple revisions of content items such as photos and images and
their associated attributes. The content repository also provides
grouping functions. The acs permission service will be used for
access control so view, edit, and administration privileges will be
highly customizable. Finally individual photo album instances can
be added to subsites to support multiple independent photo albums
on the same site.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="design-historical-considerations" id="design-historical-considerations">4.2.3. Historical
Considerations</a></h2><p>The the development of photo album package was base largely on
the experience of building a custom photo album application for the
Iluvcamp client site. The Iluvcamp photo album was built using an
early version of the content repository. The photo album package
uses the current version of the ACS content repository and takes
advantage of several key features of the ACS4 structure such as
permissions, templating, the content repository. The photo album
package avoid several of the limitation of the Iluvcamp Photo Album
that were made clear after supporting a summer of use and uploading
over 70GB of original photos.</p><p>A photodb application was developed for ACS 3.x. The option of
porting the photodb application to ACS4 was not followed due to the
customized nature of the photodb application. It was primarily
designed for storing and displaying information about photos for
photographers. In contrast, the photo album application provides a
general system for storing and displaying user uploaded photos,
which can be customized to any particular client application.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="design-competitive-analysis" id="design-competitive-analysis">4.2.4. Competitive Analysis</a></h2><p>Not done. A google search for "photo album web
application" returns links for several shareware photo album
applications. I did not install or test any of these.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="design-design-tradeoffs" id="design-design-tradeoffs">4.2.5. Design Tradeoffs</a></h2><p>The package uses/requires the convert and identify <a href="http://www.simplesystems.org/ImageMagick/" target="_top">ImageMagick</a> binaries to be installed on the host
computer at the location specified in the ImageMagickPath
parameter. ImageMagick is readily available and easy to use from
within server pages. ImageMagick is copyrighted by ImageMagick
Studio, a nonprofit organization. ImageMagick is available for
free, may be used to support both open and proprietary
applications, and may be redistributed without fee. The previous
ImageMagick Homepage has some mention of LZW patent issues and
redirects to a new location. If these patent issues become a
problem, the package will need to be re-coded to use different
image manipulation software.</p><p>By default the package stores the image binary files in the file
system. This decision was made for ease of use and development.
This was also based on the assumption that file system storage is
more appropriate for large systems with many giga-bytes of photos.
The content repository also provides support for database storage
of binaries in blobs. Future version of the photo album will also
support database storage of photos. Load testing will be used to
determine the most appropriate storage method for small and large
volumes of photos.</p><p>The default photo storage directory is outside of the page root
and images are served using a .vuh file. This was done to prevent
potential execution of user uploaded files. Although the package
checks that the user only uploads image files, in theory a rouge
user could upload a code file. If that file was directly accessible
from the page root, the rouge user could execute arbitrary code
with all the authority of the web server user. Serving the image
through a .vuh file also allows for checking access permissions to
a file before it is served to the user. The benefits of serving
image files with a .vuh file comes at a cost of some additional
server resources. Again, load testing will be used to determine the
true cost of using a .vuh file.</p><p>The photo attribute information and binary files are stored in
two different content types (pa_photos and pa_images). The linkage
between the binaries and the attribute info is maintained as a
relationship between the two content_items. This decision was made
so the the number of image sizes per photo could be changed with
minor code revision and no datamodel changes. This flexibility
comes at a cost, the queries to retrieve and serve the appropriate
version of a photo need to join in several tables to do so. There
also is not an easy way to store the relation between different
versions of the photo-attribute info such as caption and the
versions of the binaries.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="design-api" id="design-api">4.2.6.
API</a></h2><div class="sect3">
<h3 class="sect3"><a name="design-plsql-api" id="design-plsql-api">4.2.6.1. PL/SQL API</a></h3><p>The PL/SQL database api is incorporated into four packages:
pa_image, pa_photo, pa_album, and photo_album. The first three
correspond to the 3 new object types created for the photo album
application. The last contains general database functions for the
application.</p><ul>
<li>
<p class="listitem">pa_image package</p><ul>
<li>
<p class="listitem">
<tt class="computeroutput">pa_image.new</tt>
creates a new pa_image object type and returns the cr_item.item_id
of the newly created object. It also create the first revision of
that object. It accepts an item_id and revision_id as arguments but
both will be created if not provided. Although relation tag
defaults to null it should be in (thumb, viewer, base). Path is the
path to the image binary relative to the upload base (a
parameterized directory).</p><pre class="programlisting">
    
      function new (
        name            in cr_items.name%TYPE,
        parent_id               in cr_items.parent_id%TYPE default null,
        item_id         in acs_objects.object_id%TYPE default null,
        revision_id             in acs_objects.object_id%TYPE default null,
        content_type    in acs_object_types.object_type%TYPE default 'pa_image',
        creation_date   in acs_objects.creation_date%TYPE default sysdate, 
        creation_user   in acs_objects.creation_user%TYPE default null, 
        creation_ip             in acs_objects.creation_ip%TYPE default null, 
        locale          in cr_items.locale%TYPE default null,
        context_id              in acs_objects.context_id%TYPE default null,
        title           in cr_revisions.title%TYPE default null,
        description             in cr_revisions.description%TYPE default null,
        mime_type               in cr_revisions.mime_type%TYPE default null,
        nls_language    in cr_revisions.nls_language%TYPE default null,
        relation_tag    in cr_child_rels.relation_tag%TYPE default null,
        is_live         in char default 'f',
        publish_date    in cr_revisions.publish_date%TYPE default sysdate,
        path            in pa_images.path%TYPE,
        height          in pa_images.height%TYPE default null,
        width           in pa_images.width%TYPE default null,
        file_size               in pa_images.file_size%TYPE default null
      ) return cr_items.item_id%TYPE;
     
                  
</pre>
</li><li>
<p class="listitem">
<tt class="computeroutput">pa_image.delte_revision</tt> deletes a specified
revision of a pa_image and schedules the binary for deleation from
the file-system by a sweep procedure</p><pre class="programlisting">
    
      procedure delete_revision (
        revision_id             in cr_revisions.revision_id%TYPE
      );
                  
</pre>
</li><li>
<p class="listitem">
<tt class="computeroutput">pa_image.delete</tt>
deletes a pa_image and all revisions Also schedules the binary
files for deletion from the file-system.</p><pre class="programlisting">
    
      procedure delete (
        item_id         in cr_items.item_id%TYPE
      );
                  
</pre>
</li>
</ul>
</li><li>
<p class="listitem">pa_photo package</p><ul>
<li>
<p class="listitem">
<tt class="computeroutput">pa_photo.new</tt>
create a new pa_photo object and returns the cr_item.item_id of the
new object. Also creates first revision of object</p><pre class="programlisting">
    
      function new (
        name            in cr_items.name%TYPE,
        parent_id               in cr_items.parent_id%TYPE default null,
        item_id         in acs_objects.object_id%TYPE default null,
        revision_id             in acs_objects.object_id%TYPE default null,
        content_type    in acs_object_types.object_type%TYPE default 'pa_photo',
        creation_date   in acs_objects.creation_date%TYPE default sysdate, 
        creation_user   in acs_objects.creation_user%TYPE default null, 
        creation_ip             in acs_objects.creation_ip%TYPE default null, 
        locale          in cr_items.locale%TYPE default null,
        context_id              in acs_objects.context_id%TYPE default null,
        title           in cr_revisions.title%TYPE default null,
        description             in cr_revisions.description%TYPE default null,
        relation_tag    in cr_child_rels.relation_tag%TYPE default null,
        is_live         in char default 'f',
        publish_date    in cr_revisions.publish_date%TYPE default sysdate,
        mime_type               in cr_revisions.mime_type%TYPE default null,
        nls_language    in cr_revisions.nls_language%TYPE default null,
        caption         in pa_photos.caption%TYPE default null,
        story           in pa_photos.story%TYPE default null,
        user_filename   in pa_photos.user_filename%TYPE default null
      ) return cr_items.item_id%TYPE;
                  
</pre>
</li><li>
<p class="listitem">
<tt class="computeroutput">pa_photo.delete_revision</tt> deletes a specified
revision of a pa_photo</p><pre class="programlisting">
    
      procedure delete_revision (
        revision_id             in acs_objects.object_id%TYPE
      );
                  
</pre>
</li><li>
<p class="listitem">
<tt class="computeroutput">pa_photo.delete</tt>
deletes a pa_photo object, all revision of a pa_photo, and all
associated pa_images (including binaries). Basically nukes a photo,
so be careful using this one, because it can&#39;t be undone.</p><pre class="programlisting">
    
      procedure delete (
        item_id             in acs_objects.object_id%TYPE
      );
                  
</pre>
</li>
</ul>
</li><li>
<p class="listitem">pa_album package</p><ul>
<li>
<p class="listitem">
<tt class="computeroutput">pa_album.new</tt>
creates a new pa_album object type and returns the cr_item.item_id
of the newly created object. It also create the first revision of
that object. It accepts an item_id and revision_id as arguments but
both will be created if not provided.</p><pre class="programlisting">
    
      function new (
         name           in cr_items.name%TYPE,
         album_id       in cr_items.item_id%TYPE default null,
         parent_id          in cr_items.parent_id%TYPE default null,
         revision_id    in cr_revisions.revision_id%TYPE default null,
         content_type   in acs_object_types.object_type%TYPE default 'pa_album',
         is_live            in char default 'f',
         creation_date  in acs_objects.creation_date%TYPE default sysdate, 
         creation_user  in acs_objects.creation_user%TYPE default null, 
         creation_ip    in acs_objects.creation_ip%TYPE default null, 
         locale     in cr_items.locale%TYPE default null,
         context_id         in acs_objects.context_id%TYPE default null,
         relation_tag   in cr_child_rels.relation_tag%TYPE default null,
         publish_date   in cr_revisions.publish_date%TYPE default sysdate,
         mime_type      in cr_revisions.mime_type%TYPE default null,
         nls_language   in cr_revisions.nls_language%TYPE default null,
         title      in cr_revisions.title%TYPE default null,
         description    in cr_revisions.description%TYPE default null,
         story      in pa_albums.story%TYPE default null
      ) return cr_items.item_id%TYPE;
                  
</pre>
</li><li>
<p class="listitem">
<tt class="computeroutput">pa_album.delte_revision</tt> deletes a specified
revision of a pa_album</p><pre class="programlisting">
    
      procedure delete_revision (
        revision_id             in cr_revisions.revision_id%TYPE
      );
                  
</pre>
</li><li>
<p class="listitem">
<tt class="computeroutput">pa_album.delete</tt>
deletes a pa_album and all revisions of that album. The album must
not have any child pa_phots or the delete throws an error. So there
is nothing equilent to <tt class="computeroutput">rm -r *</tt>. You
separately delete the photos in an album (or move them to a
different album) then delete the album.</p><pre class="programlisting">
    
      procedure delete (
        album_id                in cr_items.item_id%TYPE
      );
                  
</pre>
</li>
</ul>
</li><li>
<p class="listitem">photo_album package</p><ul><li>
<p class="listitem">
<tt class="computeroutput">photo_album.get_root_folder</tt> returns the root
folder for a given package_id (package instance). The root folder
for a package is actually cached by the web server. So it is
probably faster to call the server proc pa_get_root_folder and pass
the value in as a bind variable any place you need the root_folder
in a query.</p><pre class="programlisting">
    
      function get_root_folder (
          package_id in apm_packages.package_id%TYPE
      ) return pa_package_root_folder_map.folder_id%TYPE;
                  
</pre>
</li></ul>
</li>
</ul>
</div><div class="sect3">
<h3 class="sect3"><a name="design-procedure-api" id="design-procedure-api">4.2.6.2. Procedural API</a></h3><p>The public procedural API available from the webserver is
currently implemented as tcl procedures.</p><ul>
<li><p class="listitem">
<tt class="computeroutput">pa_get_root_folder
{package_id ""}</tt> Returns the folder_id of the root
folder for an instance of the photo album system. If no root folder
exists, as when a new package instance is accessed for the first
time, a new root folder is created automatically with appropriate
permissions If value has be previously requested, value pulled from
cache. If pakage_id is not specified, procedure uses value from
<tt class="computeroutput">[ad_conn package_id]</tt>
</p></li><li><p class="listitem">
<tt class="computeroutput">pa_context_bar_list
{-final ""} item_id</tt> Constructs the list to be fed to
ad_context_bar appropriate for item_id. If -final is specified,
that string will be the last item in the context bar. Otherwise,
the name corresponding to item_id will be used.</p></li><li><p class="listitem">
<tt class="computeroutput">pa_make_file_name
{-assert:boolean} {-ext ""} id</tt> Constructs a filename
for an image based on id and extension. Files are created into a 3
tier directory structure: year/xx/zz/ for a photo_id 1234xxzz.jpg
Same file would return year/xx/zz/1234xxzz.jpg. If -assert
specified, proc creates directory and any parent directories if
necessary</p></li><li><p class="listitem">
<tt class="computeroutput">pa_is_folder_p
folder_id {package_id ""}</tt> Returns "t" if
folder_id is a folder that is a child of the root folder for the
package, else "f". If package_id is not given procedure
uses value from <tt class="computeroutput"> [ad_conn
package_id]</tt>.</p></li><li><p class="listitem">
<tt class="computeroutput">pa_is_album_p
album_id {package_id ""}</tt> Returns "t" if
album_id is a album that is a child of the root folder for the
package, else "f" If package_id is not given procedure
uses value from <tt class="computeroutput"> [ad_conn
package_id]</tt>.</p></li><li><p class="listitem">
<tt class="computeroutput">pa_is_photo_p
photo_id {package_id ""}</tt> Returns "t" if
photo_id is a photo that is a child of the root folder for the
package, else "f" If package_id is not given procedure
uses value from <tt class="computeroutput"> [ad_conn
package_id]</tt>.</p></li><li><p class="listitem">
<tt class="computeroutput">pa_grant_privilege_to_creator object_id {user_id
""}</tt> Grants a set of default privileges stored in
parameter PrivilegeForCreator on object id to user_id. If user_id
is not specified, uses current user.</p></li><li><p class="listitem">
<tt class="computeroutput">pa_image_width_height filename width_var
height_var</tt> Uses ImageMagick program to get the width and
height in pixels of filename. Sets height to the variable named in
height_var in the calling level. Sets width_var to the variable
named in width_var in the calling level. I Use ImageMagick instead
of aolsever funcition because it can handle more than just gifs and
jpegs.</p></li><li><p class="listitem">
<tt class="computeroutput">pa_make_new_image
base_image new_image max_width {max_height ""}</tt> Uses
ImageMagick program to create a file named new_image from
base_image that fits within a box defined by max_width by
max_height (in pixels). ImageMagick will retain the aspect ratio of
the base_image when creating the new_image If max_height is not
specified, max_width is used for max_height.</p></li><li><p class="listitem">
<tt class="computeroutput">pa_all_photos_in_album album_id</tt> Returns a
list of all the photo_ids in an album sorted in ascending order.
Pulls value from cache if already there, caches result and returns
result if not</p></li><li><p class="listitem">
<tt class="computeroutput">pa_count_photos_in_album album_id</tt> Returns
count of number of photos in album_id</p></li><li><p class="listitem">
<tt class="computeroutput">pa_all_photos_on_page album_id page</tt> Returns a
list of the photo_ids on page page of album_id. List is in
ascending order</p></li><li><p class="listitem">
<tt class="computeroutput">pa_count_pages_in_album album_id</tt> Returns the
number of pages in album_id</p></li><li><p class="listitem">
<tt class="computeroutput">pa_page_of_photo_in_album photo_id album_id</tt>
Returns the page number of a photo in an album. If photo is not in
the album returns -1</p></li><li><p class="listitem">
<tt class="computeroutput">pa_flush_photo_in_album_cache album_id</tt> Clears
the cacheed value set by pa_all_photos_in_album for a single album
Call proc on any page that alters the number or order of photos in
an album.</p></li><li><p class="listitem">
<tt class="computeroutput">pa_pagination_page_number_links page
total_pages</tt> Returns html table fragament for navigating pages
of an album.</p></li><li><p class="listitem">
<tt class="computeroutput">pa_photo_number_links cur_id all_ids</tt> Given a
current photo_id and and an ordered list of all the photo_id in an
album, creates an html fragment that allows user to navigate to any
photo by number, or next/previous. Pulls url from connection so
should work on page showing a single photo based on photo_id (such
as viewer size display page or base size display page).</p></li>
</ul>
</div>
</div><div class="sect2">
<h2 class="sect2"><a name="design-data-model-discussion" id="design-data-model-discussion">4.2.7. Data Model
Discussion</a></h2><p>The data model defines 3 new content types within the content
repository. These are pa_album, pa_photo, and pa_image. It uses the
exiting content_folder for grouping pa_albums. Pa_albums store
attribute information about a group of photos and serves as a
container for 0 or more photos. Pa_photos store attributes of user
uploaded photo. Pa_images are used as a helper type to store the
base (original), thumbnail and viewer display images associated
with a pa_photo. Each pa_photo has one child pa_image for its base
photo, one for its thumbnail image, and one child pa_image for its
viewer image. The pa_images are created by the server whenever a
pa_photo is added or edited.</p><p>The root folder for each package instance is stored in
pa_root_folder_package_map. All folders, albums, photos, and images
within a package instance are descendants of the root folder for
that package.</p><p>Image files scheduled for deletion are stored in
pa_files_to_delete. A nightly web-server process deletes the files
in this table and then removes them from the table. This table
allows images to be deleted transactionally from both the database
and the file-system. All photo/image delete operations should add
the binary file-name to pa_files_to_delete and then delete the
attribute information in the database within a transaction. This
way the file system delete will not happen unless the database
delete succeeds.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="design-user-interface" id="design-user-interface">4.2.8. User Interface</a></h2><p>The user accessible pages contain a set of pages for displaying,
adding, and editing folders, albums, and photos. The folder page
which serves as the index page allows a user to navigate to
sub-folders and albums within the folder. The album page displays
the photos (or a sub-set of photos) within an album. The photo page
displays a single photo.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="design-configurationparameters" id="design-configurationparameters">4.2.9.
Configuration/Parameters</a></h2><p>Parameters are set by default through the apm and can be edited
by a user with admin privileges for a sub-site through the current
sub-site admin pages. Depending on which version of the apm is
installed, the server may need to be restarted for the parameters
of a new package instance are available.</p><p>The defined parameters are as follows:</p><div class="variablelist"><dl>
<dt class="listitem"><tt class="varname">ImageMagickPath</tt></dt><dd>
<p class="listitem">Description: Absolute path from computer root
to directory containing ImageMagick executables convert and
identify.</p><p class="listitem">Default: /usr/local/bin</p>
</dd><dt class="listitem"><tt class="varname">PhotoDir</tt></dt><dd>
<p class="listitem">Description: Relative path from acs_root_dir to
directory for storing uploaded images. (do not include leading or
trailing forward slash)</p><p class="listitem">Default: uploaded-photos</p>
</dd><dt class="listitem"><tt class="varname">FullTempDir</tt></dt><dd>
<p class="listitem">Description: Absolute path from computer root
to path for temporary photos.</p><p class="listitem">Default: /tmp/photo-album</p>
</dd><dt class="listitem"><tt class="varname">PhotoStorageMethod</tt></dt><dd>
<p class="listitem">Description: Default method for storing photos,
file-system or database. (Package currently only supports
file-system)</p><p class="listitem">Default: file-system</p>
</dd><dt class="listitem"><tt class="varname">ThumbnailSize</tt></dt><dd>
<p class="listitem">Description: Max Dimension for thumbnail
image</p><p class="listitem">Default: 100</p>
</dd><dt class="listitem"><tt class="varname">ViewerSize</tt></dt><dd>
<p class="listitem">Description: Max Dimension for viewer
images</p><p class="listitem">Default: 400</p>
</dd><dt class="listitem"><tt class="varname">ThumbnailsPerPage</tt></dt><dd>
<p class="listitem">Description: Number of thumbnail images to be
displayed per album page</p><p class="listitem">Default: 12</p>
</dd><dt class="listitem"><tt class="varname">PrivilegeForCreator</tt></dt><dd>
<p class="listitem">Description: CSV of privileges to grant to
creators of new objects within photo album</p><p class="listitem">Default: admin</p>
</dd><dt class="listitem"><tt class="varname">AcceptableUploadMIMETypes</tt></dt><dd>
<p class="listitem">Description: CSV of acceptable MIME Types for
Photo Upload</p><p class="listitem">Default: image/jpeg,image/gif</p>
</dd><dt class="listitem"><tt class="varname">DefaultRootFolderPrivileges</tt></dt><dd>
<p class="listitem">Description: List of grantee privilege pairs
for new root folders. Grantee is an integer or function that
returns a party_id. Format as a space separated list</p><p class="listitem">Default:
acs.magic_object_id('the_public') read
acs.magic_object_id('registered_users') pa_create_album
acs.magic_object_id('registered_users')
pa_create_folder</p>
</dd><dt class="listitem"><tt class="varname">AllowBasePhotoAccessP</tt></dt><dd>
<p class="listitem">Description: If set to "t", users are
presented a link to display the full sized base image from photo
page.</p><p class="listitem">Default: t</p>
</dd><dt class="listitem"><tt class="varname">CheckPermissionOnImageServeP</tt></dt><dd>
<p class="listitem">If set to "t", the images/index.vuh
file runs a query to check if user has read access to photo prior
to serving it. Note, setting to "t" can impact
performance on high volume sites. The urls for images also change
depending on this parameter. If "t" url contains the
pa_image_id, else contains the path to the pa_image in
file-system.</p><p class="listitem">Default: f</p>
</dd>
</dl></div>
</div><div class="sect2">
<h2 class="sect2"><a name="design-future-improvementsareas-of-likely-change" id="design-future-improvementsareas-of-likely-change">4.2.10. Future
Improvements/Areas of Likely Change</a></h2><ul>
<li><p class="listitem">Server backed image manipulation</p></li><li><p class="listitem">Purchase and printing of photo through
ecommerce package and photo printing vendor.</p></li><li><p class="listitem">Bulk upload tool</p></li><li><p class="listitem">User specified attributes</p></li><li><p class="listitem">Upload quotas</p></li><li><p class="listitem">Admin notification of file space
limitations.</p></li><li><p class="listitem">Search and retrieval of photos and albums based
on attributes or key words.</p></li><li><p class="listitem">Admin specified attributes</p></li>
</ul>
</div><div class="sect2">
<h2 class="sect2"><a name="design-authors" id="design-authors">4.2.11. Authors</a></h2><ul><li><p class="listitem">System creator, System owner, and Documentation
author: Tom Baginski, bags\@arsdigita.com</p></li></ul>
</div><div class="sect2">
<h2 class="sect2"><a name="design-revision-history" id="design-revision-history">4.2.12. Revision History</a></h2><div class="informaltable">
<a name="AEN586" id="AEN586"></a><table border="1" class="CALSTABLE" cellpadding="10">
<thead><tr>
<th align="center" valign="middle">Document Revision #</th><th align="center" valign="middle">Action Taken, Notes</th><th align="center" valign="middle">When?</th><th align="center" valign="middle">By Whom?</th>
</tr></thead><tbody>
<tr>
<td align="left" valign="middle">0.1</td><td align="left" valign="middle">Creation</td><td align="left" valign="middle">12/17/2000</td><td align="left" valign="middle">Tom Baginski</td>
</tr><tr>
<td align="left" valign="middle">0.2</td><td align="left" valign="middle">Editing</td><td align="left" valign="middle">1/9/2001</td><td align="left" valign="middle">Tom Baginski</td>
</tr><tr>
<td align="left" valign="middle">0.3</td><td align="left" valign="middle">Editing and additions to API and
Data Model sections.</td><td align="left" valign="middle">2/5/2001</td><td align="left" valign="middle">Tom Baginski</td>
</tr>
</tbody>
</table>
</div><p><a href="mailto:bags\@arsdigita.com" target="_top">bags\@arsdigita.com</a></p>
</div>
</div>
<div class="NAVFOOTER">
<hr size="1" noshade="noshade" align="left" width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
<td width="33%" align="left" valign="top"><a href="dev-guide">Prev</a></td><td width="34%" align="center" valign="top"><a href="index">Home</a></td><td width="33%" align="right" valign="top"> </td>
</tr><tr>
<td width="33%" align="left" valign="top">Developer&#39;s
guide</td><td width="34%" align="center" valign="top"><a href="dev-guide">Up</a></td><td width="33%" align="right" valign="top"> </td>
</tr>
</table>
</div>

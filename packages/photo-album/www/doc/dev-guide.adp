
<property name="context">{/doc/photo-album {Photo Album}} {Developer&#39;s guide}</property>
<property name="doc(title)">Developer&#39;s guide</property>
<master>
<div class="NAVHEADER"><table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr><th colspan="3" align="center">Photo Album</th></tr><tr>
<td width="10%" align="left" valign="bottom"><a href="acs-admin-guide">Prev</a></td><td width="80%" align="center" valign="bottom"></td><td width="10%" align="right" valign="bottom"><a href="design">Next</a></td>
</tr>
</table></div>
<div class="chapter">
<h1><a name="dev-guide" id="dev-guide">Chapter 4. Developer&#39;s
guide</a></h1><div class="sect1">
<h1 class="sect1"><a name="requirements" id="requirements">4.1. ACS
4.0 Photo Album Application Requirements</a></h1><div class="TOC"><dl>
<dt><strong>Table of Contents</strong></dt><dt>4.1.1. <a href="dev-guide">Introduction</a>
</dt><dt>4.1.2. <a href="dev-guide">Vision
Statement</a>
</dt><dt>4.1.3. <a href="dev-guide">System/Application
Overview</a>
</dt><dt>4.1.4. <a href="dev-guide">Use-cases
and User-scenarios</a>
</dt><dt>4.1.5. <a href="dev-guide">Related Links</a>
</dt><dt>4.1.6. <a href="dev-guide">Requirements</a>
</dt><dd><dl>
<dt>4.1.6.1. <a href="dev-guide">Photo
Requirements</a>
</dt><dt>4.1.6.2. <a href="dev-guide">Album
Requirements</a>
</dt><dt>4.1.6.3. <a href="dev-guide">Album
Hierarchy</a>
</dt><dt>4.1.6.4. <a href="dev-guide">Administrative
Control</a>
</dt><dt>4.1.6.5. <a href="dev-guide">Photo Upload</a>
</dt><dt>4.1.6.6. <a href="dev-guide">General
Requirements</a>
</dt><dt>4.1.6.7. <a href="dev-guide">
Requirements delayed until future version</a>
</dt>
</dl></dd><dt>4.1.7. <a href="dev-guide">Implementation
Notes</a>
</dt><dt>4.1.8. <a href="dev-guide">Revision
History</a>
</dt>
</dl></div><p>by Tom Baginski, <a href="mailto:bags\@arsdigta.com" target="_top">bags\@arsdigita.com</a>
</p><div class="sect2">
<h2 class="sect2"><a name="requirements-introduction" id="requirements-introduction">4.1.1. Introduction</a></h2><p>This document presents the requirements for the ACS 4.0 Photo
Album Package, which is a generalized application for storing and
displaying groups of photos on a web site. It is intended to build
on the experience gained from creating and maintaining a photo
album system for the IluvCamp client site.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="requirements-vision-statement" id="requirements-vision-statement">4.1.2. Vision Statement</a></h2><p>Many people want to display photos on the web. Building a simple
personal web page with vacation photos is easy and can be done by
hand with static html. Building 100 similar web pages for all your
friends and relatives would be tedious. More importantly it would
be difficult to maintain and scale such a system to support all the
users of a large site.</p><p>The photo album package provides a convenient and uniform system
for uploading, storing, and displaying groups of photos on a web
site. It removes the tedious part of building pages to display
photos, and allows users more flexibility to maintain and modify
their own photo albums. It also removes much of the burden from the
owners/maintainers of the site. All of these factors add up to a
system that allows community members to easily contribute and view
large amounts of compelling content on a site.</p><p>The initial version of the package will allow designated users
to upload photos into albums and to group albums into a folder
hierarchy that other users with appropriate permissions can view
and possibly edit.</p><p>Future improvement to the photo album package will incorporate
additional features developed on various customer sites that allow
users to upload photos in bulk through a client applet and to
purchase prints of photos presented on the site.</p>
</div><div class="sect2">
<h2 class="sect2"><a name="requirements-systemapplication-overview" id="requirements-systemapplication-overview">4.1.3.
System/Application Overview</a></h2><p>The basic content element of the photo album system is a photo.
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
<h2 class="sect2"><a name="requirements-use-cases-and-user-scenarios" id="requirements-use-cases-and-user-scenarios">4.1.4. Use-cases and
User-scenarios</a></h2><div class="sect3">
<h3 class="sect3"><a name="requirements-gernral-scenarios" id="requirements-gernral-scenarios">4.1.4.1. General
Scenarios</a></h3><ul>
<li>
<p>A young couple just got married. His family shot 20 rolls of
film at the wedding and the photographer they hired shot an
additional 15 rolls. Now that the wedding is over, this couple must
organize their photos. In addition to creating traditional,
physical photo albums, they want to publish their photos on the web
to share with friends and family all over the world.</p><p>The couple scans the images they want to publish on the web.
Most of the images were scanned from the negatives at processing
time making it easy for the couple to obtain digital versions of
their photographs. The couple creates a new photo album for their
wedding, and then adds the following folders: "Engagement
photo shoot," "Rehearsal dinner,"
"Ceremony," "Reception," and
"Honeymoon." The honeymoon itself was spent in two
different places. The couple creates subfolders for each of these
places in their Honeymoon folder.</p><p>Now the folder hierarchy looks like:</p><pre class="programlisting">
    
    - Wedding
        - Engagement Photo Shoot
        - Rehearsal Dinner
        - Ceremony
        - Reception
        - Honeymoon
            - Fiji - Big Island
            - Fiji - Tokoriki
          
</pre><p>The couple now opens a folder, and uploads images. With each
image, the couple can specify optional attributes such as the
caption for the photo, the story behind the photo, and an
identifier to help them locate the physical negatives at a later
date.</p><p>Once the images are uploaded, the couple decides to give their
parents administrative access to a couple folders. Now their
parents can upload additional photos to those folders or modify the
attributes of any given photo.</p><p class="listitem"> </p>
</li><li>
<p>The administrator of the "Dogs of the World" subsite
on the "All Furry Creatures" web sites wants to provide a
way to show pictures of various dog breads. Since the admin is a
busy person she doesn&#39;t want to upload and manage all of the
images herself. She does, however, want to specify the general
layout of the various albums and control who can upload images.</p><p>She creates an instance of the photo album within her subsite.
Then goes about creating a folder structure such as:</p><pre class="programlisting">
    
    - Dogs of the World
        -Hunting Dogs
        -Show Dogs
        -Lap Dogs
        -Yappy Dogs
        -Mutts(The coolest)
          
</pre><p>She then designates certain users or groups of users that she
trusts to manage a given folder and grants them permission to
create albums within each folder. These users go about creating
albums and uploading appropriate images as they see fit. They
cannot create new subfolders, so the folder structure will not
become fragmented and disorganized (the admin is both a control and
neat freak).</p><p>The admin later realizes that Lap Dogs and Yappy Dogs are
basically the same thing so she consolidates the two folders into
one called Trouble Dogs.</p><p>Since the point of the dog album is to show off various dogs,
she wants the world to be able to see them. She grants view access
to all albums within her subsite to the general public.</p>
</li>
</ul>
</div>
</div><div class="sect2">
<h2 class="sect2"><a name="requirements-related-links" id="requirements-related-links">4.1.5. Related Links</a></h2><ul>
<li><p class="listitem">System/Package "coversheet"</p></li><li><p class="listitem"><a href="design">ACS 4 Photo Album Package
Design Documentation</a></p></li><li><p class="listitem"><a href="dev-guide">Photo Album
Developer&#39;s Guide</a></p></li><li><p class="listitem">User&#39;s guide</p></li><li><p class="listitem">Test plan</p></li><li><p class="listitem">
<a href="http://camp-dev.arsdigita.com/camparent/campsunshine/album/" target="_top">IluvCamp photo albums</a> (Call or email me for log
in information)</p></li><li>
<p class="listitem">Competitive system(s)</p><ul>
<li><p class="listitem"><a href="http://www.ophoto.com" target="_top">Ophoto</a></p></li><li><p class="listitem"><a href="http://www.photoaccess.com" target="_top">PhotoAccess</a></p></li><li><p class="listitem"><a href="http://www.zing.com" target="_top">Zing, note zing&#39;s photo albums crashed my netscape
browser on Linux</a></p></li><li><p class="listitem"><a href="http://www.shutterfly.com" target="_top">ShutterFly</a></p></li>
</ul>
</li>
</ul>
</div><div class="sect2">
<h2 class="sect2"><a name="requirements-requirements" id="requirements-requirements">4.1.6. Requirements</a></h2><div class="sect3">
<h3 class="sect3"><a name="requirements-photo-requirements" id="requirements-photo-requirements">4.1.6.1. Photo
Requirements</a></h3><p>A photo is a generic content item for user uploaded photos. Each
photo will have image content items associated with it that store
the actual binary files and any image specific attributes. Photo
and image content items can accommodate multiple revisions.</p><ul>
<li><p class="listitem">VI.A.10 System will store three images
associated with a photo: the original image, thumbnail image, and a
view-sized image.</p></li><li><p class="listitem">VI.A.20 System will maintain a revision history
for the photos and record which revision is current for given
situation.</p></li><li><p class="listitem">VI.A.30 Images shall be stored so that they can
be served efficiently. The system should allow for storing the
binary files in either the file system or the database. This should
be controlled by a parameter. The initial implementation may only
support one storage type, but it should be open to either storage
type.</p></li><li>
<p class="listitem">VI.A.40 Photos and any revisions have attribute
data associated with them. The method and structure for storing
these attributes will be decided as part of the design and
implementation.</p><ul>
<li><p class="listitem">VI.A.40.10 System specified attributes. Certain
attributes will be specified and maintained by the system. These
attributes will include: uploading_user, user_filename,
original_file_size, original_width, original_height, original_path,
thumb_width, thumb_height, thumb_file_size, thumb_path, view_width,
view_height, view_file_size, view_path, caption, upload_date. Other
attributes will be determined during the design process.</p></li><li><p class="listitem">VI.A.40.20 Administrator specified attributes.
The site administrator can specify custom attributes of photos and
if these attributes are required/optional for uploaded photos. The
initial system will not support admin customized attribute fields.
However the system shall be designed so that it is open to adding
this in the future.</p></li><li><p class="listitem">VI.A.40.30 User Specified Attributes. The
initial system will not support user customized attribute fields.
However the system shall be designed so that it is open to adding
user customized fields in the future.</p></li>
</ul>
</li><li><p class="listitem">VI.A.50 System shall be open to adding
server-backed image manipulation with a future version. This may
include image rotation, cropping, and other simple editing. Since
image manipulation can be a cpu-intensive process, many users
manipulating many images at the same time could potentially slow a
sites response time. Any implementation of these feature should
support redirecting manipulation requests to an alternate server
for processing images to alleviate the load on the main server.</p></li>
</ul>
</div><div class="sect3">
<h3 class="sect3"><a name="requirements-album-requirements" id="requirements-album-requirements">4.1.6.2. Album
Requirements</a></h3><ul>
<li>
<p class="listitem">VI.B.10 Album is a group of 0 or more
photos.</p><ul>
<li><p class="listitem">VI.B.10.10 Photos have a distinct order within
an album</p></li><li><p class="listitem">VI.B.10.20 User with edit privileges can
modify/reorder photos within album.</p></li>
</ul>
</li><li>
<p class="listitem">VI.B.20 Album has page to display several
thumbnail images in an album.</p><ul>
<li><p class="listitem">VI.B.20.10 Number of thumbnails per page is
controlled in admin page. Display page must dynamically react to
changes on the admin page.</p></li><li><p class="listitem">VI.B.20.20 Thumbnail display can scroll through
next and previous pages, next / previous page group, or click on
page number.</p></li><li><p class="listitem">VI.B.20.30 Clicking on thumbnail calls
view-size display page.</p></li><li><p class="listitem">VI.B.20.40 Attributes can be displayed with
thumbnails. Display controlled in admin page or in template
page.</p></li>
</ul>
</li><li>
<p class="listitem">VI.B.30 Album has page to display single
view-size image.</p><ul>
<li><p class="listitem">VI.B.30.10 When viewing one image user can
navigate to next and previous photo or return to thumbnail
page.</p></li><li><p class="listitem">VI.B.30.20 Viewer can display attributes of
photo. Display controlled in admin page or in template page.</p></li>
</ul>
</li><li><p class="listitem">VI.B.40 The display pages should use templates
for designating layout and formatting. The templates should be able
to accommodate parameter changes made through the admin pages. So
if the admin changes the albums from displaying 4 200x200
thumbnails at a time to 6 100x100 thumbnails, the display pages
should reformat accordingly with minimal changes to the display
templates</p></li><li><p class="listitem">VI.B.50 Potential page to display the original
images. Such a page would allow the user to view and save the
original size high-resolution version of the photo instead of the
lower resolution and smaller sized viewer and thumbnail images.
Since some sites and admins may not want users to have access to
the high-resolution originals, the admin must be able to toggle the
availability of such page.</p></li><li>
<p class="listitem">VI.B.60 User with edit privilege can do
following:</p><ul>
<li><p class="listitem">VI.B.60.10 Upload new photos to an album and
specify attributes during upload process.</p></li><li><p class="listitem">VI.B.60.20 Photos can be moved to different
albums within same hierarchy.</p></li><li><p class="listitem">VI.B.60.30 Photos can be deleted from an
album.</p></li><li><p class="listitem">VI.B.60.40 Edit photo attribute information</p></li>
</ul>
</li>
</ul>
</div><div class="sect3">
<h3 class="sect3"><a name="requirements-album-hierarchy" id="requirements-album-hierarchy">4.1.6.3. Album Hierarchy</a></h3><ul>
<li><p class="listitem">VI.C.10 Albums can be grouped in a hierarchy of
arbitrary depth.</p></li><li><p class="listitem">VI.C.20 Display/sorting of hierarchy controlled
on the page level but order field included to support arbitrary
sorting.</p></li><li><p class="listitem">VI.C.30 Admin (exact permission required, to be
determined) can add/consolidate hierarchy levels.</p></li><li><p class="listitem">VI.C.40 Admin (exact permission required, to be
determined) can move items around in hierarchy.</p></li><li><p class="listitem">VI.C.50 Admin (exact permission required, to be
determined) can resrict the creation of new hierarchy levels.</p></li>
</ul>
</div><div class="sect3">
<h3 class="sect3"><a name="requirements--administrative-control" id="requirements--administrative-control">4.1.6.4. Administrative
Control</a></h3><ul>
<li><p class="listitem">VI.D.10 Number of thumbnail to be displayed at
a time on the page described in VI.B.20 specified in by a sub-site
admin. Number of thumbnails pre page can be changed by the admin at
any time and display pages react accordingly.</p></li><li>
<p class="listitem">VI.D.20 Thumbnail and view-size specified by
sub-site admin.</p><ul><li>
<p class="listitem">VI.D.20.10 Thumbnail and view-size can be
changed by sub-site-admin. Two options are allowed for size
changes, proactive and retroactive.</p><ul>
<li><p class="listitem">VI.D.20.10.10 Proactive change will only change
new photo uploads. Any changes will take affect immediately.
Previously uploaded photos will maintain original thumbnail and
view-size images until photo is revised.</p></li><li><p class="listitem">VI.D.20.10.20 Retroactive changes will change
new photo uploads and resize all previously uploaded photos. Since
the time to complete such revision will vary with the number of
photos uploaded, the system shall provides an estimate of how long
it will take and asks if admin wishes to continue. If yes it
schedule conversion process to run during low bandwidth times, and
provides daily email updates if process will take longer than a
day. Also checks for server crashes/restarts that would hinder
conversion. (This requirement will be delayed until a future
version)</p></li>
</ul>
</li></ul>
</li><li><p class="listitem">VI.D.30 Admin can edit other people&#39;s
albums.</p></li><li><p class="listitem">VI.D.40 Admin designates default permissions
for hierarchy levels. So various users can view, create, edit, and
upload to different levels.</p></li><li><p class="listitem">VI.D.50 Admin can allow user to access the page
displaying the original size high-resolution version of a photo
described in VI.B.50</p></li>
</ul>
</div><div class="sect3">
<h3 class="sect3"><a name="requirements--photo-upload" id="requirements--photo-upload">4.1.6.5. Photo Upload</a></h3><ul>
<li><p class="listitem">VI.E.10 Photos uploaded one at a time through
an html form. Form shall provide ability to specify attribute
information.</p></li><li><p class="listitem">VI.E.20 Upload system shall support uploading
to separate dedicated server(s). Creating the thumbnail and viewer
size images of a photo can be a cpu-intensive process. Many users
uploading many photos simultaneously can potentially slow a sites
response time. Redirecting upload requests to an alternate server
for processing images can lessen the load on the main server.
(Implementation of this will be delayed until a future
release).</p></li><li><p class="listitem">VI.E.30 Future version to support bulk
upload.</p></li>
</ul>
</div><div class="sect3">
<h3 class="sect3"><a name="requirements--general-requirements" id="requirements--general-requirements">4.1.6.6. General
Requirements</a></h3><ul>
<li><p class="listitem">VI.F.10 System to support sub-sites. Admin
shall be able to add album implementation to multiple sub-sites on
a web service.</p></li><li><p class="listitem">VI.F.20 System shall be able to scale to at
least the service level experienced by IluvCamp during summer
2000.</p></li><li><p class="listitem">VI.F.30 Design to accommodate future
integration of photo print and purchase capabilities as
demonstrated on the IluvCamp Client sites.</p></li>
</ul>
</div><div class="sect3">
<h3 class="sect3"><a name="requirements--requirements-delayed-until-future-version" id="requirements--requirements-delayed-until-future-version">4.1.6.7.
Requirements delayed until future version</a></h3><ul>
<li><p class="listitem">VI.G.10 Purchase and printing of photo through
ecommerce package and photo printing vendor.</p></li><li><p class="listitem">VI.G.20 Server backed image manipulation</p></li><li><p class="listitem">VI.G.30 Bulk upload tool</p></li><li><p class="listitem">VI.G.40 User specified attributes</p></li><li><p class="listitem">VI.G.50 Upload quotas</p></li><li><p class="listitem">VI.G.60 Admin notification of file space
limitations.</p></li><li><p class="listitem">VI.G.70 Search and retrieval of photos and
albums based on attributes or key words.</p></li><li><p class="listitem">VI.G.80 Admin specified attributes</p></li><li><p class="listitem">VI.G.90 Photo upload/manipulaion support for
separate server.</p></li>
</ul>
</div>
</div><div class="sect2">
<h2 class="sect2"><a name="requirements-implementation-notes" id="requirements-implementation-notes">4.1.7. Implementation
Notes</a></h2><p>A photo album system was built for the IluvCamp Client site.
Much of the work on the ACS 4.0 Photo Album Package will be based
on the lessons learned building and maintaining this system. Some
of these lessons include:</p><ul>
<li><p class="listitem">The ability (and necessity on high volume
sites) to support dedicated image processing servers. As outlined
in two of the requirements above, numerous simultaneous image
manipulations can tie up resources on the main server. Low volume
sites may be able to handle image manipulation on the main server,
but high volume sites will need the ability to pass these
operations off to dedicated servers.</p></li><li><p class="listitem">The ability to support a pool of multiple
servers. The Iluvcamp site used a pool of multiple servers on
several machines to support the high volumes of traffic.
Additionally, many attributes of the album structure and hierarchy
were cached to improve performance. When we made changes to these
attributes that required cache flushes, we needed to make sure the
caches were flushed on all the servers.</p></li><li><p class="listitem">The Iluvcamp data structure mapped a specific
number of images to a page and then mapped the pages to albums. All
of this mapping and ordering information was stored in the
database. This essentially hard-coded the image on page ordering
and the number of images per page. Unfortunately this made changing
the display of albums from 9 images per page to 4 images per page
(a mid-season client request) time consuming and difficult. Given
that the requirements allow for easy changes to the number of
thumbnails displayed per page, such hard-coding should be avoided
at all cost in the photo album package. Photos should be mapped
directly to albums and pages within the album should be rendered
dynamically.</p></li><li><p class="listitem">The amount of time it takes to retroactively
change thumbnail and view-size images. A client requested change of
the thumbnail and viewer size images on IluvCamp took several weeks
of processor time to modify ~ 240,000 previously uploaded images.
Scheduling and monitoring the conversion process was a headache. We
hope to figure out a easier way to make such a change.</p></li>
</ul>
</div><div class="sect2">
<h2 class="sect2"><a name="requirements-revision-history" id="requirements-revision-history">4.1.8. Revision History</a></h2><div class="informaltable">
<a name="AEN283" id="AEN283"></a><table border="1" class="CALSTABLE" cellpadding="10">
<thead><tr>
<th align="center" valign="middle">Document Revision #</th><th align="center" valign="middle">Action Taken, Notes</th><th align="center" valign="middle">When?</th><th align="center" valign="middle">By Whom?</th>
</tr></thead><tbody>
<tr>
<td align="left" valign="middle">0.1</td><td align="left" valign="middle">Creation, initial draft</td><td align="left" valign="middle">11/15/2000</td><td align="left" valign="middle">Tom Baginski</td>
</tr><tr>
<td align="left" valign="middle">0.2</td><td align="left" valign="middle">Revisions in response to initial
comments</td><td align="left" valign="middle">12/05/2000</td><td align="left" valign="middle">Tom Baginski</td>
</tr><tr>
<td align="left" valign="middle">0.3</td><td align="left" valign="middle">Revisions in response to more
comments</td><td align="left" valign="middle">12/11/2000</td><td align="left" valign="middle">Tom Baginski</td>
</tr><tr>
<td align="left" valign="middle">0.4</td><td align="left" valign="middle">Minor revisions base on design
experience</td><td align="left" valign="middle">2/2/2000</td><td align="left" valign="middle">Tom Baginski</td>
</tr>
</tbody>
</table>
</div><p><a href="mailto:bags\@arsdigita.com" target="_top">bags\@arsdigita.com</a></p><p>Last Modified: $Date: 2017/05/26 18:05:37 $</p>
</div>
</div>
</div>
<div class="NAVFOOTER">
<hr size="1" noshade="noshade" align="left" width="100%"><table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
<td width="33%" align="left" valign="top"><a href="acs-admin-guide">Prev</a></td><td width="34%" align="center" valign="top"><a href="index">Home</a></td><td width="33%" align="right" valign="top"><a href="design">Next</a></td>
</tr><tr>
<td width="33%" align="left" valign="top">ACS Administration
Guide</td><td width="34%" align="center" valign="top"> </td><td width="33%" align="right" valign="top">ACS 4 Photo Album
Package Design Documentation</td>
</tr>
</table>
</div>

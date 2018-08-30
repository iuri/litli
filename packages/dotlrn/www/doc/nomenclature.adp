<master src="master">
<property name="doc(title)">dotLRN Nomenclature</property>

<h1>dotLRN Nomenclature: a dotLRN Primer</h1>
by <a href="mailto:ben@openforce.net">Ben Adida</a>, part of <a
href="./">dotLRN Documentation</a>. (last updated: <em>28 February 2002</em>)
<hr><P>

dotLRN is a <strong>Learning Community Management System</strong>
which means it helps manage communities of users and the exchange of
information therein. This document defines the
<strong>nomenclature</strong> in the dotLRN project, with specific
examples of how this nomenclature can be used in the context of
dotLRN's primary use: that of a Course Management System.

<p>
<h2>1. dotLRN Communities</h2>
The core concept within dotLRN is the <strong>dotLRN User Community</strong>.

<h3>Community</h3> 

A community is a group of users that work together and exchange
various types of information. There may be different types of
communities, but all have basic properties, such as a community name
and community ID.

<p>

<h3>Class</h3>

A <strong>class</strong> is a topic of instruction, such as "Finance 101." A
class is <strong><em>not</em></strong> a community (this will become clearer
soon).

<p>

<h3>Class Instances and Clubs</h3>

Two basic types of communities implemented in core dotLRN are
<strong>Class Instances</strong> and <strong>Clubs</strong>. Class Instances are
for structured groups of students, while Clubs are for unstructured
student activities. A Class Instance, as its name indicates, is a
specific instance of a Class. "Finance 101 - Spring 2002" is an
instance of "Finance 101." It doesn't make sense for "Finance 101,"
the topic of instruction, to be itself a community, since Finance 101
Fall 2000 and Finance 101 Spring 2005 will probably have nothing to do
with on another apart from teaching approximately the same material.

<p>

<h3>Open, Wait, Closed Communities</h3>

Communities can have one of three <strong>Join Policies</strong>. A join policy
defines the process by which a dotLRN User can become a member of the
community. For now, we will consider only <strong>dotLRN Full Access
Users</strong> (see below for more information on other types of dotLRN
users).

<p>

A  community with <strong>open join policy</strong> is visible in read-only
state to non-members. Any full-access user can join the community at
will, without the intervention of any other user.

<p>

A community with <strong>wait join policy</strong> is visible in read-only state
to non-members. A full-access user can apply to join the
community. The application must be approved by an administrator of the
community.

<p>

A communty with <strong>closed join policy</strong> is not visible to
non-members. Users become members only when explicitly added by the
community administrator.

<p>

<h3><em>in MIT SloanSpace</em>: Class Instances and Communities</h3>

In MIT SloanSpace, dotLRN Communities are referred to as <strong>SloanSpace
Groups</strong>, while dotLRN Clubs are referred to as <strong>SloanSpace
Communities</strong>.

<p>

The reason for this potential nomenclature confusion is historical:
SloanSpace v1.0 used a certain terminology. It would be unacceptable
to change it for SloanSpace v2.0. Similarly, it would be unacceptable
to stick to the SloanSpace nomenclature and impose it to all users of
dotLRN.

<p>

Thus, dotLRN nomenclature, although internally self-consistent, is
entirely configurable by the user using global parameters.

<h2>2. dotLRN Users</h2>

A <strong>dotLRN User</strong> is an individual with an email address username and a
password to the dotLRN system. Each user is uniquely identified by
email address.

<h3>Access Level: Limited or Full</h3>

dotLRN users can have either <strong>Limited Access</strong> or <strong>Full
Access</strong>.

<p>

A <strong>limited-access user</strong> is one who has access only to class instances
and communities she is registered for and has no ability to
browse any other section of the dotLRN application. This applies even
to open communities: if a limited-access user is not a member of a
given open community, she will not be able to browse any page that may
enable her to become a member.

<p>

A <strong>full-access user</strong> is one who has access to all browsing
sections of the dotLRN application. A full-access user can surf around
and register for open communities, apply to be accepted into wait
communities, etc... A full-access user also has the ability to store
user-specific information, like personal files and personal calendar events.

<p>

<h3>Access to Private Information</h3>

Certain users of the system may be <strong>dotLRN Guests</strong>, meaning that
they do not belong to the parent organization that runs the dotLRN
instance. These guests may participate in the community as
full-fledged members but, for certain legal or privacy reasons, may
not be allowed to view other users' private information.

Any dotLRN user can be a guest or a non-guest. Full-access members can
be guests. The only difference between a guest and non-guest is
whether private user information (email address, address, phone #,
etc...) can be read by these guests.

<h3>System-Wide Roles</h3>

dotLRN users have system-wide profile information. For example, in the
context of a Course Management System like MIT SloanSpace, they may be
<strong>Professors</strong>, <strong>Students</strong>, or <strong>Administrative Staff</strong>.
These system-wide roles define the user's specific profile in the
system as a whole, without regards to community-specific roles.

<p>

<h3>Community-Specific Roles</h3>

dotLRN users have specific roles within the communities they belong
to. These roles are classified in two main categories: <strong>dotLRN
Community Members</strong> and <strong>dotLRN Community Admins</strong>.

<p>

<strong>dotLRN Community Members</strong> of a given community have normal
read/write access to a community. They cannot perform administrative
functions, like create a new forum, add group calendar events, create
a new survey, etc... However, they can contribute to existing
discussion forums, view calendar events, and respond to surveys.

<p>

<strong>dotLRN Community Admins</strong> have all the privileges of normal
community members <em>plus</em> complete administrative rights over all
components of the community. dotLRN Community Admins completely
control a community: they need no further help from any other users to
add data, applications, or users to their workspace.


<h2>3. dotLRN Applets</h2>

A dotLRN community is mostly a container of users and applets. A
<strong>dotLRN Applet</strong> (nothing to do with a Java applet) is a small
application that can be added to the community to enable new
functionality.

<p>

Examples of existing applets include: Discussion Forums, Surveys,
FAQs, News, Calendaring. These applets are <strong>scoped</strong> in order to
correctly segment communities from one another. Data that belongs to
one community is not viewable by another: it is as if it doesn't exist
unless you are in the appropriate community.

<p>

Certain applets are <strong>community-centric</strong> in that they offer
functionality that makes sense only in the context of a given
community. Discussion Forums is one solid example of this: a
discussion forum must pertain to a given community.

<p>

Other applets are <strong>user-centric</strong> in that they also manage data
that is user-related, not linked to any given community. Calendaring
is one such applet: although there are community events, there are
also personal events.

<p>

<h2>4. Portals</h2>

The entire dotLRN architecture is based on the <strong>New Portal
Architecture</strong>. The design and specifics of this architecture are
described in another document, but the basic terminology and concepts
are as follows.

<p>

<h3>Portal Page</h3>

A <strong>Portal Page</strong> is a single page display of portal boxes. A
portal page has a <strong>Portal Layout</strong> that defines how the boxes are
arranged on the page. Common layout schemes include 2-column,
3-column, 3-column-with-header. New portal layouts can be implemented
at will.

<p>

A portal page can be configured so that the portal boxes can be moved
around the page by someone with appropriate permissions.

<h3>Portal</h3>

A <strong>Portal</strong> is a set of portal pages that are tied together so
that a browser may navigate easily between the various portal
pages. This is particularly useful when portal boxes need to be
organized by functionality theme.

<h3>Portlet or Portal Datasource</h3>

A <strong>Portlet</strong> or <strong>Portal Datasource</strong> is a set of functionality
that is presented in the form of a portal box. A bboard portlet, for
example, is functionality that displays discussion forums inside a
portal box.

<h3>Portal Element</h3>

A <strong>Portal Element</strong> is a single box on a given portal page. A box
that display discussion forum information on Jane Doe's personal
portal page #2 is <strong><em>one</em></strong> portal element that corresponds to
the instantiation of portlet within a portal page.

<p>

A portal element can be moved, shaded, or hidden altogether, given the
appropriate permissions. It can be moved to a different page of the
same portal. While a portlet can be instantiated multiple times within
a given portal, a portal element is unique per portal as it represents
a single instance of the portlet: thus, a portal element can appear on
only one page of the portal in one location. To appear in more than
one place, a new instance of the portlet would have to be instantiated.

<h3>Portal Themes</h3>

A portal page can be rendered in a given <strong>Portal Theme</strong> that
determines the look-and-feel of each box. The layout is <strong>NOT</strong>
determined here, only the specific look-and-feel of portal element
borders, buttons, and internals.

<h3>Portlet Parameters; Portal Element Parameter Values</h3>

For each portlet, there is a set of <strong>Portlet Parameters</strong>. For
example, the calendar portlet has a <kbd>calendar_view</kbd> parameter
that indicates whether the portlet should display data in the form of
a list, day-, week-, or month- view.

<p>

Each Portal Element has <strong>Portal Element Parameter Values</strong> for
each parameter of the portlet it instantiates. For example, the
calendar portal element on Jane Doe's personal portal may have a value
of "day" for the <kbd>calendar_view</kbd> parameter.

<p>

<h3>Portal Template</h3>

A portal template is much like any other portal, except that it is
used as a template for creating other portals.


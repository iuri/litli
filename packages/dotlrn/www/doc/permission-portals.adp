<master src="master">
<property name="doc(title)">dotLRN Portal Permissions</property>

<h2>dotLRN Portal Permissions</h2>
by <a href="mailto:arjun@openforce.net">Arjun Sanyal</a> and <a href="mailto:ben@openforce.net">Ben Adida</a>, part of <a href="./">dotLRN Documentation</a>.
<hr><P>

dotLRN presents itself to users by way of portals, i.e. pages that
aggregate data from disparate sources, shown as "boxes" on the page,
and allow these sources to be added, removed, and altered in various
ways. Permissioning issues arise frequently: "Is a student allowed to
remove the "Class Announcements" element of her portal?" is an example
of a permissioning issue. 
<P>
In general the system of permissions should be simple enough for the
users to understand, but flexible enought to support all of the
required features. 
<P>
Also, the scope of this document is the permissions system related to
the portal-based parts of dotLRN, for more documentation on the
general permission scheme of dotLRN, see <a href="permission-overview.adp">dotLRN Roles, Sections, and Permissions</a>

<h2>Some General Portal Ideas</h2>

Students will have the ability to alter their personal portal, but up
to the point specified by a class administrator. In the example given
above, a class administrator could "lock" the "Class Announcements"
element in student's personal portals so they would not have the power
to remove it or alter its position. In this case, the administrator
would have contol over <strong>more than one</strong> portal, i.e. her
own personal portal and a "default" portal that is "cloned", including
the "lock", to create each student's portal when she registers for the
class.

<P>

Non-administrative users cannot grant any permission to anyone. Thus,
an "Student X lets student Y read her portal" scenarios are avoided.

<h2>Administrative Permissions</h2>

The administrative permissions CREATE and DELETE are only given to
those users whose roles are such that they would need to create and
destroy portals for scenarios such as the one given above.  

<h3>CREATE</h3>
<ul>
<li>User can create a new portal. Used for creating default class portals
<li>Granted to: Administrator role <strong>only</strong>, by default
<li>Implies: DELETE, and READ, EDIT, ADMIN on newly created portals
</ul>

<h3>DELETE</h3>
<ul>
<li>User can destroy this portal. Not granted to non-admin users.
<li>Granted to: Admin users who have CREATE
</ul>

<h2>Portal-level Permissons for Non-Admin Users</h2>

These permissions are at the level of individual portals for users
such as students.

<h3>READ</h3>
<ul>
<li>Grantee can read (view) this portal. 
<li>Granted to: A User for her individual portal.
</ul>

<h3>EDIT</h3>
<ul>
<li>Grantee can:
	<ul>
	<li>Add "Available" datasources 
	<li>Remove "unlocked" elements 
	<li>Move (shuffle) "unlocked" elements
	<li>Edit user-editable element parameters
	</ul>
<li>Granted to: A User for her individual portal. Aggregates the
permissions that a non-admin user will have, other than "READ". 
</ul>

<h2>Portal-level Permissons for Admin Users</h2>

Admin users with the CREATE permission will be granted the following
permisson on the newly created portal.

<h3>ADMIN</h3>
<ul>
<li>Grantee can:
	<ul>
	<li>Toggle "lock" on a portal element
	<li>Set this portal page to be "cloned" from
	<li>Set "non-user" parameters for elements
	<li>Toggle portal element "availability"
	</ul> 
<li>Granted to: A portal created with the CREATE permisson.
</ul>

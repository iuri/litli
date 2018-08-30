<master src="master">
<property name="doc(title)">dotLRN Roles, Sections, and Permissions</property>

<h2>dotLRN Roles, Sections, and Permissions</h2>
by <a href="mailto:ben@openforce.net">Ben Adida</a>, part of <a href="./">dotLRN Documentation</a>.
<hr><P>

dotLRN includes significant components of functionality and an
architecture for integrating these components. Around these
components, there must be a coherent and consistent model for roles
and permissions throughout the system. This document defines the
necessary roles, application sections, and rules for access in the
dotLRN application.

<h2>Roles</h2>

Roles in the dotLRN system are considered from a logical
standpoint. It is perfectly conceivable that an actual user take on
more than one role. It is also conceivable that a logical role is
represented by multiple physical underlying roles and permissions.
<p>

<h3>Unregistered Visitor</h3>
An unregistered visitor is simply a user who browses the dotLRN
application without login information. An installation of dotLRN may
disallow unregistered visitors, if it so chooses.

<h3>Registered dotLRN Guest</h3>
A registered dotLRN guest is a registered user (first name, last name,
email, password are entered) who has logged in and is using those
credentials. This user is enabled only for a particular class or club,
and does not have access to the generic dotLRN workspace.

<h3>Registered dotLRN User</h3>
A registered dotLRN user is a registered user how has logged in using
those credentials. A dotLRN user can browse all available public
classes and clubs.

<h3>Registered Student of an Instance of a Class</h3>
A registered student of a class is one who has requested association
with a particular instance of a class (e.g. Micro-Economics, Spring
2002 Section A), and who has been approved (usually by a professor, a
TA, or an administrator). 

<h3>TA of a Class Instance</h3> 
A TA of an instance of a class is a registered user who serves as a
Teaching Assistant for the class, having some administrative
responsibilities. TAs are usually designated by professors or
administrators of a class's instance.

<h3>Administrator of a Class Instance</h3>
An administrator of an instance of a class is a registered user who
serves to perform organizational/administrative duties for the class,
including registration, schedule and venue arrangements, etc...

<h3>Instructor of a Class Instance</h3>
An instructor of an instance of a class is a registered user who
teaches the actual class instance in question. Instructors are often
professors, but may not be (thus the use of the more functional term
"Instructor" rather than the status term "Professor").

<h3>Member of a Graduating Year</h3>
A member of a graduating year is a registered user who is a student of
a particular graduating year. This grouping may be needed for mass
mailings, alumni clubs, etc...

<h3>Member of a Community</h3>
A member of a community is a registered user who has signed up (and
been approved) to be part of one of the dotLRN communities. A
community functions much like a class instance, but without the
association to the teaching of a particular subject.

<h3>Administrator of a Community</h3>
An administrator of a community is a registered user assigned to
coordinate a particular community.


<h2>Sections of the Application</h2>

The dotLRN Application is composed of a number of sections which
serve various roles. These sections can be described with a varying
level of granularity. The following description matches the necessary
level of granularity for matching permissions and roles.

<h3>Main Public Site</h3>

Every dotLRN site will have a completely public section that describes
the general purpose of the application. This will be mostly
information material, with very little interactivity of any kind.
<p>
<h4>Permissions</h4>
<ul>
<li> All registered dotLRN users can access this section
<li> Guests or unregistered visitors cannot access this section
</ul>


<h3>Per-Class Main Page</h3>

Each class (e.g. Micro-Economics) will have a section in the dotLRN
application. This section will describe the goals of the class,
general information about it, and will remain unrelated to any
specific instance of the class.
<p>
A registered student of an instance of that class will be presented
with links to the proper instance-specific sections.

<p>
<h4>Permissions</h4>
<ul>
<li> All registered dotLRN users can access this section
<li> All guests of <strong>that</strong> class can access this section
<li> Registered users associated with a class instance of this class
will see specific links to the proper class instances
</ul>


<h3>Per-Class Admin Page</h3>

Each class will have an administrative section in the dotLRN
application which will enable users to:
<ul>
<li> create new instances of the class
<li> assign instructors, TAs, and administrators to existing instances
of classes
<li> edit standard class information (description blurb, etc...)
</ul>

<p>
<h4>Permissions</h4>
<ul>
<li> Only dotLRN system administrators can access this section
</ul>

<h3>Per-Class-Instance Main Page</h3>

Each class instance (e.g. Micro-Economics, Spring 2002 Section A) will
have a section in the dotLRN application. This section will look very
different depending on the state of the visitor.
<p>
For a <strong>registered student, TA, or Instructor</strong> of the
class instance, the section will present all available options for the
particular instance, including discussion forums, file storage, FAQ,
surveys,etc...
<p>
For a <strong>user not registered with this class instance</strong>,
the section will present general information about the class instance,
possibly some public files (like a syllabus), and the ability to
request registration for the class.

<p>
<h4>Permissions</h4>
<ul>
<li> All registered dotLRN users can access this section
<li> Guests for this class instance can see this section
<li> Only registered users and guests associated with this class instance can
access the full functionality
<li> Certain functionality (like class rosters) are only accessible to
full users, not to guests
</ul>

<h3>Per-Class-Instance Admin Page</h3>

Each class instance will have an administrative section which will
allow for:
<ul>
<li> membership management (approval, rejections, etc...)
<li> access to various subpackage administration (bboard, FAQ, news, etc..)
<li> general information updates (class instance blurbs)
</ul>

<p>
<h4>Permissions</h4>
<ul>
<li> Only class instance administrators, TAs, and instructors can
access this section
</ul>

<h3>Per-Class-Instance-Package Main Page</h3>

Each package within a class instance defines a section of the dotLRN
application (e.g. bboards for Micro-Economics, Spring 2002 Section
A). The functionality for these sections will be specific to the
subpackages involved.

<p>
<h4>Permissions</h4>
<ul>
<li> Only registered users associated with this class instance can
access this section
</ul>

<h3>Per-Class-Instance-Package Admin Page</h3>

By the same token, each package within a class instance defines a
section of the dotLRN application for administration. The
functionality is subpackage-specific.

<p>
<h4>Permissions</h4>
<ul>
<li> Only instructors, TAs, and administrators of the class instance
in question can access this section
</ul>


<h3>Per-Community Main Page</h3>

dotLRN will also support communities, each of which will have its own
section, much like a class instance. This section will lead to all
subpackages supported by this community. Users who are members of the
community will access all functionality, while other users will only
see basic community information.

<p>
<h4>Permissions</h4>
<ul>
<li> All registered dotLRN users can access this section
<li> Guests of this specific community can access this section
<li> Only members of the community at hand can access
community-specific chunks/links
</ul>


<h3>Per-Community Admin Page</h3>

By the same token, each community will have an admin section that
allows community administrators to manage community membership,
general information and subpackages.

<p>
<h4>Permissions</h4>
<ul>
<li> Only community administrators can access this section
</ul>
 

<h3>Per-User Main Page</h3>

Each user will have a main page that centralizes access to all of that
user's class instances, communities, and all the data within these
sections. This is a personal view on every piece of user-relevant data.

<p>
<h4>Permissions</h4>
<ul>
<li> Only the user in question can access her main page.
</ul>

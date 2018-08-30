<master src="master">
<property name="doc(title)">Writing a dotLRN Package</property>

<h2>Writing a dotLRN Package</h2>
by <a href="mailto:ben@openforce.net">Ben Adida</a>.
<hr><P>

Writing a dotLRN package is a task that is meant to hook generic
OpenACS 4 functionality into the framework of dotLRN communities. As
much as possible, one should worry solely about that core
functionality. As long as this functionality is made scopable as per
the subsite approach in OpenACS 4, hooking into dotLRN is fairly
straight-forward.

<p>

<h3>The Structure of a dotLRN Package/Applet</h3>

As far as dotLRN is concerned, a dotLRN package is an
<strong>applet</strong> (literally a "small application," nothing to
do with Java applets) that must provide a simple
API under the <kbd>acs-service-contract</kbd> mechanism. This API allows
the dotLRN core to generically dispatch calls to each dotLRN applet
when certain events happen.

<p>

Thus, a dotLRN applet must be able to respond to the following events:
<ul>
<li> the applet is added to a community
<li> the applet is removed from a community
<li> a user is added to a community for which the applet in question
is enabled
<li> a user is removed from a community for which the applet in
question is enabled
</ul>

Additional events may be added in the future to further enhance
generalized applet functionality.

<p>

Most dotLRN applets will want to offer an interface to their users (although
it's very possible that some won't). To do so, the dotLRN core will
use the New Portal Architecture of OpenACS 4. A dotLRN applet can
simply add itself to the appropriate portal pages by providing an
<strong>NPA portlet</strong>. <em>Note that the architecture of this
portlet is dotLRN-independent!</em> The contents of the portlet may
rely on dotLRN functionality, but the means by which the portlet is
added to portal pages does not!

<p>

Also, it is highly recommended that functionality be added to dotLRN
by first thinking of generic OpenACS 4 functionality, and eventually
hooking it into the dotLRN core. Thus, a dotLRN package will be
usually composed of <strong>three OpenACS 4 packages</strong>:

<ul>
<li> a core functionality package (e.g. bboard), independent of dotLRN functionality
<li> a portlet package (e.g. bboard-portlet), whose interface to NPA
is independent of dotLRN functionality, but whose content may be
dotLRN-enhanced.
<li> a dotLRN applet (e.g. dotlrn-bboard), dependent on dotLRN
functionality and basically the glue between the dotLRN core and the
core functionality of this new applet.
</ul>

<h3>Core Functionality</h3>

There is only one guideline in writing core functionality for a dotLRN
applet: <strong>make sure the package can be correctly scoped across
multiple subsites</strong>. This means that any data should be scoped
correctly to a particular package_id. Take a look at the standard
bboard package for a clear way to do this.

<h3>Portlet</h3>

The portlet should be created in line with the New Portal
Architecture. We want to strongly discourage developers from making
this portlet package dependent on dotLRN functionality: portlets will
be able to query parameter information from the NPA (such as the
<kbd>package_id</kbd>), independently of any dotLRN functionality.

<p>

For more details on creating a portlet package, check the <a
href="npa/">New Portals Architecture</a>

<h3>dotLRN Applet</h3>

A dotLRN applet is simply the glue that responds to specific
requests. Let's take the example of the bboard applet to better
understand what's going on.

<p>

First, we will write the actual procs that we expect to eventually
hook into the dotLRN system.

<p>

The first proc is called when the bboard applet is added to a community

<pre>
ad_proc -public dotlrn_bboard::applet_add {community_id} {} {
	# Instantiate bboard and mount it
}
</pre>

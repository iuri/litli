<master src="master">
<property name="doc(title)">Installing dotLRN - OpenForce</property>


    <h1>Installing dotLRN</h1>

    <p>part of <a href="../">dotLRN</a></p>

    <p><small>Last updated: $Date: 2016/06/22 08:25:00 $</small></p>

    <h2>Contents</h2>

    <ul>
        <li>Read the dotLRN FAQ</li>
        <li>Get and Install OpenACS from development CVS</li>
        <li>Get dotLRN from CVS</li>
        <li>Install dotLRN on your system</li>
        <li>Explore dotLRN</li>
    </ul>


    <h2>Read the <a href="dotlrn-faq">dotLRN FAQs</a></h2>

    <h2>Get and Install OpenACS from development CVS</h2>

    <p>
       <em>If you have a working OpenACS installation from the latest
       development CVS, make sure that you have all the packages required
       below then skip to the next section.</em>
    </p>

    <p>
       If you are installing OpenACS, follow the extensive
	   <a href="http://openacs.org/doc/openacs-5-2/acs-admin">installation documentation</a>.
       <strong>Stop</strong> at the 
	   <a href="http://openacs.org/doc/openacs-5-2/openacs.html">point</a>
       where the OpenACS installation instructions tell you to
       &quot;download OpenACS&quot;. Don't use the &quot;Quick
       Downloads&quot;! Continue on with this document.
	</p>
    <p>
      <pre>
		cvs -d :pserver:anonymous@cvs.openacs.org:/cvsroot login
		(just hit return for the password)
		cvs -z3 -d :pserver:anonymous@cvs.openacs.org:/cvsroot checkout -r oacs-5-2 acs-core
      </pre>
	</p>      
    <p>
      <em>CVS commandlines are given in terms of anonymous users, if you have 
	  an account on openacs.org, use your login where appropriate. Don't 
	  forget to set the CVS_RSH variable in your shell environment to 
	  &quot;ssh&quot;.</em>
	</p>

    <h2>Get dotLRN from CVS</h2>

    <p>
      dotLRN requires some more modules that are not in
      <kbd>acs-core</kbd>, but not all of the packages in the OpenACS
      source tree. Next are the commands to get these modules.
	</p>

    <p>
      <pre>
		cd openacs-4/packages
		cvs -z3 -d :pserver:anonymous@cvs.openacs.org:/cvsroot co -r oacs-5-2 dotlrn-all
		mv dotlrn/install.xml ../
      </pre>
	</p>
    <p>
       <em>Installation timesaver: In the <kbd>/packages/ref-timezones/sql/common/</kbd>
       directory, cut down the files to a few <kbd>insert</kbd> statements apiece.
       This is fine for test system, and will save you a lot of time in the
       installation process.</em>
	</p>
    <p>
      You will now have an <kbd>/openacs-4</kbd> directory with all of
      OpenACS required by dotLRN. To double check, your
      <kbd>/openacs-4/packages</kbd> directory should look similar to this:
	</p>
    <pre>
	  $ ls
	  acs-admin                acs-templating      dotlrn-forums        lars-blogger
	  acs-api-browser          acs-translations    dotlrn-fs            new-portal
	  acs-authentication       assessment          dotlrn-homework      news
	  acs-automated-testing    assessment-portlet  dotlrn-news          news-portlet
	  acs-bootstrap-installer  attachments         dotlrn-portlet       notifications
	  acs-content-repository   bm-portlet          dotlrn-random-photo  oacs-dav
	  acs-core-docs            bulk-mail           dotlrn-static        profile-provider
	  acs-datetime             calendar            dotlrn-syllabus      random-photo-portlet
	  acs-developer-support    calendar-portlet    dotlrn-weblogger     ref-timezones
	  acs-events               categories          evaluation           rss-support
	  acs-kernel               CVS                 evaluation-portlet   search
	  acs-lang                 dotlrn              faq                  static-portlet
	  acs-mail                 dotlrn-admin        faq-portlet          theme-selva
	  acs-mail-lite            dotlrn-assessment   feed-parser          trackback
	  acs-messaging            dotlrn-bm           file-storage         user-preferences
	  acs-reference            dotlrn-calendar     forums               user-profile
	  acs-service-contract     dotlrn-dotlrn       forums-portlet       weblogger-portlet
	  acs-subsite              dotlrn-evaluation   fs-portlet           workflow
	  acs-tcl                  dotlrn-faq          general-comments     xml-rpc
    </pre>


    <p>
      Next, copy the <kbd>/openacs-4</kbd> directory to where ever you
      prefer your webserver root to be, traditionally
      <kbd>/web</kbd>. Now you can continue with the OACS <a
      href="http://openacs.org/doc/openacs-5-2/openacs.html">installation
      document</a> at the third point "Prepare the database" of the 2nd section 
	  "Installation option 2". Continue with the
      standard OACS installation process until your reach the
      &quot;Congratulations!&quot; front page, then return here.
	</p>

  <h2>Install dotLRN on your system</h2>
  <p>
     Go the the &quot;Site Wide Administration&quot; on your system
     at <a href="/acs-admin">/acs-admin/</a> and hit the
     &quot;Install software&quot; link, then the "Install from local" one 
	 and finally choose "Service" type. After the installer loads, you
     will see a list of the packages you just got from CVS. Check the
     packages you want to install and hit "Install or upgrade checked 
	 applications" button at the bottom of the page. 
  </p>

  <h2>Explore dotLRN</h2>

  <p>
      Go to dotLRN Administration at
      <a href="/dotlrn/admin">/dotlrn/admin</a>.  Make some dotLRN
      users, terms, departments, classes. 
  </p>

  <p>
      Here are some suggestions for things to check out in dotlrn:
  </p>

  <p>
      Goto /dotlrn your "workspace". Click the "Control Panel" link at
      the top and try the "Customize this portal" link there.  Goto
      the admin pages for a class or community and try the "Manage
      Membership" link. Create a new sugroup for a class or community. 
      Edit or create new "Custom Portlets". 
  </p>

      
  <p>

     Enjoy!

  </p>

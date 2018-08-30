<master>
<property name="doc(title)">@title;literal@</property>
<property name="context">@context;literal@</property>

<h1>@title;noquote@</h1>
<p>
The current version of CKEditor is @version@.
<if @resources@ not nil><p>This version of CKEditor is installed locally
under <strong>@resources@</strong></if>
<else><p>In the current installation, this version of KEditor can be used via CDN <strong>@cdn@</strong>.
  <if @writable@ true>
  <p>Do you want to <a href="download" class="button">download</a>
  version @version@ of CKEditor to your file system?</p>
  </if>
  <else>
  <p>The directory <strong>@path@</strong> is NOT writable for the server. In
  order to be able to download the CKEditor via this web interface,
  please change the permissions so that OpenACS can write to it.</p>
  </else>
</else>.
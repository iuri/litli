
#xowiki-portlet.manage-pages# <a href='@applet_url@'>#xowiki-portlet.community-wiki#</a>
<if @package_id@ eq "">
  <small>No community specified</small>
</if>
<else>
<ul>
<multiple name="content">
  <li>
    @content.pretty_name@<small> <a class="button" href="@applet_url@admin/portal-element-remove?element_id=@content.element_id@&amp;referer=@referer@&amp;portal_id=@template_portal_id@">#xowiki-portlet.remove-portlet#</a></small>
  </li>
</multiple>
</ul>
@form;noquote@
</else>

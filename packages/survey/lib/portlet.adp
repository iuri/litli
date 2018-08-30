<if @display_empty_p@ true or @active:rowcount@ gt 0>
<div<if @id@ not nil> id="@id@"</if><if @class@ not nil> class="@class@"</if>>
<h4><a href="@base_url@">@package_name@</a></h4>
<if @active:rowcount@ eq 0><em>None active</em></if><else>
<ul>
<multiple name="active">
  <li><a href="@active.url@">@active.name@</a>
</multiple>
</ul>
</else>
</div>
</if>
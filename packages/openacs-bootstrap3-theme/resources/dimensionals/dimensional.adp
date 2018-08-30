<div class="dimensional dimensional-list"><ul class="list-inline">
<multiple name="dimensional">
<li><span style="font-weight:bold">@dimensional.label@</span>
<group column="key">
  <if @dimensional.selected@ true><span class="btn btn-primary">@dimensional.group_label@</span>
  </if>
  <else><a class="btn btn-default" href="@dimensional.href@">@dimensional.group_label@</a>
  </else>
</group></li>
</multiple>
</ul></div>


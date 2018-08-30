<div style="text-align:center">
<if @connections:rowcount@ gt 0>
<include src="/packages/ajax-filestorage-ui/lib/tagslist" &connections="connections">
</if>
<else>
No tags found.
</else>
</div>
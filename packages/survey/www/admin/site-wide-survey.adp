<master>

<if @surveys:rowcount@ gt 0>
	<multiple name="surveys">
@surveys.parent_name@
<ul>
<group column="package_id">

	  <li>
	  <a href="@surveys.url@admin/one?survey_id=@surveys.survey_id@">@surveys.name@</a>

	</li>

</group>
</ul>	</multiple>
</if>      

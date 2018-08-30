<master>

<property name=title>#survey.lt_Survey_Administration#</property>
<property name="link_all">1</property>
<ul>
<multiple name=surveys>
<group column="enabled_p">
<li> <a href="one?survey_id=@surveys.survey_id@">@surveys.name@</a> 
<if @surveys.enabled_p;literal@ false><span style="color: #f00">#survey.disabled#</span></if>
</group>
</multiple>
<p>
<li> <a href="survey-create">#survey.New_Survey#</a>
</ul>


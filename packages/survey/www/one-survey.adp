<master>
<property name="title">#survey.Surveys#</property>
<if @admin_p;literal@ true><p style="text-align: right;"><a href="admin/">#survey.lt_img_srcgraphicsadming_1#</a></p></if>
    <ul>
      
      <multiple name="survey_details">
	<li>@survey_details.name@
	  <if @survey_details.single_response_p@ eq "t" and
	@survey_details.response_id@ nil> <a
	href="respond?survey_id=@survey_details.survey_id@">#survey.Answer_Survey#</a></if>
	  <if @survey_details.single_response_p;literal@ false><a
	href="respond?survey_id=@survey_details.survey_id@">#survey.Answer_Survey#</a></if>
	</li>
	<if @survey_details.response_id@ not nil>

	<group column="survey_id">
	<ul>
	    <li>#survey.lt_Previous_response_on__1#
	    <a href="one-respondent?survey_id=@survey_details.survey_id@&amp;#@survey_details.response_id@">#survey.View_Response#</a>
	    <if @survey_details.editable_p;literal@ true>
	    <a href="respond?survey_id=@survey_details.survey_id@&amp;response_id=@survey_details.response_id@">#survey.Edit_Response#</a></if>
	    </li>
	 </ul>

	</group>
	</if>
      </multiple>
      
    </ul>




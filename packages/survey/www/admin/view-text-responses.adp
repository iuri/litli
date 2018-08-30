<master src="master">

<property name="survey_id">@survey_id;noquote@</property>

<property name="title">#survey.lt_survey_name_Responses_1#</property>
<property name="context">@context;noquote@</property>
@question_text@ 
<hr>
<if @responses:rowcount@ eq 0>
	<em>#survey.No_Responses#</em>
	</if>
      <multiple name="responses">
<a href="one-respondent?user_id=@responses.creation_user@&amp;survey_id=@survey_id@">@responses.respondent_name@</a>
	  #survey.lt_on_responsessubmissio#
<br>
</multiple>


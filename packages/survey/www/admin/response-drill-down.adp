<master src="master">
<property name="survey_id">@survey_id;noquote@</property>

<property name=title>#survey.lt_People_who_answered_r#</property>
<property name=context>@context;noquote@</property>

#survey.lt_survey_name_responder#

<ul>
<multiple name="user_responses">
<li><a href="one-respondent?user_id=@user_responses.user_id@&amp;survey_id=@survey_id@">@user_responses.responder_name@</a></li>

</multiple>
</ul>



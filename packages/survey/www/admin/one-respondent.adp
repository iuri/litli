<master src="master">

<property name="survey_id">@survey_id;noquote@</property>

<property name="survey_id">@survey_id;noquote@</property>
<property name="survey_name@">;noquote@survey_info.name@</property>
<property name="title">#survey.lt_One_Respondent_first_#</property>
<property name="context">@context;noquote@</property>
<table class="table-display" cellspacing="0" cellpadding="5">
<tr class="table-header"><td>
  #survey.Here_is_what# <a href="/shared/community-member?user_id=@user_id@">@first_names@ @last_name@</a> #survey.lt_had_to_say_in_respons#
</td>


<multiple name="responses">

    <tr class="odd">
            <td>
              <a href="@responses.respond_url@">
                <img src="../graphics/edit.gif" style="float:right; border: 0; vertical-align:top;" alt="#survey.Edit#">
              </a>

<group column="initial_response">

<if @responses.original_p;literal@ true><a href="response-delete?response_id=@response_id@">
<img src="../graphics/delete.gif" style="float:right; vertical-align:top; border: 0;" alt="#survey.Delete#"></a>
</if>
 <strong>[<if
      @responses.original_p@>#survey.Original#</if><else>#survey.Edited#</a></else>
      #survey.lt_Response_on_responses#</strong> 
	  <br>
@responses.response_display;noquote@


</group>
</td>
</tr>
<tr class="odd"><td><hr class="main_color"></td></tr>
</multiple>
</table>




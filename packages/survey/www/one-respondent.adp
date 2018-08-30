<master>
<property name="title">#survey.lt_Answers_to_survey_nam#</property>
<property name="context">@context;noquote@</property>

    @description;noquote@
    <p>
      <multiple name="responses">	
	<if @responses.rownum@ ne @responses:rowcount@>
          <a href="#@responses.response_id@"><%= [lc_time_fmt @responses.pretty_submission_date_ansi@ "%Q"]%></a> |
	</if>
	<else>
          <a href="#@responses.response_id@"><%= [lc_time_fmt @responses.pretty_submission_date_ansi@ "%Q"]%></a>
	</else>
      </multiple>
      <p>
        <multiple name=responses>
          <table width="100%" cellpadding="2" cellspacing="2" border="0">
            <tr class="table-header" style="background-color:#e6e6e6;">
              <td><a name="@responses.response_id@">#survey.lt_Your_response________#</a>
                <if @editable_p;literal@ true>
                  [<a href="@responses.respond_url@">#survey.edit_this_response#</a>]
                </if>
	      </td>
            </tr>
            <tr class="odd" style="background-color:#f4f4f4;">
              <td>@responses.answer_summary;noquote@</td>
            </tr>
          </table>
        </multiple>


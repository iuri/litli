<master>
<property name="survey_id">@survey_id;noquote@</property>

<property name="title">#survey.lt_One_Survey_survey_inf#</property>
<property name="context">@context;noquote@</property>
<p><a href=".">#survey.lt_Main_Survey_Administr#</a></p>
<h2><strong style="font-size: large">@survey_info.name@</strong> #survey.-__Created_by# <a href="@user_link@">@survey_info.creator_name@</a>#survey._on_creation_date#</h2>
<table class="table-display" cellpadding="2" cellspacing="0">
	<tr class="even"><td> </td><td> #survey.This_survey_is# <if @survey_info.enabled_p;literal@ true><%= [lang::util::localize @survey_info.enabled_display@]%></if><else><span style="color: #f00;"><%=[lang::util::localize @survey_info.enabled_display@]%></span></else>. - <a href="@toggle_enabled_url@">@toggle_enabled_text@</a></td></tr>

	<tr class="odd"> 
<td valign="top">#survey.Survey_Name#<p>
#survey.Description# </td>
	<td>
<a href="survey-preview?survey_id=@survey_id@">#survey.Preview#</a>

	 <a href="name-edit?survey_id=@survey_id@">#survey.Edit#</a>
@survey_info.name@<p>
@survey_info.description;noquote@</td>
</tr>
	<tr class="even"><td>#survey.View_Responses# </td><td >
	<a
	href="respondents?survey_id=@survey_id@">#survey.By_user#</a> | <a
	href="responses?survey_id=@survey_id@">#survey.Summary#</a> | 
	<a href="responses-export?survey_id=@survey_id@"> #survey.CSV_file#</a></td>
	</tr>
	<tr class="odd"><td valign="top" rowspan="2">#survey.Response_Options# </td><td> <%= [lang::util::localize @survey_info.single_response_display@]%> - [ 
	<a href="response-limit-toggle?survey_id=@survey_id@">@response_limit_toggle@</a>
	]</td></tr>
	
      
	<tr class="odd"><td><if @survey_info.editable_p;literal@ true> #survey.lt_Users_may_edit_their_#</if><else>#survey.lt_Users_may_not_edit_th#</else> - [ <a
	href="response-editable-toggle?survey_id=@survey_id@">#survey.make# <if
	@survey_info.editable_p@>#survey.non-#</if>#survey.editable#</a> ]</td></tr>

      <tr class="odd">
        <td>#survey.Display_Options# </td>
        <td><%= [lang::util::localize "#survey.@survey_info.display_type@#"]%> - <list name="survey_display_types">
            <if @survey_info.display_type@ ne @survey_display_types:item@>
              [<a href="survey-display-type-edit?display_type=@survey_display_types:item@&amp;survey_id=@survey_id@"><%= [lang::util::localize "#survey.@survey_display_types:item@#"]%></a>]
            </if>
          </list>
        </td>
      </tr>
	
      
<tr class="odd"><td valign="top" rowspan="2">#survey.Email_Options#</td><td >@notification_chunk;noquote@</td></tr>

	<tr class="odd"><td ><a href="send-mail?survey_id=@survey_id@">#survey.Send_bulkmail#</a> #survey.lt_regarding_this_survey# </td></tr>
	
      
	<tr><td></td><td >
	
      <tr class="even">
	<td>#survey.Extreme_Actions# </td><td >
	<a href="survey-delete?survey_id=@survey_id@">#survey.Delete_this_survey#</a> #survey.lt_-_Removes_all_questio#<br>
	<a href="survey-copy?survey_id=@survey_id@">#survey.Copy_this_survey#</a> #survey.lt_-_Lets_you_use_this_s#
	</td></tr>
</table>
<br>

<h3>#survey.Questions#</h3>
<table cellspacing="0">
<if @questions:rowcount@ eq 0>
    <tr class="odd">
  </else>
<td></td><td><a href="question-add?section_id=@survey_info.section_id@">#survey.add_new_question#</a></tr></tr>
</if>
<multiple name="questions">

  <if @questions.rownum@ odd>
    <tr class="odd">
  </if>
  <else>
    <tr class="even">
  </else>

<td valign="top">@questions.rownum@.  <a name="@questions.sort_order@"></a></td>

<td><a	href="@questions.question_modify_url@">#survey.Edit#</a>
<if @questions.active_p;literal@ false><span style="color: #f00;">#survey.inactive#</span></if>
<a href="@questions.question_copy_url@">#survey.Copy#</a>
<a href="@questions.question_add_url@">#survey.Add_New#</a><img src="../graphics/spacer.gif" style="border:0;" alt="" width="10">
<if @questions.rownum@ lt @questions:rowcount@ ><a
	  href="@questions.question_swap_down_url@"><img src="../graphics/down" style="border:0;" alt="#survey.Move_Down#"></a></if><if @questions.rownum@ gt 1><a
	  href="@questions.question_swap_up_url@"><img src="../graphics/up.gif" style="border:0;" alt="#survey.Move_Up#"></a></if><a href="@questions.question_delete_url@"><img src="../graphics/delete.gif" style="border:0;" alt="#survey.Delete#"></a></td></tr>

  <if @questions.rownum@ odd>
    <tr class="odd">
  </if>
  <else>
    <tr class="even">
  </else>
<td colspan="3">
  <div>@questions.question_display;noquote@</div>
</td></tr>
<if @questions.rownum@ eq @questions:rowcount@>
  <if @questions.rownum@ odd>
    <tr class="even">
  </if>
  <else>
    <tr class="odd">
  </else>
<td></td><td><a href="question-add?section_id=@survey_info.section_id@">#survey.add_new_question#</a></tr>
</if>
</multiple>
</table>      



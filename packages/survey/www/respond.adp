<master>
<property name=title>#survey.One_Survey_name#</property>
<property name=context>@context;noquote@</property>

<form enctype="multipart/form-data" method="post" action="process-response">
      <if @initial_response_id@ not nil>
        <div>
          <input type="hidden" name="initial_response_id" value="@initial_response_id@">
        </div>
      </if>

    <table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
          <td class="tabledata">@description;noquote@</td>
        </tr>
	<tr>
	  <td class="tabledata"><span style="color: #f00;">*</span> #survey.lt_denotes_a_required_qu#</td>                
	</tr>        
        <tr>
          <td class="tabledata"><hr></td>
        </tr>
        
        <tr>
          <td class="tabledata">
	    @form_vars;noquote@
            <include src="one_@display_type;noquote@" questions=@questions;noquote@>
              <input type="submit" value="@button_label@">
          </td>
        </tr>
    </table>
</form>


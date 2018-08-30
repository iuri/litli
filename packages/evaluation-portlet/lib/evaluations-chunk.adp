<if @simple_p;literal@ true>
<div id="evaluations">
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td valign="middle" width="30%" style="padding-left: 10px;"><strong>@grade_plural_name@</strong> (@grade_weight@% #evaluation-portlet.total_grade#)</td>
    <td valign="middle" width="67%" align="right" style="font-size: 10px; color: #354785; font-weight: bold;">  
@actions;noquote@
    </td>
  </tr>
</table>
</div>
</if>

<listtemplate name="grade_tasks_@grade_id@"></listtemplate>
<if @simple_p;literal@ false>
 <if @admin_p;literal@ true>
   #evaluation.lt_Weight_used_in_grade_#
 </if>
 <else>
 #evaluation-portlet.lt_smallTotal_points_in_#
 </else>
</if>

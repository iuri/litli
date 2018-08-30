
  <if @shaded_p;literal@ false>
   <ul>
    <if @admin_p;literal@ true>
     <if @simple_p;literal@ true>
      <li><a href="evaluation/admin/grades/grades" title="#evaluation-portlet.lt_Admin_my_Asignment_T#">#evaluation-portlet.lt_Admin_my_Assignment_T#</a> (#evaluation-portlet.admin_help#)</li>
      <li><a href="evaluation/admin/grades/grades-reports" title="#evaluation-portlet.view_students_grades#">#evaluation-portlet.view_students_grades#</a> (#evaluation-portlet.view_grades_help#)</li>
     </if>
     <else>
      <li><a href="evaluation/admin/grades/grades" title="#evaluation-portlet.lt_Admin_my_Assignment_T#">#evaluation-portlet.lt_Admin_my_Assignment_T#</a></li>
     </else>  
    </if>
      <li>@notification_chunk;noquote@</li>
    </ul>

    <if @grades:rowcount@ eq 0>
       <p>#evaluation-portlet.lt_There_are_no_tasks_to#</p>
    </if>
    <else>
      <multiple name="grades">
       <if @simple_p;literal@ false>
        <h2>@grades.grade_plural_name;noquote@</h2>
       </if> 
       <include src="../lib/evaluations-chunk" grade_id="@grades.grade_id;literal@" grade_item_id="@grades.grade_item_id;literal@" evaluations_orderby="@evaluations_orderby;literal@" page_num="@page_num;literal@">
      </multiple>

     <if @admin_p@ eq "0" and @one_instance_p@ eq "1">
      <p>#evaluation-portlet.lt_Your_total_grade_in_t# <strong>@total_class_grade@/@max_possible_grade@ </strong></p>
     </if>
    </else>

  </if>
  <else>
    #new-portal.when_portlet_shaded#
  </else>



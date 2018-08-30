
  <if @shaded_p;literal@ false>
    <p>@notification_chunk;noquote@</p>

    <if @grades:rowcount@ eq 0>
      <p>#evaluation-portlet.lt_There_are_no_tasks_fo#</p>
    </if>
    <else>
       <multiple name="grades">
        <h2>@grades.grade_plural_name@</h2>
        <include src="../lib/tasks-chunk" grade_id="@grades.grade_id;literal@" grade_item_id="@grades.grade_item_id;literal@" assignments_orderby="@assignments_orderby;literal@" page_num="@page_num;literal@">
      </multiple>
    </else>
  </if>
  <else>
    #new-portal.when_portlet_shaded#
  </else>



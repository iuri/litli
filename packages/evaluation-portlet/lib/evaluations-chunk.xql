<?xml version="1.0"?>

<queryset>

<fullquery name="get_grade_info">      
      <querytext>

		select grade_plural_name, grade_plural_name as low_name,grade_name,weight as grade_weight,weight as category_weight from evaluation_grades where grade_id = :grade_id
	
      </querytext>
</fullquery>

<fullquery name="solution_info">      
      <querytext>

	    select ets.solution_id
	    from evaluation_tasks_sols ets, cr_items cri
	    where ets.task_item_id = (select task_item_id from evaluation_tasks where task_id=:task_id)
	    and cri.live_revision = ets.solution_id
	
      </querytext>
</fullquery>


</queryset>

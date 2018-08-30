<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.3</version></rdbms>

<fullquery name="get_grades">      
      <querytext>

	select eg.grade_plural_name,
	eg.grade_id,
	eg.grade_item_id
	from evaluation_grades eg, acs_objects ao
	where exists (select 1 from cr_items
           where live_revision = eg.grade_id) 
	  and eg.grade_item_id = ao.object_id
	  and ao.context_id in  ([join $list_of_package_ids ,])
	order by grade_plural_name desc
	
      </querytext>
</fullquery>

<fullquery name="get_total_grade">      
      <querytext>

        select coalesce(
	sum(round((ese.grade*et.weight*eg.weight)/10000,2)),0) as grade
        from evaluation_grades eg, evaluation_tasks et, evaluation_student_evals ese, acs_objects ao
        where et.task_item_id = ese.task_item_id
		  and et.grade_item_id = eg.grade_item_id
          and eg.grade_item_id = ao.object_id
   		  and ao.context_id = [lindex $list_of_package_ids 0]
   		  and ese.party_id = 

	( select
	CASE 
	  WHEN et3.number_of_members = 1 THEN $user_id
	  ELSE 
	(select etg2.group_id from evaluation_task_groups etg2,
                                                      evaluation_tasks et2,
                                                      acs_rels map
                                                      where map.object_id_one = etg2.group_id
                                                        and map.object_id_two = $user_id
                                                        and etg2.task_item_id = et2.task_item_id
                                                        and et2.task_id = et.task_id)

	END as nom
               from evaluation_tasks et3
              where et3.task_id = et.task_id
	)

	and exists (select 1 from cr_items where live_revision = eg.grade_id)
	and exists (select 1 from cr_items where live_revision = et.task_id)
	and exists (select 1 from cr_items where live_revision = ese.evaluation_id)
	
      </querytext>
</fullquery>

<fullquery name="max_possible_grade">      
      <querytext>

    select sum(round(et.weight*eg.weight/100,2))
    from evaluation_tasks et,
    evaluation_grades eg,
    cr_items cri1,
    cr_items cri2,
    acs_objects ao
    where et.grade_item_id = eg.grade_item_id
    and cri1.live_revision = eg.grade_id
    and cri2.live_revision = et.task_id
    and et.requires_grade_p = 't'
    and ao.object_id = eg.grade_item_id
    and ao.context_id = :package_id

      </querytext>
</fullquery>

</queryset>

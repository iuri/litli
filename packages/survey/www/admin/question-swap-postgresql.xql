<?xml version="1.0"?>
<queryset>

     <rdbms><type>postgresql</type><version>7.1</version></rdbms>
  
<fullquery name="swap_sort_orders">      
      <querytext>
	update survey_questions
	set sort_order = (case when sort_order = :sort_order :: integer then
	:next_sort_order :: integer when sort_order = :next_sort_order
	::integer then :sort_order ::integer end)
	where section_id = :section_id
	and sort_order in (:sort_order, :next_sort_order)
      </querytext>
</fullquery>

 
</queryset>

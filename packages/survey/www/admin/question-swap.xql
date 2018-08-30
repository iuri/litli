<?xml version="1.0"?>
<queryset>

<fullquery name="swap_sort_orders">      
      <querytext>
update survey_questions
set sort_order = (case when sort_order = :sort_order then :next_sort_order when sort_order = :next_sort_order then :sort_order end)
where section_id = :section_id
and sort_order in (:sort_order, :next_sort_order)
      </querytext>
</fullquery>

 
</queryset>

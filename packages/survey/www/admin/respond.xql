<?xml version="1.0"?>
<queryset>

<fullquery name="survey_exists">      
      <querytext>
     
	    select 1 from surveys where survey_id = :survey_id
	
      </querytext>
</fullquery>

<fullquery name="question_ids_select">      
      <querytext>
      
    select question_id
    from survey_questions  
    where section_id = :section_id
    and active_p = 't'
    order by sort_order

      </querytext>
</fullquery>

<fullquery name="survey_sections">
<querytext>
select section_id from survey_sections
where survey_id=:survey_id
</querytext>
</fullquery>

</queryset>

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


<fullquery name="count_responses">      
      <querytext>
      select count(*) from survey_responses, 
	acs_objects
	where survey_id=:survey_id
	and survey_responses.response_id=acs_objects.object_id
	and acs_objects.creation_user=:user_id
	and initial_response_id is null
      </querytext>
</fullquery>


</queryset>

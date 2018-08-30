<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

 
<fullquery name="get_responses">      
      <querytext>

     select response_id, case when initial_response_id is NULL then 'T' else 'F' end as original_p, nvl(initial_response_id,response_id) as initial_response, creation_date
 from survey_responses, acs_objects
where response_id = object_id
and survey_response.initial_user_id(response_id) = :user_id
and survey_id=:survey_id
order by nvl(initial_response_id,response_id) desc, creation_date desc

      </querytext>
</fullquery>

</queryset>
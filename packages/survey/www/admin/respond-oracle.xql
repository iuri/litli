<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_initial_response">      
      <querytext>
      
	select survey_response.initial_response_id(:response_id) as initial_response_id from dual

      </querytext>
</fullquery>

<fullquery name="count_responses">      
      <querytext>
      select count(*) from survey_responses
	where survey_id=:survey_id
	and survey_response.initial_user_id(response_id)=:user_id
	and initial_response_id is null
      </querytext>
</fullquery>

 
</queryset>

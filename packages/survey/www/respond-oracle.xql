<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_initial_response">      
      <querytext>
      
	select nvl(initial_response_id,response_id) as initial_response_id from survey_responses where response_id=:response_id

      </querytext>
</fullquery>
 
</queryset>

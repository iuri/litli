<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_initial_response">      
      <querytext>
      
	select coalesce(initial_response_id,response_id) as initial_response_id  from survey_responses where response_id=:response_id

      </querytext>
</fullquery>
 
</queryset>

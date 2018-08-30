<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="delete_response">
    <querytext>
	begin
	  survey_response.remove(:response_id);
	end;
    </querytext>
</fullquery>


<fullquery name="get_response_info">
    <querytext>
	select survey_id, survey_response.initial_user_id(response_id) as user_id, response_id, initial_response_id
	from survey_responses
	where survey_id=:survey_id
	and survey_response.initial_user_id(response_id)=:user_id
    </querytext>
</fullquery>

</queryset>
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
select survey_id, survey_response.initial_user_id(response_id) as user_id,
	u.first_names || ' ' || last_name as user_name, 
	o.creation_date as response_date
from survey_responses, cc_users u, acs_objects o
where response_id=:response_id
and o.object_id = response_id
and u.user_id = survey_response.initial_user_id(response_id)
</querytext>
</fullquery>

</queryset>
<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="delete_response">
<querytext>
begin
	perform survey_response__remove(:response_id);
return null;
end;
</querytext>
</fullquery>

<fullquery name="get_response_info">
<querytext>
select survey_id, survey_response__initial_user_id(response_id) as user_id
from survey_responses
where response_id=:response_id
</querytext>
</fullquery>

</queryset>

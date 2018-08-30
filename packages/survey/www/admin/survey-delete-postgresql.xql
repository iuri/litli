<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>
<fullquery name="delete_survey">
<querytext>
begin
	perform survey__remove(:survey_id);
return NULL;
end;
</querytext>
</fullquery>

</queryset>
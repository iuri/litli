<?xml version="1.0"?>
<queryset>
<fullquery name="survey_display_type_edit">
<querytext>
update surveys 
 set display_type= :display_type
 where survey_id = :survey_id
</querytext>
</fullquery>
</queryset>
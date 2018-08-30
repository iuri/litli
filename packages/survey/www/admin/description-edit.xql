<?xml version="1.0"?>
<queryset>

<fullquery name="survey_properties">      
      <querytext>
      select name as survey_name, description, description_html_p as desc_html
from surveys
where survey_id = :survey_id
      </querytext>
</fullquery>


<fullquery name="survey_update_description">      
      <querytext>
      update surveys 
      set description = :description,
          description_html_p = :description_html_p
          where survey_id = :survey_id
      </querytext>
</fullquery>
 
</queryset>

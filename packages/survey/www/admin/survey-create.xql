<?xml version="1.0"?>

<queryset>

 
<fullquery name="add_variable_name">      
      <querytext>
      insert into survey_variables
                  (variable_id, variable_name)
                  values
                  (:variable_id, :variable_name)
      </querytext>
</fullquery>

 
<fullquery name="map_variable_name">      
      <querytext>
      insert into survey_variables_surveys_map
                  (variable_id, section_id)
                  values
                  (:variable_id, :section_id)
      </querytext>
</fullquery>

 
<fullquery name="map_logic">      
      <querytext>
      insert into survey_logic_surveys_map
              (logic_id, section_id)
              values
              (:logic_id, :section_id)
      </querytext>
</fullquery>

</queryset>

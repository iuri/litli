<?xml version="1.0"?>
<queryset>

 
<fullquery name="count_variable_names">      
      <querytext>
      select count(variable_name) as n_variables
	from survey_variables, survey_variables_surveys_map
        where survey_variables.variable_id = survey_variables_surveys_map.variable_id
        and section_id = :section_id
      </querytext>
</fullquery>

<fullquery name="select_variable_names">      
      <querytext>
       select variable_name, survey_variables.variable_id as variable_id
               from survey_variables, survey_variables_surveys_map
               where survey_variables.variable_id = survey_variables_surveys_map.variable_id
               and section_id = :section_id order by survey_variables.variable_id
      </querytext>
</fullquery>

 
</queryset>

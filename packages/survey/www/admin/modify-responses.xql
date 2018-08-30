<?xml version="1.0"?>
<queryset>

<fullquery name="survey_name_from_id">      
      <querytext>
      select name from survey_sections where section_id=:section_id
      </querytext>
</fullquery>

 
<fullquery name="survey_question_text_from_id">      
      <querytext>
      select question_text
from survey_questions
where question_id = :question_id
      </querytext>
</fullquery>

 
<fullquery name="get_variable_names">      
      <querytext>
      select variable_name, survey_variables.variable_id as variable_id
  from survey_variables, survey_variables_surveys_map
  where survey_variables.variable_id = survey_variables_surveys_map.variable_id
  and section_id = :section_id
  order by variable_name
      </querytext>
</fullquery>

 
<fullquery name="get_choices">      
      <querytext>
      select choice_id, label from survey_question_choices where question_id = :question_id order by choice_id
      </querytext>
</fullquery>

 
<fullquery name="get_scores">      
      <querytext>
      select score, survey_variables.variable_id as variable_id
      from survey_choice_scores, survey_variables
      where survey_choice_scores.choice_id = :choice_id
      and survey_choice_scores.variable_id = survey_variables.variable_id
      order by variable_name
      </querytext>
</fullquery>

 
</queryset>

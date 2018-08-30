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

 
</queryset>

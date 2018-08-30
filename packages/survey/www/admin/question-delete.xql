<?xml version="1.0"?>
<queryset>

<fullquery name="section_id_from_question_id">      
      <querytext>
	select section_id
	  from survey_questions
	 where question_id = :question_id
      </querytext>
</fullquery>

 
<fullquery name="survey_number_responses">      
      <querytext>
      select count(*)
from survey_question_responses
where question_id = :question_id
      </querytext>
</fullquery>

 
<fullquery name="survey_question_responses_delete">
<querytext>
	delete from survey_question_responses
	where question_id=:question_id
</querytext>
</fullquery>

<fullquery name="survey_question_choices_delete">      
      <querytext>
      delete from survey_question_choices where
         question_id = :question_id
      </querytext>
</fullquery>

<fullquery name="get_question_details">
<querytext>
	select * from survey_questions where question_id=:question_id
</querytext>
</fullquery> 

<fullquery name="survey_renumber_questions">
<querytext>
update survey_questions set sort_order=sort_order - 1 
where section_id = :section_id
and sort_order > :sort_order
</querytext>
</fullquery>

</queryset>

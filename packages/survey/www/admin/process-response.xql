<?xml version="1.0"?>
<queryset>

<fullquery name="get_response_count">
    <querytext>
	select count(*) from survey_responses
	where response_id=:new_response_id
    </querytext>
</fullquery>

<fullquery name="get_initial_creation_user_id">
    <querytext>
	select creation_user as initial_creation_user_id
	from survey_responses, acs_objects
	where response_id = :initial_response_id
	and survey_responses.response_id = acs_objects.object_id
    </querytext>
</fullquery>


<fullquery name="section_exists">      
      <querytext>
      
	    select 1 from survey_sections where section_id = :section_id
	
      </querytext>
</fullquery>

 
<fullquery name="survey_question_info_list">      
      <querytext>
      
	    select question_id, question_text, abstract_data_type, presentation_type, required_p
	    from survey_questions
	    where section_id = :section_id
	    and active_p = 't'
	    order by sort_order
	
      </querytext>
</fullquery>

 
<fullquery name="survey_question_info_list">      
      <querytext>
      
	    select question_id, question_text, abstract_data_type, presentation_type, required_p
	    from survey_questions
	    where section_id = :section_id
	    and active_p = 't'
	    order by sort_order
	
      </querytext>
</fullquery>

 
<fullquery name="survey_question_response_checkbox_insert">      
      <querytext>
      insert into survey_question_responses (response_id, question_id, choice_id)
 values (:response_id, :question_id, :response_value)
      </querytext>
</fullquery>

 
<fullquery name="survey_question_response_choice_insert">      
      <querytext>
      insert into survey_question_responses (response_id, question_id, choice_id)
 values (:response_id, :question_id, :response_value)
      </querytext>
</fullquery>

 
<fullquery name="survey_question_choice_shorttext_insert">      
      <querytext>
      insert into survey_question_responses (response_id, question_id, varchar_answer)
 values (:response_id, :question_id, :response_value)
      </querytext>
</fullquery>

 
<fullquery name="survey_question_response_boolean_insert">      
      <querytext>
      insert into survey_question_responses (response_id, question_id, boolean_answer)
 values (:response_id, :question_id, :response_value)
      </querytext>
</fullquery>

 
<fullquery name="survey_question_response_integer_insert">      
      <querytext>
      insert into survey_question_responses (response_id, question_id, number_answer)
 values (:response_id, :question_id, :response_value)
      </querytext>
</fullquery>

 
<fullquery name="survey_question_response_date_insert">      
      <querytext>
      insert into survey_question_responses (response_id, question_id, date_answer)
 values (:response_id, :question_id, :response_value)
      </querytext>
</fullquery>

 
<fullquery name="get_type">      
      <querytext>
      select type from survey_sections where section_id = :section_id
      </querytext>
</fullquery>

 
<fullquery name="survey_name_from_id">      
      <querytext>
      select name from survey_sections where section_id = :section_id
      </querytext>
</fullquery>


<fullquery name="survey_prior_attachment_response">      
      <querytext>
select
  attachment_answer
from
  survey_question_responses
where
  response_id = :edited_response_id
  and question_id = :question_id
 
      </querytext>
</fullquery>

 

<fullquery name="survey_question_response_file_attachment_insert">
      <querytext>
      insert into survey_question_responses
      (response_id, question_id, attachment_answer)
       values
      (:response_id, :question_id, :revision_id)
      </querytext>
</fullquery>

</queryset>

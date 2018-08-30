<?xml version="1.0"?>
<queryset>

<fullquery name="renumber_sort_orders">      
      <querytext>
      update survey_questions
                                   set sort_order = sort_order + 1
                                   where section_id = :section_id
                                   and sort_order > :after
      </querytext>
</fullquery>

 
<fullquery name="add_question_text">      
      <querytext>
      
	    update survey_questions
	    set question_text = :question_text
	    where question_id = :question_id
	
      </querytext>
</fullquery>

 
<fullquery name="insert_survey_question_choice">      
      <querytext>
      insert into survey_question_choices
      (choice_id, question_id, label, sort_order)
      values
      (:choice_id, :question_id, :trimmed_response, :count)
      </querytext>
</fullquery>

 
<fullquery name="insert_survey_scores">      
      <querytext>
      insert into survey_choice_scores
      (choice_id, variable_id, score)
      values
      (:choice_id, :variable_id, :score)
      </querytext>
</fullquery>

<fullquery name="already_inserted_p">
      <querytext>

      select case when count(*) = 0 then 0 else 1 end from survey_questions where question_id = :question_id

      </querytext>
</fullquery>

<fullquery name="max_question">
    <querytext>
	select max(sort_order) from survey_questions
	where section_id=:section_id
    </querytext>
</fullquery>
 
</queryset>

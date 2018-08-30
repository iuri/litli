<?xml version="1.0"?>
<queryset>

<fullquery name="one_question">      
    <querytext>
	select sq.question_text, sq.section_id
	from survey_questions sq, survey_sections sec
	where sq.question_id = :question_id
	and sq.section_id = sec.section_id
      </querytext>
</fullquery>

 
<fullquery name="abstract_data_type">      
    <querytext>
	select abstract_data_type
	from survey_questions q
	where question_id = :question_id
    </querytext>
</fullquery>
 
</queryset>

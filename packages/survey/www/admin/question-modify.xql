<?xml version="1.0"?>
<queryset>

<fullquery name="survey_number_responses">
<querytext>
	select count(*)
	from survey_question_responses
	where question_id=:question_id
</querytext>
</fullquery>

<fullquery name="survey_name_from_id">      
      <querytext>
      select name from survey_sections where section_id=:section_id
      </querytext>
</fullquery>

 
<fullquery name="survey_question_details">      
      <querytext>
select 
	question_id,
	question_text,
	abstract_data_type,
	presentation_alignment,
	presentation_options,
	sort_order as question_number,
	required_p,
	sort_order
from survey_questions
where question_id = :question_id
      </querytext>
</fullquery>

<fullquery name="survey_question_valid_responses">
<querytext>
select label from survey_question_choices
where question_id=:question_id
order by sort_order
</querytext>
</fullquery>

<fullquery name="presentation">
<querytext>
select presentation_type, presentation_options, abstract_data_type,
sort_order as anchor
from survey_questions
where question_id=:question_id
</querytext>
</fullquery>

<fullquery name="survey_question_update">
<querytext>
update survey_questions
     set question_text=:question_text,
         active_p=:active_p,
         required_p=:required_p,
	presentation_options=:presentation_options
     where question_id=:question_id
</querytext>
</fullquery>

<fullquery name="insert_new_choice">
<querytext>
insert into survey_question_choices
(choice_id, question_id, label, sort_order)
values (survey_choice_id_sequence.nextval, :question_id, :choice_name, :choice_value)
</querytext>
</fullquery>

<fullquery name="update_new_choice">
<querytext>
update survey_question_choices
                set label=:choice_name where choice_id=:choice_id_to_update
</querytext>
</fullquery>

<fullquery name="delete_old_choice">
<querytext>
delete from survey_question_choices where choice_id = :choice_id_to_delete
</querytext>
</fullquery>

<fullquery name="get_choice_id">
<querytext>
        select choice_id from survey_question_choices
        where question_id=:question_id
        order by sort_order
</querytext>
</fullquery>

</queryset>

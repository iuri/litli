<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="create_question">      
      <querytext>

	select survey_question__new (
		    :question_id,
		    :section_id,
                    :sort_order,
                    :question_text, 
                    :abstract_data_type,
                    :required_p,
                    :active_p,
                    :presentation_type,
		    :presentation_options,
                    :presentation_alignment,
		    :user_id,
		    :section_id
	)
	
      </querytext>
</fullquery>

 
<fullquery name="get_choice_id">      
      <querytext>
      select nextval as choice_id from survey_choice_id_sequence 
      </querytext>
</fullquery>

<fullquery name="already_inserted_p">
    <querytext>
	select case when count(*) = 0 then 0 else 1 end from survey_questions where question_id = :question_id
    </querytext>
</fullquery>

</queryset>

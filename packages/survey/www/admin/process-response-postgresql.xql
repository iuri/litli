<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="create_response">      
      <querytext>
	select survey_response__new (
		:response_id,
		:survey_id,		
		null,
		'f',
		:user_id,
		:creation_ip,
		:survey_id,
		:initial_response_id
	    )
      </querytext>
</fullquery>

<fullquery name="survey_question_response_text_insert">
      <querytext>

      insert into survey_question_responses
      (response_id, question_id, clob_answer)
      values 
      (:response_id, :question_id, :clob_answer)

      </querytext>
</fullquery>

</queryset>

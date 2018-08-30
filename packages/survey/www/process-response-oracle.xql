<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="create_response">      
      <querytext>
      
	begin
	    :1 := survey_response.new (
		response_id => :response_id,
		survey_id => :survey_id,		
		context_id => :survey_id,
		creation_user => :user_id,
		initial_response_id => :initial_response_id
	    );
	end;
    
      </querytext>
</fullquery>


<fullquery name="survey_question_response_text_insert">
      <querytext>

      insert into survey_question_responses
      (response_id, question_id, clob_answer)
      values 
      (:response_id, :question_id, empty_clob())
      returning clob_answer into :1

      </querytext>
</fullquery>


<fullquery name="create_item">
      <querytext>

       begin
           :1 := content_item.new (
           name => :name,
           creation_ip => :creation_ip
	   );
       end;

      </querytext>
</fullquery>

</queryset>

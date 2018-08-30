<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="create_question">      
      <querytext>
      
	    begin
		:1 := survey_question.new (
		    question_id => :question_id,
		    section_id => :section_id,
                    sort_order => :sort_order,
                    question_text => empty_clob(),
                    abstract_data_type => :abstract_data_type,
                    presentation_type => :presentation_type,
                    presentation_alignment => :presentation_alignment,
		    presentation_options => :presentation_options,
                    active_p => :active_p,
                    required_p => :required_p,
		    context_id => :section_id,
		    creation_user => :user_id
		);
	    end;
	
      </querytext>
</fullquery>

 
<fullquery name="get_choice_id">      
      <querytext>
      select survey_choice_id_sequence.nextval as choice_id from dual
      </querytext>
</fullquery>

<fullquery name="already_inserted_p">
    <querytext>
	select decode(count(*),0,0,1) from survey_questions where question_id = :question_id
    </querytext>
</fullquery>
</queryset>

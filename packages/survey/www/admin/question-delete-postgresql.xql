<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="survey_delete_question">      
      <querytext>

            select survey_question__remove (:question_id);
	
      </querytext>
</fullquery>

 
</queryset>

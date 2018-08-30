<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="survey_delete_question">
<querytext>
	    begin
        	survey_question.remove (:question_id);
	    end;
</querytext>
</fullquery>

</queryset>
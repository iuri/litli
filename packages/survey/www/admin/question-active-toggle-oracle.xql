<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="survey_question_required_toggle">      
      <querytext>
      update survey_questions set active_p = util.logical_negation(active_p)
where section_id = :section_id
and question_id = :question_id
      </querytext>
</fullquery>

 
</queryset>

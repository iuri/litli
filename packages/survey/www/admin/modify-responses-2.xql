<?xml version="1.0"?>
<queryset>

<fullquery name="update_survey_question_choice">      
      <querytext>
      update survey_question_choices
          set label = :trimmed_response
          where choice_id = :choice_id
      </querytext>
</fullquery>

 
<fullquery name="update_survey_scores">      
      <querytext>
      update survey_choice_scores
                                           set score = :score
                                           where choice_id = :choice_id
                                           and variable_id = :variable_id
      </querytext>
</fullquery>

 
</queryset>

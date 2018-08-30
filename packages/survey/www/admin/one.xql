<?xml version="1.0"?>
<queryset>

<fullquery name="survey_questions">      
      <querytext>
select question_id, sort_order, active_p, required_p, section_id 
     from survey_questions
     where section_id in ( select section_id from survey_sections where survey_id=:survey_id)
     order by section_id, sort_order
      </querytext>
</fullquery>

<fullquery name="survey_sections">
	<querytext>
select section_id from survey_sections
where survey_id=:survey_id
	</querytext>
</fullquery>

</queryset>

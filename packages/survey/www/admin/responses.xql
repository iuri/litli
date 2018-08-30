<?xml version="1.0"?>
<queryset>
 
<fullquery name="survey_question_list">      
      <querytext>
      select question_id, question_text, abstract_data_type, sort_order
from survey_questions
where section_id in (select section_id from survey_sections
                     where survey_id=:survey_id)
order by sort_order
      </querytext>
</fullquery>

 
<fullquery name="survey_boolean_summary">      
      <querytext>
select count(*) as n_responses, boolean_answer
from survey_ques_responses_latest
where question_id = :question_id
group by boolean_answer
order by boolean_answer desc
      </querytext>
</fullquery>

 
<fullquery name="survey_number_summary">      
      <querytext>
      select count(*) as n_responses, number_answer
from survey_ques_responses_latest
where question_id = :question_id
group by number_answer
order by number_answer
      </querytext>
</fullquery>

 
<fullquery name="survey_number_average">      
      <querytext>
      select avg(number_answer) as mean, stddev(number_answer) as standard_deviation
from survey_ques_responses_latest
where question_id = :question_id
      </querytext>
</fullquery>

 
<fullquery name="survey_section_question_choices">      
      <querytext>
      select count(*) as n_responses, label, qc.choice_id
from survey_ques_responses_latest qr, survey_question_choices qc
where qr.choice_id = qc.choice_id
  and qr.question_id = :question_id
group by label, sort_order, qc.choice_id
order by sort_order
      </querytext>
</fullquery>

<fullquery name="survey_attachment_summary">
      <querytext>
	select cr.title, qr.question_id, qr.response_id
	from cr_revisions cr, survey_ques_responses_latest qr, survey_responses sr
	where
	revision_id=attachment_answer
	and qr.question_id=question_id
        and sr.response_id = qr.response_id
        and survey_id = :survey_id
      </querytext>
</fullquery>

<fullquery name="survey_number_responses">      
      <querytext>
      select count(*)
from survey_responses_latest
where survey_id=:survey_id
</querytext>
</fullquery>

 
</queryset>

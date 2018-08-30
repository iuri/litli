<?xml version="1.0"?>
<queryset>

    <fullquery name="get_question_data_types">
	<querytext>
	  select question_id, abstract_data_type, q.sort_order,
	    question_text
	  from survey_questions q, survey_sections s
	  where s.survey_id = :survey_id
	    and s.section_id=q.section_id
	  order by q.sort_order,q.question_id
	</querytext>
    </fullquery>


    <fullquery name="get_n_responses">
	<querytext>
	    select count(*) from survey_responses_latest
	    where survey_id=:survey_id
	</querytext>
    </fullquery>

    <fullquery name="get_filename">
	<querytext>
	    select title from cr_revisions where
	    revision_id=:attachment_answer
	</querytext>
    </fullquery>

</queryset>

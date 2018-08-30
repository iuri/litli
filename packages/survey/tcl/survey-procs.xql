<?xml version="1.0"?>
<queryset>

<fullquery name="get_survey_info.n_eligible">
<querytext>
    select count(*) from dotlrn_member_rels_full
    where rel_type='dotlrn_member_rel'
    and community_id=:community_id
</querytext>
</fullquery>


<fullquery name="get_survey_info.lookup_single_section_id">
<querytext>
	select min(section_id) as section_id
          from survey_sections
	 where survey_id = :survey_id
</querytext>
</fullquery>

<fullquery name="get_survey_info.lookup_survey_id">      
<querytext>
	select survey_id
	  from survey_sections
	 where section_id = :section_id	
</querytext>
</fullquery>

<fullquery name="get_survey_info.get_info_by_survey_id">      
<querytext>
	select s.*,
	       o.creation_user, o.creation_date, p.first_names || ' ' || p.last_name as creator_name, 
	       (case when enabled_p = 't' then '#survey.enable#' else '#survey.disable#' end) as enabled_display,
	       (case when single_response_p = 't' then '#survey.One_Response#' else '#survey.multiple_responses#' end) as single_response_display,
	       (case when editable_p = 'f' then '#survey.non-editable#' else '#survey.editable#' end) as editable_display, 
	       (case when single_section_p = 'f' then '#survey.multiple_sections#' else '#survey.single_section#' end) as single_section_display
	  from surveys s, acs_objects o, persons p
	 where o.object_id = :survey_id	
	   and s.survey_id = o.object_id
	   and p.person_id = o.creation_user
</querytext>
</fullquery>


<fullquery name="survey_question_display.prev_response_query">
<querytext>
select	
  choice_id,
  boolean_answer,
  clob_answer,
  number_answer,
  varchar_answer,
  date_answer,
  attachment_answer
  from survey_question_responses
  where question_id = :question_id
       and response_id = :response_id
</querytext>
</fullquery>


<fullquery name="survey_question_display.prev_response_query">
<querytext>
select	
  choice_id,
  boolean_answer,
  clob_answer,
  number_answer,
  varchar_answer,
  date_answer,
  attachment_answer
  from survey_question_responses
  where question_id = :question_id
       and response_id = :response_id
</querytext>
</fullquery>


<fullquery name="survey_question_display.survey_question_properties">      
      <querytext>
      
select
  section_id,
  sort_order,
  question_text,
  abstract_data_type,
  required_p,
  active_p,
  presentation_type,
  presentation_options,
  presentation_alignment,
  creation_user,
  creation_date
from
  survey_questions, acs_objects
where
  object_id = question_id
  and question_id = :question_id
      </querytext>
</fullquery>

<fullquery name="survey_question_display.question_choices">      
      <querytext>
      select choice_id, label
from survey_question_choices
where question_id = :question_id
order by sort_order
      </querytext>
</fullquery>

 
<fullquery name="survey_question_display.question_choices_2">      
      <querytext>
      select choice_id, label
from survey_question_choices
where question_id = :question_id
order by sort_order
      </querytext>
</fullquery>

 
<fullquery name="survey_question_display.question_choices_3">      
      <querytext>
      select * from survey_question_choices
where question_id = :question_id
order by sort_order
      </querytext>
</fullquery>


 
<fullquery name="survey_answer_summary_display.survey_label_list">      
      <querytext>
      select label
	    from survey_question_choices, survey_question_responses
	    where survey_question_responses.question_id = :question_id
	    and survey_question_responses.response_id = :response_id
	    and survey_question_choices.choice_id = survey_question_responses.choice_id
      </querytext>
</fullquery>

 
 

<fullquery name="survey_question_copy.get_question_details">
<querytext>
select * from survey_questions
where question_id=:question_id
</querytext>
</fullquery>

<fullquery name="survey_question_copy.insert_question_text">
<querytext>
	    update survey_questions
	    set question_text = :question_text
	    where question_id = :new_question_id
</querytext>
</fullquery>

<fullquery name="survey_question_copy.renumber_sort_orders">
<querytext>
update survey_questions
   set sort_order = sort_order + 1
   where section_id = :section_id
   and sort_order > :after
</querytext>
</fullquery>

<fullquery name="survey_question_copy.get_survey_question_choices">
<querytext>
	select * from survey_question_choices
	where question_id=:old_question_id
</querytext>
</fullquery>

<fullquery name="survey_question_copy.insert_survey_question_choice">
<querytext>
insert into survey_question_choices
                (choice_id, question_id, label, numeric_value, sort_order)
                values
                (:new_choice_id, :new_question_id, :label,
		 :numeric_value, :sort_order)
</querytext>
</fullquery>

<fullquery name="survey_do_notifications.get_survey_id_from_response">
<querytext>
	select survey_id from survey_responses
	where response_id=:response_id
</querytext>
</fullquery>

<fullquery name="survey_do_notifications.n_responses">
    <querytext>
	select count(*) from survey_responses_latest
	where survey_id=:survey_id
    </querytext>
</fullquery>

<fullquery name="survey_do_notifications.n_members">
    <querytext>
	select count(*) from party_approved_member_map
	where party_id=:segment_id
    </querytext>
</fullquery>

<fullquery name="survey_do_notifications.get_questions">
    <querytext>
	select sort_order, question_text, question_id
	from survey_questions
	where section_id in 
	(select section_id
	 from survey_sections
	 where survey_id=:survey_id)
    </querytext>
</fullquery>

<fullquery name="survey_copy.get_survey_info">
<querytext>
	select
	    survey_id,
	    name,
  	    description,
	    description_html_p,
	    'f' as enabled_p,
	    single_response_p,
	    editable_p,
	    single_section_p,
	    type,
	    display_type 
	from surveys where survey_id=:survey_id
</querytext>
</fullquery>

<fullquery name="survey_copy.set_section_description">
<querytext>
	update survey_sections set description=:description
	where section_id=:new_section_id
</querytext>
</fullquery>

<fullquery name="survey_copy.get_sections">
    <querytext>
	select section_id from survey_sections where survey_id=:survey_id
    </querytext>
</fullquery>

<fullquery name="survey_copy.get_questions">
<querytext>
select question_id from survey_questions
	where section_id in (select section_id from survey_sections
		where survey_id=:survey_id)
</querytext>
</fullquery>

<fullquery name="survey_answer_summary_display.summary">      
      <querytext>

select
  sq.question_id,
  sq.section_id,
  sq.sort_order,
  sq.question_text,
  sq.abstract_data_type,
  sq.required_p,
  sq.active_p,
  sq.presentation_type,
  sq.presentation_options,
  sq.presentation_alignment,
  sqr.response_id,
  sqr.question_id,
  sqr.choice_id,
  sqr.boolean_answer,
  sqr.clob_answer,
  sqr.number_answer,
  sqr.varchar_answer,
  sqr.date_answer,
  sqr.attachment_answer
from
  survey_questions sq,
  survey_question_responses sqr
where
  sqr.response_id = :response_id
  and sq.question_id = sqr.question_id
  and sq.active_p = 't'
order by sort_order

      </querytext>
</fullquery>

<fullquery name="survey_decode_boolean_answer.get_presentation_options">
    <querytext>
	select presentation_options 
	from survey_questions
	where question_id=:question_id
    </querytext>
</fullquery>

<fullquery name="survey_answer_summary_display.get_filename">
    <querytext>
	select title from cr_revisions where
	revision_id=:attachment_answer
    </querytext>
</fullquery>

</queryset>

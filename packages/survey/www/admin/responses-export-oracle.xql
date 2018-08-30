<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

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

<fullquery name="get_all_survey_question_responses">
<querytext>
select
    sq.response_id,
    sq.question_id,
    sq.email,
    sq.first_names,
    sq.last_name,
    sq.user_id,
    to_char(sq.creation_date,'YYYY-MM-DD HH24:MI:SS') as creation_date_ansi,
    resp.boolean_answer,
    resp.number_answer,
    resp.date_answer,
    resp.varchar_answer,
    resp.clob_answer,
    resp.attachment_answer,
    resp.label
  from 
  (select
    sqr.response_id,
    sqr.question_id,
    sqr.boolean_answer,
    sqr.number_answer,
    sqr.date_answer,
    sqr.varchar_answer,
    sqr.clob_answer,
    sqr.attachment_answer,
    sqc.label,
    sqc.sort_order
  from
    survey_responses sr,
    survey_question_responses sqr,
    survey_question_choices sqc
  where
    sr.survey_id=:survey_id
    and sr.response_id = sqr.response_id
    and sqr.question_id = sqc.question_id (+)
    and sqr.choice_id = sqc.choice_id (+)) resp,
  (select r.response_id,
          q.question_id,
          u.email,
          u.first_names,
          u.last_name,
          r.user_id,
          r.creation_date,
          q.abstract_data_type,
          q.sort_order
     from survey_questions q, (select initial_user_id as user_id, creation_date, response_id from survey_responses_latest rt where survey_id=:survey_id) r, (select p.email, u.first_names, u.last_name, u.person_id as user_id from parties
p, persons u where p.party_id=u.person_id) u, survey_sections ss
     where ss.survey_id=:survey_id
     and q.section_id=ss.section_id
     and r.user_id = u.user_id) sq
  where sq.response_id = resp.response_id (+)
   and sq.question_id = resp.question_id (+)
  order by
    sq.response_id,
    sq.sort_order,
    sq.question_id,
    resp.sort_order
</querytext>
</fullquery>
</queryset>

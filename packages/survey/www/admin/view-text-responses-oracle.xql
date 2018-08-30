<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="all_responses_to_question">      
    <querytext>

      select
          $column_name as response, initial_user_id,
          person.name(initial_user_id) as respondent_name,
          o.creation_date as submission_date,
          initial_user_id as creation_user,
          o.creation_ip as ip_address
        from
          survey_responses_latest r,
          survey_question_responses qr,
          acs_objects o
        where
          qr.response_id = r.response_id
          and qr.question_id = :question_id
          and o.object_id = r.response_id
        order by submission_date

      </querytext>
</fullquery>

 
</queryset>

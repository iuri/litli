<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="survey_select">
	<querytext>

select s.survey_id, s.name, s.editable_p, s.single_response_p,
       sr.response_id, to_char(sr.creation_date, 'Month FMDD, YYYY') as creation_date
  from surveys s left outer join 
       (select survey_id, response_id, creation_date
          from survey_responses_latest
	 where initial_user_id = :user_id) sr
    on (s.survey_id = sr.survey_id)
 where s.package_id=:package_id
   and s.enabled_p='t'
 order by upper(s.name)

    	</querytext>
</fullquery>

</queryset>
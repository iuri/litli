<?xml version="1.0"?>

<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_survey_details">
	<querytext>

select s.survey_id, s.name, s.editable_p, s.single_response_p,
       sr.response_id, sr.creation_date
  from surveys s ,(select survey_id, response_id, creation_date
          from survey_responses_latest
	 where initial_user_id = :user_id) sr
 where s.survey_id=:survey_id
and s.package_id=:package_id
and s.survey_id = sr.survey_id(+)
and s.enabled_p='t'
order by sr.creation_date desc

    	</querytext>
</fullquery>

</queryset>
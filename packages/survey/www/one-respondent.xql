<?xml version="1.0"?>
<queryset>

<fullquery name="survey_exists">      
      <querytext>
      
		select 1 from surveys where survey_id = :survey_id
	    
      </querytext>
</fullquery>
 
<fullquery name="responses_select">      
      <querytext>

    select response_id, creation_date, 
           to_char(creation_date, 'YYYY-MM-DD') as pretty_submission_date_ansi
    from survey_responses_latest
    where survey_id=:survey_id
    and initial_user_id = :user_id
    order by creation_date desc

      </querytext>
</fullquery>

</queryset>

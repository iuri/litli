<?xml version="1.0"?>
<queryset>

    <fullquery name="select_respondents">      
        <querytext>

            select persons.first_names, persons.last_name,
                   initial_user_id as user_id,
                   parties.email
            from survey_responses_latest s,
                 persons,
                 parties,
                 acs_objects
            where s.survey_id=:survey_id
            and s.response_id = acs_objects.object_id
            and initial_user_id = persons.person_id
            and persons.person_id = parties.party_id
            group by initial_user_id,
                     parties.email,
                     persons.first_names,
                     persons.last_name
            [template::list::orderby_clause -orderby -name respondents]

        </querytext>
    </fullquery>

</queryset>

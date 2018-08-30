<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="survey_question_copy.create_question">      
      <querytext>
	SELECT survey_question__new (
		    NULL,
		    :section_id,
                    :new_sort_order,
                    :question_text,
                    :abstract_data_type,
		    :required_p,
                    :active_p,
		    :presentation_type,
		    :presentation_options,
	            :presentation_alignment,
		    :user_id,
		    :section_id
		);
      </querytext>
</fullquery>

<fullquery name="survey_question_copy.get_choice_id">
<querytext>
select survey_choice_id_sequence.nextval as choice_id
</querytext>
</fullquery>

<fullquery name="get_survey_info.n_completed">
<querytext>
    		    select count(distinct survey_response__initial_user_id(response_id))
                    from 
		    survey_responses
		    where survey_id=:survey_id
</querytext>
</fullquery>


<fullquery name="survey_do_notifications.get_response_info">
    <querytext>
	select r.initial_response_id, r.responding_user_id, r.response_id,
	    u.first_names || ' ' || u.last_name as user_name,
	    edit_p,
	    o.creation_date as response_date
	    from (select survey_response__initial_user_id(response_id) as responding_user_id,
		  survey_response__initial_response_id(response_id) as initial_response_id,
		  response_id, (case when initial_response_id is NULL then 'f' else 't' end) as edit_p
	    from survey_responses) r, acs_objects o,
	    cc_users u where r.response_id=:response_id
	    and r.responding_user_id = u.user_id
	    and r.response_id = o.object_id
    </querytext>
</fullquery>

<fullquery name="get_survey_info.n_completed">
<querytext>
    		    select count(distinct survey_response__initial_user_id(response_id))
                    from 
		    survey_responses
		    where survey_id=:survey_id
</querytext>
</fullquery>

<fullquery name="survey_copy.survey_create">
<querytext>
        select survey__new (
                    NULL,
                    :name,
                    :description,
                    :description_html_p,
		    :single_response_p,
                    :editable_p,
                    :enabled_p,
                    :single_section_p,
		    :type,
                    :display_type,
                    :package_id,
	            :user_id,
		    :package_id
                );
</querytext>
</fullquery>

<fullquery name="survey_copy.section_create">
<querytext>
	    select survey_section__new (
	              NULL,
		      :new_survey_id,
		      :name,
		      :description,
		      :description_html_p,
		      :user_id,
	              :package_id
		      );
</querytext>
</fullquery>

</queryset>

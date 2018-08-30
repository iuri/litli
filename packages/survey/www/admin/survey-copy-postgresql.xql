<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="survey_create">
<querytext>
        :1 := survey__new (
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
		    :package_id,
                );
</querytext>
</fullquery>

<fullquery name="section_create">
<querytext>
	    :1 := survey_section__new (
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
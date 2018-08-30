<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="create_survey">
      <querytext>
	        select survey__new (
                    :survey_id,
                    :name,
                    :description,
                    :description_html_p,
		    'f',
		    't',
		    'f',
	            't',
                    :type,
                    :display_type,
                    :package_id,
		    :user_id,
                    :package_id
                )
      </querytext>
</fullquery>

<fullquery name="create_section">
      <querytext>
	    select survey_section__new (
	              :section_id,
		      :survey_id,
		      :name,
		      :description,
		      :description_html_p,
	              :user_id,
	              :package_id
            )
      </querytext>
</fullquery>
 
<fullquery name="add_logic">
      <querytext>
      insert into survey_logic
      (logic_id, logic)
      values
      (:logic_id, :logic)
      </querytext>
</fullquery>

</queryset>

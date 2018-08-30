<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="create_survey">
      <querytext>
	    begin
	        :1 := survey.new (
                    survey_id => :survey_id,
                    name => :name,
                    description => :description,
                    description_html_p => :description_html_p,
                    type => :type,
                    display_type => :display_type,
                    package_id => :package_id,
                    context_id => :package_id,
		    creation_user => :user_id,
		    enabled_p => :enabled_p
                );
            end;
      </querytext>
</fullquery>

<fullquery name="create_section">
      <querytext>
	    begin
	    :1 := survey_section.new (
	              section_id=>:section_id,
		      survey_id=>:survey_id,
		      name=>:name,
		      description=>empty_clob(),
		      description_html_p=>:description_html_p,
		      context_id=>:survey_id
		      );
	    end;
      </querytext>
</fullquery>

<fullquery name="add_logic">
      <querytext>
      insert into survey_logic
      (logic_id, logic)
      values
      (:logic_id, empty_clob()) returning logic into :1
      </querytext>
</fullquery>

</queryset>

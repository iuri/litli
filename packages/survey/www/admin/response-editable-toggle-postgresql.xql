<?xml version="1.0"?>
<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="survey_response_editable_toggle">      
      <querytext>
      update surveys set editable_p = util__logical_negation(editable_p)
where survey_id = :survey_id
      </querytext>
</fullquery>

 
</queryset>

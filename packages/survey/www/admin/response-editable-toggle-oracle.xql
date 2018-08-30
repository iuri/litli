<?xml version="1.0"?>
<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="survey_response_editable_toggle">      
      <querytext>
      update surveys set editable_p = util.logical_negation(editable_p)
where survey_id = :survey_id
      </querytext>
</fullquery>

 
</queryset>

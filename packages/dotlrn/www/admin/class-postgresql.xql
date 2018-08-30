<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_terms_for_select_widget">
        <querytext>
    select dotlrn_terms.term_name || ' ' || dotlrn_terms.term_year,
           dotlrn_terms.term_id
    from dotlrn_terms
    where dotlrn_terms.end_date > (cast(current_timestamp as date) - 360)
      and dotlrn_terms.start_date < (cast(current_timestamp as date) + 360)
    order by dotlrn_terms.start_date,
             dotlrn_terms.end_date
        </querytext>
    </fullquery>

</queryset>

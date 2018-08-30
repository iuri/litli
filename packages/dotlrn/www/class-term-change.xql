<?xml version="1.0"?>

<queryset>

    <fullquery name="select_terms_for_select_widget">
        <querytext>
            select dotlrn_terms.term_name || ' ' || dotlrn_terms.term_year as term,
                   dotlrn_terms.term_id
            from dotlrn_terms
            order by dotlrn_terms.start_date
        </querytext>
    </fullquery>

</queryset>

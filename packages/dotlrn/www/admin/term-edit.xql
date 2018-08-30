<?xml version="1.0"?>

<queryset>

    <fullquery name="select_term_info">
        <querytext>
            select term_name,
                   term_year,
                   to_char(start_date, 'YYYY-MM-DD') as start_date,
                   to_char(end_date, 'YYYY-MM-DD') as end_date
            from dotlrn_terms
            where term_id = :term_id
        </querytext>
    </fullquery>

</queryset>

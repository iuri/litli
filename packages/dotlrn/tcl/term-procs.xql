<?xml version="1.0"?>

<queryset>

    <fullquery name="dotlrn_term::get_term_name.get_term_name">
        <querytext>
            select dotlrn_terms.term_name
            from dotlrn_terms
            where dotlrn_terms.term_id = :term_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_term::get_term_year.get_term_year">
        <querytext>
            select dotlrn_terms.term_year
            from dotlrn_terms
            where dotlrn_terms.term_id = :term_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_term::get_term_info.get_term_info">
        <querytext>
            select dotlrn_terms.term_name,
                   dotlrn_terms.term_year
            from dotlrn_terms
            where dotlrn_terms.term_id = :term_id
        </querytext>
    </fullquery>

</queryset>

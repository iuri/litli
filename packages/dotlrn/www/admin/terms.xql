<?xml version="1.0"?>

<queryset>

    <fullquery name="select_terms">
        <querytext>
            select dotlrn_terms.term_id,
                   dotlrn_terms.term_name,
                   dotlrn_terms.term_year,
                   to_char(dotlrn_terms.start_date, 'YYYY-MM-DD') as start_date_ansi,
                   to_char(dotlrn_terms.start_date, 'YYYY-MM-DD') as start_date_pretty,
                   to_char(dotlrn_terms.end_date, 'YYYY-MM-DD') as end_date_ansi,
                   (select count(*)
                    from dotlrn_class_instances
                    where dotlrn_class_instances.term_id = dotlrn_terms.term_id) as n_classes
            from dotlrn_terms
	     where 1 = 1
	    [template::list::page_where_clause -and -name "terms" -key "dotlrn_terms.term_id"]
	    [template::list::orderby_clause -orderby -name "terms"]
        </querytext>
    </fullquery>


    <fullquery name="terms_pagination">
        <querytext>
            select dotlrn_terms.term_id,
                   dotlrn_terms.term_name,
                  to_char(dotlrn_terms.start_date, 'YYYY-MM-DD') as start_date_ansi,
                   to_char(dotlrn_terms.end_date, 'YYYY-MM-DD') as end_date_ansi,
                   (select count(*)
                    from dotlrn_class_instances
                    where dotlrn_class_instances.term_id = dotlrn_terms.term_id) as n_classes
            from dotlrn_terms
            [template::list::orderby_clause -orderby -name "terms"]
 
        </querytext>
    </fullquery>

</queryset>

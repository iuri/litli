<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="dotlrn_term::new.insert_term">
        <querytext>
            insert
            into dotlrn_terms
            (term_id, term_name, term_year, start_date, end_date)
            values
            (:term_id, :term_name, :term_year, to_date(:start_date, :date_format), to_date(:end_date, :date_format))
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_term::edit.update_term">
        <querytext>
            update dotlrn_terms
            set term_name = :term_name,
                term_year = :term_year,
                start_date = to_date(:start_date, :date_format),
                end_date = to_date(:end_date, :date_format)
            where term_id = :term_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_term::get_start_date.get_start_date">
        <querytext>
            select to_char(dotlrn_terms.start_date, :date_format) as start_date,
                   to_char(dotlrn_terms.start_date, 'YYYY') as year,
                   to_char(dotlrn_terms.start_date, 'MM') as month,
                   to_char(dotlrn_terms.start_date, 'DD') as day
            from dotlrn_terms
            where dotlrn_terms.term_id = :term_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_term::get_end_date.get_end_date">
        <querytext>
            select to_char(dotlrn_terms.end_date, :date_format) as end_date,
                   to_char(dotlrn_terms.end_date, 'YYYY') as year,
                   to_char(dotlrn_terms.end_date, 'MM') as month,
                   to_char(dotlrn_terms.end_date, 'DD') as day
            from dotlrn_terms
            where dotlrn_terms.term_id = :term_id
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_term::get_future_terms_as_options.get_future_terms_select">
        <querytext>
          select dotlrn_terms.term_name || ' ' || dotlrn_terms.term_year as term,
                 dotlrn_terms.term_id
          from dotlrn_terms
          where dotlrn_terms.end_date > current_timestamp
          order by dotlrn_terms.start_date
        </querytext>
    </fullquery>

</queryset>

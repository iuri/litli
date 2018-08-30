<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="dotlrn_class::can_instantiate.can_instantiate">
        <querytext>
            select count(*)
            from dual
            where exists (select 1
                          from dotlrn_terms
                          where dotlrn_terms.end_date > now())
        </querytext>
    </fullquery>

</queryset>

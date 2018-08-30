<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="dotlrn_class::can_instantiate.can_instantiate">
        <querytext>
            select count(*)
            from dual
            where exists (select 1
                          from dotlrn_terms
                          where dotlrn_terms.end_date > sysdate)
        </querytext>
    </fullquery>

</queryset>

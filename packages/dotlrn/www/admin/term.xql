<?xml version="1.0"?>

<queryset>

    <fullquery name="select_term_info">
        <querytext>
            select term_name,
                   term_year,
                   to_char(start_date, 'Mon DD YYYY') as start_date,
                   to_char(end_date, 'Mon DD YYYY') as end_date
            from dotlrn_terms
            where term_id = :term_id
        </querytext>
    </fullquery>

    <partialquery name="select_all_instances_keyword">
      <querytext>
	  where lower(dotlrn_class_instances_full.pretty_name) like '%'||lower(:keyword)||'%'
      </querytext>
    </partialquery>

    <partialquery name="select_all_instances_without_keyword">
      <querytext>
	  where 1 = 1
      </querytext>
    </partialquery>
</queryset>

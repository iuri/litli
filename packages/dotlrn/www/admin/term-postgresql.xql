<?xml version="1.0"?>

<queryset>
  <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_classes">
        <querytext>
            select dotlrn_class_instances_full.*, v.n_members
            from dotlrn_class_instances_full left outer join
                 (select dotlrn_class_instances_full.class_instance_id, count(1) as n_members
                 from dotlrn_class_instances_full, dotlrn_member_rels_approved
                 where dotlrn_member_rels_approved.community_id = dotlrn_class_instances_full.class_instance_id
                 group by dotlrn_class_instances_full.class_instance_id) v
                 on dotlrn_class_instances_full.class_instance_id = v.class_instance_id
	    $keyword_clause
            and dotlrn_class_instances_full.term_id = :term_id
	    [template::list::page_where_clause -and -name "classes" -key "dotlrn_class_instances_full.class_instance_id"]
	    [template::list::orderby_clause -orderby -name "classes"]
        </querytext>
    </fullquery>

    <fullquery name="select_classes_paginator">
        <querytext>
            select dotlrn_class_instances_full.*, v.n_members
            from dotlrn_class_instances_full left outer join
                 (select dotlrn_class_instances_full.class_instance_id, count(1) as n_members
                 from dotlrn_class_instances_full, dotlrn_member_rels_approved
                 where dotlrn_member_rels_approved.community_id = dotlrn_class_instances_full.class_instance_id
                 group by dotlrn_class_instances_full.class_instance_id) v
                 on dotlrn_class_instances_full.class_instance_id = v.class_instance_id
	    $keyword_clause
            and dotlrn_class_instances_full.term_id = :term_id
            [template::list::orderby_clause -orderby -name "classes"]
        </querytext>
    </fullquery>

    <fullquery name="select_classes_by_department">
        <querytext>
            select dotlrn_class_instances_full.*, v.n_members
            from dotlrn_class_instances_full left outer join
                 (select dotlrn_class_instances_full.class_instance_id, count(1) as n_members
                 from dotlrn_class_instances_full, dotlrn_member_rels_approved
                 where dotlrn_member_rels_approved.community_id = dotlrn_class_instances_full.class_instance_id
                 group by dotlrn_class_instances_full.class_instance_id) v
                 on dotlrn_class_instances_full.class_instance_id = v.class_instance_id
	    $keyword_clause
            and dotlrn_class_instances_full.term_id = :term_id
            and dotlrn_class_instances_full.department_key = :department_key
	    [template::list::page_where_clause -and -name "classes" -key "dotlrn_class_instances_full.class_instance_id"]
	    [template::list::orderby_clause -orderby -name "classes"]
        </querytext>
    </fullquery>

    <fullquery name="select_classes_paginator_by_department">
        <querytext>
            select dotlrn_class_instances_full.*, v.n_members
            from dotlrn_class_instances_full left outer join
                 (select dotlrn_class_instances_full.class_instance_id, count(1) as n_members
                 from dotlrn_class_instances_full, dotlrn_member_rels_approved
                 where dotlrn_member_rels_approved.community_id = dotlrn_class_instances_full.class_instance_id
                 group by dotlrn_class_instances_full.class_instance_id) v
                 on dotlrn_class_instances_full.class_instance_id = v.class_instance_id
	    $keyword_clause
            and dotlrn_class_instances_full.term_id = :term_id
            and dotlrn_class_instances_full.department_key = :department_key
            [template::list::orderby_clause -orderby -name "classes"]
        </querytext>
    </fullquery>

    <fullquery name="select_all_classes">
        <querytext>
            select dotlrn_class_instances_full.*, v.n_members
            from dotlrn_class_instances_full left outer join
                 (select dotlrn_class_instances_full.class_instance_id, count(1) as n_members
                 from dotlrn_class_instances_full, dotlrn_member_rels_approved
                 where dotlrn_member_rels_approved.community_id = dotlrn_class_instances_full.class_instance_id
                 group by dotlrn_class_instances_full.class_instance_id) v
                 on dotlrn_class_instances_full.class_instance_id = v.class_instance_id
	    $keyword_clause
	    [template::list::page_where_clause -and -name "classes" -key "dotlrn_class_instances_full.class_instance_id"]
	    [template::list::orderby_clause -orderby -name "classes"]
        </querytext>
    </fullquery>

    <fullquery name="select_all_classes_paginator">
        <querytext>
            select dotlrn_class_instances_full.*, v.n_members
            from dotlrn_class_instances_full left outer join
                 (select dotlrn_class_instances_full.class_instance_id, count(1) as n_members
                 from dotlrn_class_instances_full, dotlrn_member_rels_approved
                 where dotlrn_member_rels_approved.community_id = dotlrn_class_instances_full.class_instance_id
                 group by dotlrn_class_instances_full.class_instance_id) v
                 on dotlrn_class_instances_full.class_instance_id = v.class_instance_id
       	    $keyword_clause
            [template::list::orderby_clause -orderby -name "classes"]
        </querytext>
    </fullquery>

    <fullquery name="select_all_classes_by_department">
        <querytext>
            select dotlrn_class_instances_full.*, v.n_members
            from dotlrn_class_instances_full left outer join
                 (select dotlrn_class_instances_full.class_instance_id, count(1) as n_members
                 from dotlrn_class_instances_full, dotlrn_member_rels_approved
                 where dotlrn_member_rels_approved.community_id = dotlrn_class_instances_full.class_instance_id
                 group by dotlrn_class_instances_full.class_instance_id) v
                 on dotlrn_class_instances_full.class_instance_id = v.class_instance_id
	    $keyword_clause
            and dotlrn_class_instances_full.department_key = :department_key
	    [template::list::page_where_clause -and -name "classes" -key "dotlrn_class_instances_full.class_instance_id"]
	    [template::list::orderby_clause -orderby -name "classes"]
        </querytext>
    </fullquery>

    <fullquery name="select_all_classes_paginator_by_department">
        <querytext>
            select dotlrn_class_instances_full.*, v.n_members
            from dotlrn_class_instances_full left outer join
                 (select dotlrn_class_instances_full.class_instance_id, count(1) as n_members
                 from dotlrn_class_instances_full, dotlrn_member_rels_approved
                 where dotlrn_member_rels_approved.community_id = dotlrn_class_instances_full.class_instance_id
                 group by dotlrn_class_instances_full.class_instance_id) v
                 on dotlrn_class_instances_full.class_instance_id = v.class_instance_id
	    $keyword_clause
            and dotlrn_class_instances_full.department_key = :department_key
            [template::list::orderby_clause -orderby -name "classes"]
        </querytext>
    </fullquery>

</queryset>

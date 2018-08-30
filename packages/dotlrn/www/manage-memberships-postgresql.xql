<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_n_member_classes">
        <querytext>
            select count(*)
            from dotlrn_class_instances_full,
                 dotlrn_member_rels_full
            where dotlrn_member_rels_full.user_id = :user_id
            and dotlrn_member_rels_full.community_id = dotlrn_class_instances_full.class_instance_id
        </querytext>
    </fullquery>

    <fullquery name="select_member_classes">
        <querytext>
            select dotlrn_class_instances_full.*,
                   dotlrn_member_rels_full.role,
                   dotlrn_member_rels_full.rel_type,
                   dotlrn_member_rels_full.member_state
            from dotlrn_class_instances_full,
                 dotlrn_member_rels_full
            where dotlrn_member_rels_full.user_id = :user_id
            and dotlrn_member_rels_full.community_id = dotlrn_class_instances_full.class_instance_id
            order by dotlrn_class_instances_full.active_start_date,
		     dotlrn_class_instances_full.pretty_name,
                     dotlrn_class_instances_full.community_key
        </querytext>
    </fullquery>

    <fullquery name="select_member_classes_by_department">
        <querytext>
            select dotlrn_class_instances_full.*,
                   dotlrn_member_rels_full.role,
                   dotlrn_member_rels_full.rel_type,
                   dotlrn_member_rels_full.member_state
            from dotlrn_class_instances_full,
                 dotlrn_member_rels_full
            where dotlrn_member_rels_full.user_id = :user_id
            and dotlrn_class_instances_full.department_key = :member_department_key
            and dotlrn_member_rels_full.community_id = dotlrn_class_instances_full.class_instance_id
            order by dotlrn_class_instances_full.pretty_name,
                     dotlrn_class_instances_full.community_key
        </querytext>
    </fullquery>

    <fullquery name="select_member_classes_by_term">
        <querytext>
            select dotlrn_class_instances_full.*,
                   dotlrn_member_rels_full.role,
                   dotlrn_member_rels_full.rel_type,
                   dotlrn_member_rels_full.member_state
            from dotlrn_class_instances_full,
                 dotlrn_member_rels_full
            where dotlrn_member_rels_full.user_id = :user_id
            and dotlrn_class_instances_full.term_id = :member_term_id
            and dotlrn_member_rels_full.community_id = dotlrn_class_instances_full.class_instance_id
            order by dotlrn_class_instances_full.pretty_name,
                     dotlrn_class_instances_full.community_key
        </querytext>
    </fullquery>

    <fullquery name="select_member_classes_by_department_by_term">
        <querytext>
            select dotlrn_class_instances_full.*,
                   dotlrn_member_rels_full.role,
                   dotlrn_member_rels_full.rel_type,
                   dotlrn_member_rels_full.member_state
            from dotlrn_class_instances_full,
                 dotlrn_member_rels_full
            where dotlrn_member_rels_full.user_id = :user_id
            and dotlrn_class_instances_full.department_key = :member_department_key
            and dotlrn_class_instances_full.term_id = :member_term_id
            and dotlrn_member_rels_full.community_id = dotlrn_class_instances_full.class_instance_id
            order by dotlrn_class_instances_full.pretty_name,
                     dotlrn_class_instances_full.community_key
        </querytext>
    </fullquery>

    <fullquery name="select_member_clubs">
        <querytext>
            select dotlrn_clubs_full.*,
                   dotlrn_member_rels_full.role,
                   dotlrn_member_rels_full.rel_type,
                   dotlrn_member_rels_full.member_state
            from dotlrn_clubs_full,
                 dotlrn_member_rels_full
            where dotlrn_member_rels_full.user_id = :user_id
            and dotlrn_member_rels_full.community_id = dotlrn_clubs_full.club_id
            order by dotlrn_clubs_full.pretty_name,
                     dotlrn_clubs_full.community_key
        </querytext>
    </fullquery>

    <fullquery name="select_n_non_member_classes">
        <querytext>
            select count(*)
            from dotlrn_class_instances_full
            where dotlrn_class_instances_full.join_policy <> 'closed'
            and not exists (select 1
                            from dotlrn_member_rels_full
                            where dotlrn_member_rels_full.user_id = :user_id
                            and dotlrn_member_rels_full.community_id = dotlrn_class_instances_full.class_instance_id)
        </querytext>
    </fullquery>

    <fullquery name="select_non_member_classes">
        <querytext>
            select dotlrn_class_instances_full.*
            from dotlrn_class_instances_full
            where dotlrn_class_instances_full.join_policy <> 'closed'
	    and (active_end_date > (select sysdate from dual) or active_end_date is null)
            and not exists (select 1
                            from dotlrn_member_rels_full
                            where dotlrn_member_rels_full.user_id = :user_id
                            and dotlrn_member_rels_full.community_id = dotlrn_class_instances_full.class_instance_id)
            order by dotlrn_class_instances_full.active_start_date,
		     dotlrn_class_instances_full.pretty_name,
                     dotlrn_class_instances_full.community_key

        </querytext>
    </fullquery>

    <fullquery name="select_non_member_classes_by_department">
        <querytext>
            select dotlrn_class_instances_full.*
            from dotlrn_class_instances_full
            where dotlrn_class_instances_full.department_key = :non_member_department_key
            and dotlrn_class_instances_full.join_policy <> 'closed'
	    and active_end_date > (select sysdate from dual)
            and not exists (select 1
                            from dotlrn_member_rels_full
                            where dotlrn_member_rels_full.user_id = :user_id
                            and dotlrn_member_rels_full.community_id = dotlrn_class_instances_full.class_instance_id)
            order by dotlrn_class_instances_full.active_start_date,
            	     dotlrn_class_instances_full.pretty_name,
                     dotlrn_class_instances_full.community_key
        </querytext>
    </fullquery>

    <fullquery name="select_non_member_classes_by_term">
        <querytext>
            select dotlrn_class_instances_full.*
            from dotlrn_class_instances_full
            where dotlrn_class_instances_full.term_id = :non_member_term_id
            and dotlrn_class_instances_full.join_policy <> 'closed'
            and not exists (select 1
                            from dotlrn_member_rels_full
                            where dotlrn_member_rels_full.user_id = :user_id
                            and dotlrn_member_rels_full.community_id = dotlrn_class_instances_full.class_instance_id)
            order by dotlrn_class_instances_full.pretty_name,
                     dotlrn_class_instances_full.community_key
        </querytext>
    </fullquery>

    <fullquery name="select_non_member_classes_by_department_by_term">
        <querytext>
            select dotlrn_class_instances_full.*
            from dotlrn_class_instances_full
            where dotlrn_class_instances_full.department_key = :non_member_department_key
            and dotlrn_class_instances_full.term_id = :non_member_term_id
            and dotlrn_class_instances_full.join_policy <> 'closed'
            and not exists (select 1
                            from dotlrn_member_rels_full
                            where dotlrn_member_rels_full.user_id = :user_id
                            and dotlrn_member_rels_full.community_id = dotlrn_class_instances_full.class_instance_id)
            order by dotlrn_class_instances_full.pretty_name,
                     dotlrn_class_instances_full.community_key
        </querytext>
    </fullquery>

    <fullquery name="select_non_member_clubs">
        <querytext>
          select dotlrn_clubs_full.*
            from dotlrn_clubs_full,
                (select f.club_id
                from dotlrn_clubs_full f
                where f.join_policy <> 'closed'
                  and f.club_id not in (select dotlrn_member_rels_full.community_id as club_id
                                          from dotlrn_member_rels_full
                                         where dotlrn_member_rels_full.user_id = :user_id)) non_member_clubs
            where dotlrn_clubs_full.club_id = non_member_clubs.club_id   
            order by dotlrn_clubs_full.pretty_name,
                     dotlrn_clubs_full.community_key
        </querytext>
    </fullquery>

    <fullquery name="select_non_member_club_ids">
        <querytext>
                select f.club_id
                from dotlrn_clubs_full f
                where f.join_policy <> 'closed'
                  and f.club_id not in (select dotlrn_member_rels_full.community_id as club_id
                                          from dotlrn_member_rels_full
                                         where dotlrn_member_rels_full.user_id = :user_id)
        </querytext>
    </fullquery>

</queryset>

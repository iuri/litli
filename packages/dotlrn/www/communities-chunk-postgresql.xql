<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_all_communities_count">
        <querytext>
            select count(*)
            from dotlrn_communities_not_closed
        </querytext>
    </fullquery>

    <fullquery name="select_current_memberships">
        <querytext>
            select dotlrn_communities.community_id,
                   dotlrn_communities.community_type,
                   dotlrn_communities.pretty_name,
                   dotlrn_communities.description,
                   dotlrn_communities.package_id,
                   dotlrn_community__url(dotlrn_communities.community_id) as url,
                   1 as member_p,
                   CASE
                      WHEN acs_permission__permission_p(:user_id, 
                                                        dotlrn_communities.community_id, 
                                                        'admin') = 'f'
                      THEN 0
                      ELSE 1
                   END as admin_p,
                   (select dotlrn_community_types.community_type
                    from dotlrn_community_types
                    where dotlrn_community_types.tree_sortkey = tree_ancestor_key(dotlrn_communities.tree_sortkey, 1)) as root_community_type
            from dotlrn_active_communities dotlrn_communities,
                 dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.user_id = :user_id
            and dotlrn_member_rels_approved.community_id = dotlrn_communities.community_id
            order by root_community_type,
                     dotlrn_communities.community_type,
                     dotlrn_communities.pretty_name
        </querytext>
    </fullquery>

    <fullquery name="select_all_memberships">
        <querytext>
            select dotlrn_communities.community_id,
                   dotlrn_communities.community_type,
                   dotlrn_communities.pretty_name,
                   dotlrn_communities.description,
                   dotlrn_communities.package_id,
                   dotlrn_community__url(dotlrn_communities.community_id) as url,
                   1 as member_p,
                   CASE
                      WHEN acs_permission__permission_p(:user_id, 
                                                        dotlrn_communities.community_id, 
                                                        'admin') = 'f'
                      THEN 0
                      ELSE 1
                   END as admin_p,
                   (select dotlrn_community_types.community_type
                    from dotlrn_community_types
                    where dotlrn_community_types.tree_sortkey = tree_ancestor_key(dotlrn_communities.tree_sortkey, 1)) as root_community_type
            from dotlrn_communities dotlrn_communities,
                 dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.user_id = :user_id
            and dotlrn_member_rels_approved.community_id = dotlrn_communities.community_id
            order by root_community_type,
                     dotlrn_communities.community_type,
                     dotlrn_communities.pretty_name
        </querytext>
    </fullquery>

    <fullquery name="select_current_non_memberships">
        <querytext>
            select dotlrn_communities.community_id,
                   dotlrn_communities.community_type,
                   dotlrn_communities.pretty_name,
                   dotlrn_communities.description,
                   dotlrn_communities.package_id,
                   dotlrn_community__url(dotlrn_communities.community_id) as url,
                   0 as member_p,
                   CASE
                      WHEN acs_permission__permission_p(:user_id, 
                                                        dotlrn_communities.community_id, 
                                                        'admin') = 'f'
                      THEN 0
                      ELSE 1
                   END as admin_p,
                   (select dotlrn_community_types.community_type
                    from dotlrn_community_types
                    where dotlrn_community_types.tree_sortkey = tree_ancestor_key(dotlrn_communities.tree_sortkey, 1)) as root_community_type
            from dotlrn_active_comms_not_closed dotlrn_communities
            where not exists (select 1
                              from dotlrn_member_rels_full
                              where dotlrn_member_rels_full.user_id = :user_id
                              and dotlrn_member_rels_full.community_id = dotlrn_communities.community_id)
            order by root_community_type,
                     dotlrn_communities.community_type,
                     dotlrn_communities.pretty_name
        </querytext>
    </fullquery>

    <fullquery name="select_all_non_memberships">
        <querytext>
            select dotlrn_communities.community_id,
                   dotlrn_communities.community_type,
                   dotlrn_communities.pretty_name,
                   dotlrn_communities.description,
                   dotlrn_communities.package_id,
                   dotlrn_community__url(dotlrn_communities.community_id) as url,
                   0 as member_p,
                   CASE
                      WHEN acs_permission__permission_p(:user_id, 
                                                        dotlrn_communities.community_id, 
                                                        'admin') = 'f'
                      THEN 0
                      ELSE 1
                   END as admin_p,
                   (select dotlrn_community_types.community_type
                    from dotlrn_community_types
                    where dotlrn_community_types.tree_sortkey = tree_ancestor_key(dotlrn_communities.tree_sortkey, 1)) as root_community_type
            from dotlrn_communities_not_closed dotlrn_communities
            where not exists (select 1
                              from dotlrn_member_rels_full
                              where dotlrn_member_rels_full.user_id = :user_id
                              and dotlrn_member_rels_full.community_id = dotlrn_communities.community_id)
            and dotlrn_communities.parent_community_id is null
            order by root_community_type,
                     dotlrn_communities.community_type,
                     dotlrn_communities.pretty_name
        </querytext>
    </fullquery>

    <fullquery name="select_all_communities_count_by_type">
        <querytext>
            select count(*)
            from dotlrn_communities_not_closed dotlrn_communities
            where dotlrn_communities.community_type = :community_type
        </querytext>
    </fullquery>

    <fullquery name="select_current_memberships_by_type">
        <querytext>
            select dotlrn_communities.community_id,
                   dotlrn_communities.community_type,
                   dotlrn_communities.pretty_name,
                   dotlrn_communities.description,
                   dotlrn_communities.package_id,
                   dotlrn_community__url(dotlrn_communities.community_id) as url,
                   1 as member_p,
                   CASE
                      WHEN acs_permission__permission_p(:user_id, 
                                                        dotlrn_communities.community_id, 
                                                        'admin') = 'f'
                      THEN 0
                      ELSE 1
                   END as admin_p,
                   (select dotlrn_community_types.community_type
                    from dotlrn_community_types
                    where dotlrn_community_types.tree_sortkey = tree_ancestor_key(dotlrn_communities.tree_sortkey, 1)) as root_community_type
            from dotlrn_active_communities dotlrn_communities,
                 dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.user_id = :user_id
            and dotlrn_member_rels_approved.community_id = dotlrn_communities.community_id
            and dotlrn_communities.community_type = :community_type
            order by root_community_type,
                     dotlrn_communities.community_type,
                     dotlrn_communities.pretty_name
        </querytext>
    </fullquery>

    <fullquery name="select_all_memberships_by_type">
        <querytext>
            select dotlrn_communities.community_id,
                   dotlrn_communities.community_type,
                   dotlrn_communities.pretty_name,
                   dotlrn_communities.description,
                   dotlrn_communities.package_id,
                   dotlrn_community__url(dotlrn_communities.community_id) as url,
                   1 as member_p,
                   CASE
                      WHEN acs_permission__permission_p(:user_id, 
                                                        dotlrn_communities.community_id, 
                                                        'admin') = 'f'
                      THEN 0
                      ELSE 1
                   END as admin_p,
                   (select dotlrn_community_types.community_type
                    from dotlrn_community_types
                    where dotlrn_community_types.tree_sortkey = tree_ancestor_key(dotlrn_communities.tree_sortkey, 1)) as root_community_type
            from dotlrn_communities dotlrn_communities,
                 dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.user_id = :user_id
            and dotlrn_member_rels_approved.community_id = dotlrn_communities.community_id
            and dotlrn_communities.community_type = :community_type
            order by root_community_type,
                     dotlrn_communities.community_type,
                     dotlrn_communities.pretty_name
        </querytext>
    </fullquery>

    <fullquery name="select_current_non_memberships_by_type">
        <querytext>
            select dotlrn_communities.community_id,
                   dotlrn_communities.community_type,
                   dotlrn_communities.pretty_name,
                   dotlrn_communities.description,
                   dotlrn_communities.package_id,
                   dotlrn_community__url(dotlrn_communities.community_id) as url,
                   0 as member_p,
                   CASE
                      WHEN acs_permission__permission_p(:user_id, 
                                                        dotlrn_communities.community_id, 
                                                        'admin') = 'f'
                      THEN 0
                      ELSE 1
                   END as admin_p,
                   (select dotlrn_community_types.community_type
                    from dotlrn_community_types
                    where dotlrn_community_types.tree_sortkey = tree_ancestor_key(dotlrn_communities.tree_sortkey, 1)) as root_community_type
            from dotlrn_active_comms_not_closed dotlrn_communities
            where not exists (select 1
                              from dotlrn_member_rels_full
                              where dotlrn_member_rels_full.user_id = :user_id
                              and dotlrn_member_rels_full.community_id = dotlrn_communities.community_id)
            and dotlrn_communities.community_type = :community_type
            order by root_community_type,
                     dotlrn_communities.community_type,
                     dotlrn_communities.pretty_name
        </querytext>
    </fullquery>

    <fullquery name="select_all_non_memberships_by_type">
        <querytext>
            select dotlrn_communities.community_id,
                   dotlrn_communities.community_type,
                   dotlrn_communities.pretty_name,
                   dotlrn_communities.description,
                   dotlrn_communities.package_id,
                   dotlrn_community__url(dotlrn_communities.community_id) as url,
                   0 as member_p,
                   CASE
                      WHEN acs_permission__permission_p(:user_id, 
                                                        dotlrn_communities.community_id, 
                                                        'admin') = 'f'
                      THEN 0
                      ELSE 1
                   END as admin_p,
                   (select dotlrn_community_types.community_type
                    from dotlrn_community_types
                    where dotlrn_community_types.tree_sortkey = tree_ancestor_key(dotlrn_communities.tree_sortkey, 1)) as root_community_type
            from dotlrn_communities_not_closed dotlrn_communities
            where not exists (select 1
                              from dotlrn_member_rels_full
                              where dotlrn_member_rels_full.user_id = :user_id
                              and dotlrn_member_rels_full.community_id = dotlrn_communities.community_id)
            and dotlrn_communities.community_type = :community_type
            order by root_community_type,
                     dotlrn_communities.community_type,
                     dotlrn_communities.pretty_name
        </querytext>
    </fullquery>

</queryset>

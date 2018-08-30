<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_communities">
        <querytext>
            select dotlrn_communities_all.*,
                   dotlrn_community__url(dotlrn_communities_all.community_id) as url,
                   (CASE
                      WHEN
                         dotlrn_communities_all.community_type = 'dotlrn_community'
                      THEN 'dotlrn_community'
                      WHEN dotlrn_communities_all.community_type = 'dotlrn_club'
                      THEN 'dotlrn_club'
                      WHEN dotlrn_communities_all.community_type = 'dotlrn_pers_community'
                      THEN 'dotlrn_pers_community'
                      ELSE 'dotlrn_class_instance'
                   END) as simple_community_type,
                   tree_level(dotlrn_communities_all.tree_sortkey) as tree_level,
                   coalesce((select tree_level(dotlrn_community_types.tree_sortkey)
                        from dotlrn_community_types
                        where dotlrn_community_types.community_type = dotlrn_communities_all.community_type), 0) as community_type_level,
                   acs_permission__permission_p(dotlrn_communities_all.community_id, :user_id, 'admin') as admin_p
            from dotlrn_communities_all,
                 dotlrn_member_rels_approved
            where dotlrn_communities_all.community_id = dotlrn_member_rels_approved.community_id
            and dotlrn_member_rels_approved.user_id = :user_id
            $archived_clause
            $community_type_clause
            order by dotlrn_communities_all.tree_sortkey
        </querytext>
    </fullquery>

</queryset>

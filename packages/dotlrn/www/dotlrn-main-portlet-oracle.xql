<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="select_communities">
        <querytext>
            select dotlrn_communities_all.*,
                   dotlrn_community.url(dotlrn_communities_all.community_id) as url,
                   decode(dotlrn_communities_all.community_type, 'dotlrn_community', 'dotlrn_community',
                                                             'dotlrn_club', 'dotlrn_club',
                                                             'dotlrn_pers_community', 'dotlrn_pers_community',
                                                             'dotlrn_class_instance') as simple_community_type,
                   acs_permission.permission_p(dotlrn_communities_all.community_id, :user_id, 'admin') as admin_p,
                   tree.tree_level(dotlrn_communities_all.tree_sortkey) as tree_level,
                   nvl((select tree.tree_level(dotlrn_community_types.tree_sortkey)
                        from dotlrn_community_types
                        where dotlrn_community_types.community_type = dotlrn_communities_all.community_type), 0) as community_type_level
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

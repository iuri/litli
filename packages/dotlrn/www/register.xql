<?xml version="1.0"?>

<queryset>

    <fullquery name="select_join_policy">
        <querytext>
	   select join_policy
	   from dotlrn_communities_full
	   where community_id = :community_id
        </querytext>
    </fullquery>

    <fullquery name="select_admin_rel_segment_id">
        <querytext>
            select rel_segments.segment_id
            from rel_segments
            where rel_segments.group_id = :community_id
            and rel_segments.rel_type = 'dotlrn_admin_rel'
        </querytext>
    </fullquery>

</queryset>

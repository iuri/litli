<?xml version="1.0"?>

<queryset>

    <fullquery name="select_community_info">
        <querytext>
            select community_type,
                   pretty_name,
                   description,
                   portal_id,
                   admin_portal_id,
                   non_member_portal_id, 
                   archived_p
            from dotlrn_communities_all
            where community_id = :community_id
        </querytext>
    </fullquery>

</queryset>

<?xml version="1.0"?>

<queryset>

    <fullquery name="update_join_policy">
        <querytext>
            update groups
            set join_policy = :policy
            where group_id = :community_id
        </querytext>
    </fullquery>

</queryset>

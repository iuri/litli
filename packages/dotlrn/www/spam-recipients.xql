<?xml version="1.0"?>

<queryset>

    <fullquery name="select_current_members">
        <querytext>
            select registered_users.first_names,
                   registered_users.last_name,
                   registered_users.email,
                   registered_users.user_id
            from registered_users,
                 dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.community_id = :community_id
            and dotlrn_member_rels_approved.user_id = registered_users.user_id
            order by last_name, first_names
        </querytext>
    </fullquery>

</queryset>

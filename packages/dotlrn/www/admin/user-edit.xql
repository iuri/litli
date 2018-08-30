<?xml version="1.0"?>

<queryset>

    <fullquery name="update_user">
        <querytext>
            update dotlrn_user_profile_rels
            set id = :id
            where rel_id = (select rel_id
                            from dotlrn_users
                            where user_id = :user_id)
        </querytext>
    </fullquery>

</queryset>

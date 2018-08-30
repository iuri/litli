<?xml version="1.0"?>

<queryset>

    <fullquery name="select_users_pending_drop">
        <querytext>
            select user_id,
                   first_names,
                   last_name
            from dotlrn_users
            where user_id in ([join $user_id ","])
		order by last_name asc
        </querytext>
    </fullquery>

</queryset>

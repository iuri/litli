<?xml version="1.0"?>

<queryset>

    <fullquery name="select_dotlrn_users_count">
        <querytext>
            select count(*)
            from dotlrn_users
            where dotlrn_users.type = :type
        </querytext>
    </fullquery>

</queryset>

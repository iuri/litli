<?xml version="1.0"?>

<queryset>

    <fullquery name="is_dotlrn_user">
        <querytext>
            select count(*)
            from dual
            where exists (select 1
                          from dotlrn_users
                          where user_id = :user_id)
        </querytext>
    </fullquery>

</queryset>

<?xml version="1.0"?>

<queryset>

    <fullquery name="select_user_info">      
        <querytext>
        select email,
               first_names,
               last_name,
               to_char(last_visit,'YYYY-MM-DD HH24:MI:SS') as last_visit,
               (select count(*) from acs_objects
                where creation_user = :user_id) as n_objects
        from cc_users
        where user_id = :user_id
        </querytext>
    </fullquery>

</queryset>

<?xml version="1.0"?>
<queryset>

<fullquery name="users_n_users">      
      <querytext>
          select count(user_id) as n_users, 
                 max(creation_date) as last_registration
          from   users u,
                 acs_objects o
          where  o.object_id = u.user_id
            and  user_id <> 0
      </querytext>
</fullquery>

</queryset>

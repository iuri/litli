<?xml version="1.0"?>

<queryset>

   <fullquery name="dotlrn_admins_select">
       <querytext>
          select
             registered_users.user_id,
             registered_users.last_name,
             registered_users.first_names,
             registered_users.email
          from 
            registered_users,
            group_member_map 
          where
            registered_users.user_id = group_member_map.member_id
          AND
            group_member_map.group_id = :dotlrn_admins_group 

       </querytext>
   </fullquery>

</queryset>
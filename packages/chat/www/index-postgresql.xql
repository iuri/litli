<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="rooms_list">
  <querytext>
    select room_id, pretty_name, description, moderated_p, active_p, archive_p, 
           acs_permission__permission_p(chats.room_id, :user_id, 'chat_room_admin') as admin_p, 
           acs_permission__permission_p(chats.room_id, :user_id, 'chat_read') as user_p, 
           (select site_node__url(site_nodes.node_id) from site_nodes
            where site_nodes.object_id = chats.context_id) as base_url,
           msg_count
    from (select rm.room_id,     
           rm.pretty_name, 
           rm.description, 
           rm.moderated_p, 
           rm.active_p, 
           rm.archive_p,
           obj.context_id,
           count(msg.msg_id) AS msg_count
         from chat_rooms rm LEFT JOIN chat_msgs msg USING(room_id), acs_objects obj 
         where rm.room_id = obj.object_id and obj.context_id = :package_id
         GROUP BY rm.room_id, rm.pretty_name, rm.description, rm.moderated_p, rm.active_p, rm.archive_p, obj.context_id
         order by rm.pretty_name
    ) chats
  </querytext>
</fullquery>

</queryset>


<?xml version="1.0"?>
<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="list_user_ban">
  <querytext>
   select m.party_id, p.last_name || ', ' || p.first_names as name, pa.email
    from acs_object_party_privilege_map m, persons p, parties pa
    where m.party_id = p.person_id and m.object_id = :room_id
    and m.privilege = 'chat_ban' and p.person_id = pa.party_id
    order by p.last_name, p.first_names
  </querytext>
</fullquery>

</queryset>









<?xml version="1.0"?>
<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="list_user_ban">
  <querytext>
    select pa.party_id, p.last_name || ', ' || p.first_names as name, pa.email
    from persons p, parties pa
    where p.person_id = pa.party_id
    and pa.party_id in
    (select acs_permission.parties_with_object_privilege(:room_id::integer, 'chat_ban'::varchar))
    order by p.last_name, p.first_names
  </querytext>
</fullquery>

</queryset>









<?xml version="1.0"?>
<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

  <fullquery name="dotlrn::apm::after_upgrade.insert_group_rels">
    <querytext>
      insert into group_rels
        (group_rel_id, group_id, rel_type)
      select nextval(acs_object_id_seq.nextval, a.group_id, g.rel_type
        from group_type_rels g, application_groups a
        where g.group_type = 'application_group'
        and not exists (
          select 1 from group_rels
          where group_id = a.group_id
          and rel_type = g.rel_type
        )
    </querytext>
  </fullquery>

</queryset>

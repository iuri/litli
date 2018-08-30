<?xml version="1.0"?>
<queryset>
  <rdbms><type>postgresql</type><version>7.1</version></rdbms>

  <fullquery name="dotlrn::apm::after_upgrade.insert_group_rels">
    <querytext>
    insert into group_rels
    (group_rel_id, group_id, rel_type)
    select nextval('t_acs_object_id_seq'), a.group_id, g.rel_type
      from group_type_rels g,
      application_groups a,
      ( select parent.object_type as parent_type
        from acs_object_types child, acs_object_types parent
        where child.object_type <> parent.object_type
        and child.tree_sortkey between parent.tree_sortkey
        and tree_right(parent.tree_sortkey)
        and child.object_type = 'application_group'
        order by parent.tree_sortkey desc
      ) types
     where g.group_type = types.parent_type
     and not exists
     ( select 1 from group_rels
       where group_rels.group_id = a.group_id
       and group_rels.rel_type = g.rel_type
     )
    </querytext>
  </fullquery>

</queryset>

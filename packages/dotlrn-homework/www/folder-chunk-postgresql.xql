<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.2</version></rdbms>

    <fullquery name="select_default_min_level">
        <querytext>
            select tree_level(tree_sortkey) as min_level
            from cr_items where item_id = :folder_id
	</querytext>
    </fullquery>

    <fullquery name="select_folder_contents">
        <querytext>
            select
              o.object_id,
              coalesce(f.label, fs_tree.name) as name,
              fs_tree.live_revision as version_id,
              fs_tree.content_type,
              r.content_length, r.title,
              fs_tree.parent_id as folder_id,
              lpad(' ',(tree_level(fs_tree.tree_sortkey) - 1), ' ') as spaces,
              rels.related_object_id as homework_file_id,
              p.first_names || ' ' || p.last_name as file_owner_name,
              o.creation_user
            from
              (select cr_items.*
               from cr_items, cr_items as cr_items2
               where cr_items2.item_id in ([join $list_of_folder_ids ", "])
                 and cr_items.tree_sortkey between
                   cr_items2.tree_sortkey and tree_right(cr_items2.tree_sortkey)
                 and tree_level(cr_items.tree_sortkey) > :min_level
                 and tree_level(cr_items.tree_sortkey) <= :max_level + 1) fs_tree
              join acs_objects o on (o.object_id = fs_tree.item_id)
              left join cr_folders f on (f.folder_id = fs_tree.item_id)
              left join persons p on (p.person_id = o.creation_user)
              left join cr_revisions r on (r.revision_id = fs_tree.latest_revision)
              left join cr_item_rels rels on
                (rels.item_id = o.object_id and rels.relation_tag = 'homework_correction')
            where not exists (select 1
                              from cr_item_rels
                              where related_object_id = o.object_id
                                and relation_tag = 'homework_correction')
              $qualify_by_owner
            order by content_item__get_path(fs_tree.item_id, null)
        </querytext>
    </fullquery>

</queryset>

<?xml version="1.0"?>
<queryset>
  <rdbms>
    <type>postgresql</type>
    <version>7.2</version>
  </rdbms>

  <fullquery name="get_random_photo_all">
    <querytext>
      select ci.item_id as photo_id,
          (select pp.caption 
	  from pa_photos pp 
          where pp.pa_photo_id = ci.live_revision) as caption,
      	  i.image_id as thumb_path,
      	  i.height as thumb_height,
      	  i.width as thumb_width,
      	  random() as seed
      from cr_items ci, cr_items ci2, cr_child_rels ccr2, images i
      where $size_clause
      and ci.item_id = ccr2.parent_id
      and ccr2.child_id = ci2.item_id
      and ci2.live_revision = i.image_id
      and ci.live_revision is not null
      $photo_clause
      order by seed limit 1
    </querytext>
  </fullquery>
  
  <fullquery name="get_url">
    <querytext>
      select site_node__url(sn.node_id)
      from site_nodes sn
      	inner join pa_package_root_folder_map pm on (sn.object_id = pm.package_id)
      	inner join cr_items parent on (pm.folder_id = parent.item_id)
      	inner join cr_items child on (parent.tree_sortkey <= child.tree_sortkey)
      where child.tree_sortkey between parent.tree_sortkey and tree_right(parent.tree_sortkey)
      and tree_level(parent.tree_sortkey) = 2
      and child.item_id = :photo_id
    </querytext>
  </fullquery>
  
  <fullquery name="get_random_photo_folder">
    <querytext>
      select ci.item_id as photo_id,
          (select pp.caption 
	  from pa_photos pp 
          where pp.pa_photo_id = ci.live_revision) as caption,
      	  i.image_id as thumb_path,
      	  i.height as thumb_height,
      	  i.width as thumb_width,
      	  random() as seed
      from cr_items ci, cr_items ci2, cr_items root, cr_child_rels ccr2, images i
      where $size_clause
      and ci.item_id = ccr2.parent_id
      and ccr2.child_id = ci2.item_id
      and ci2.live_revision = i.image_id
      and ci.live_revision is not null
      and ci.tree_sortkey between root.tree_sortkey and tree_right(root.tree_sortkey)
      and root.item_id = :root_folder_id
      order by seed limit 1
    </querytext>
  </fullquery>

  <partialquery name="photo_clause">
    <querytext>
      and ci.item_id = :photo_id
    </querytext>
  </partialquery>

  <partialquery name="size_clause_normal">
    <querytext>
      ccr2.relation_tag = 'viewer'
    </querytext>
  </partialquery>
  
  <partialquery name="size_clause_thumb">
    <querytext>
      ccr2.relation_tag = 'thumb'
    </querytext>
  </partialquery>
  
</queryset>

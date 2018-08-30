<?xml version="1.0"?>
<queryset>

<fullquery name="get_clips">      
      <querytext>
	select c.collection_id, c.title 
	 from pa_collections c, pa_collection_photo_map m 
	 where m.photo_id = :photo_id 
	   and m.collection_id = c.collection_id 
	   and owner_id = :user_id
	 order by c.title
      </querytext>
</fullquery>

<fullquery name="filename">      
      <querytext>
	select name from cr_items where item_id = :photo_id
      </querytext>
</fullquery>

<fullquery name="duplicate_check">      
      <querytext>
	select count(*)
	 from cr_items
	 where name = :filename
	   and parent_id = :new_album_id
      </querytext>
</fullquery>

<fullquery name="get_parent_album">      
      <querytext>
      select parent_id from cr_items where item_id = :photo_id
      </querytext>
</fullquery>

<fullquery name="photo_rel_id">      
      <querytext>
	select rel_id from cr_child_rels 
	where parent_id = :old_album_id
	  and child_id = :photo_id
      </querytext>
</fullquery>

<fullquery name="photo_move">      
      <querytext>

	update cr_items
	set parent_id = :new_album_id
	where item_id = :photo_id

      </querytext>
</fullquery>
 
<fullquery name="photo_move2">      
      <querytext>
      
	update cr_child_rels 
	set parent_id = :new_album_id
	where parent_id = :old_album_id
	  and child_id = :photo_id
	
      </querytext>
</fullquery>

<fullquery name="context_update">      
      <querytext>
      
	update acs_objects
	set    context_id = :new_album_id
	where  object_id = :photo_id or object_id = :rel_id
	
      </querytext>
</fullquery>

<fullquery name="get_thumbnail_info">      
  <querytext>
    select ci.item_id as thumb_photo_id,
           i.image_id as thumb_image_id,
           i.height as thumb_height,
           i.width as thumb_width
      from cr_items ci,
           cr_items ci2,
           cr_child_rels ccr2,
           images i
     where ccr2.relation_tag = 'thumb'
       and ci.item_id = ccr2.parent_id
       and ccr2.child_id = ci2.item_id
       and ci2.live_revision = i.image_id
       and ci.live_revision is not null
       and ci.item_id = :photo_id
     </querytext>
</fullquery>

</queryset>

<?xml version="1.0"?>
<queryset>

<fullquery name="get_thumbnail_info">      
  <querytext>	
    select 
      i.image_id as thumb_path,
      i.height as thumb_height,
      i.width as thumb_width
    from cr_items ci,
      cr_items ci2,
      cr_child_rels ccr2,
      images i
    where ccr2.relation_tag = 'thumb'
      and ci.item_id = ccr2.parent_id
      and ccr2.child_id = ci2.item_id
      and ci2.latest_revision = i.image_id
      and ci.latest_revision is not null
      and ci.item_id = :photo_id
  </querytext>
</fullquery>

<fullquery name="get_photo_info">      
      <querytext>
      select 
      ci.item_id,	
      ci.live_revision,
      ci.latest_revision as previous_revision,
      pp.caption,
      pp.story,
      cr.title,
      cr.description,
      i.height as height,
      i.width as width,
      i.image_id as image_id
    from cr_items ci,
      cr_revisions cr,
      pa_photos pp,
      cr_items ci2,
      cr_child_rels ccr2,
      images i
    where ci.latest_revision = pp.pa_photo_id
      and ci.latest_revision = cr.revision_id
      and ci.item_id = ccr2.parent_id
      and ccr2.child_id = ci2.item_id
      and ccr2.relation_tag = 'viewer'
      and ci2.latest_revision = i.image_id
      and ci.item_id = :photo_id

      </querytext>
</fullquery>


<fullquery name="update_hides">      
      <querytext>
	 update cr_items set live_revision = null where item_id = :photo_id
      </querytext>
</fullquery>

<fullquery name="insert_photo_attributes">      
      <querytext>
	    insert into pa_photos 
        (pa_photo_id, story, caption, 
         user_filename,camera_model,date_taken,flash, 
         aperture,metering,focal_length,exposure_time,
         focus_distance,sha256,photographer)
        SELECT :revision_id, :new_story, :new_caption, 
               user_filename,camera_model,date_taken,flash, 
               aperture,metering,focal_length,exposure_time,
               focus_distance,sha256,photographer
          FROM pa_photos prev
         WHERE prev.pa_photo_id = :previous_revision
        
      </querytext>
</fullquery>
 
</queryset>




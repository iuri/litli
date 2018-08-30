<?xml version="1.0"?>
<queryset>
 
<fullquery name="get_portrait_info">      
  <querytext>
    select cr.publish_date, cr.title as portrait_title, cr.description as portrait_description, i.width, i.height, ci.item_id
    from cr_revisions cr, cr_items ci, acs_rels a, images i
    where i.image_id = cr.revision_id
    and cr.revision_id = ci.live_revision
    and ci.item_id = a.object_id_two
    and a.object_id_one = :user_id
    and a.rel_type = 'user_portrait_rel'
  </querytext>
</fullquery>
 
</queryset>

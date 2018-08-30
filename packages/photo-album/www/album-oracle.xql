<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_album_info">      
      <querytext>

    select cr.title,
           cr.description,
           pa.photographer,
           pa.story,
           ci.parent_id as parent_folder_id,
           case when acs_permission.permission_p(ci.item_id, :user_id, 'admin') = 't' then 1 else 0 end as admin_p,
           case when acs_permission.permission_p(ci.item_id, :user_id, 'pa_create_photo') = 't' then 1 else 0 end as photo_p,
           case when acs_permission.permission_p(ci.item_id, :user_id, 'write') ='t' then 1 else 0 end as write_p,
           case when acs_permission.permission_p(ci.parent_id, :user_id, 'write') = 't' then 1 else 0 end as folder_write_p,
           case when acs_permission.permission_p(ci.item_id, :user_id, 'delete') = 't' then 1 else 0 end as album_delete_p
    from cr_items ci,
         cr_revisions cr,
         pa_albums pa
    where ci.live_revision = cr.revision_id
      and ci.live_revision = pa_album_id
      and ci.item_id = :album_id

      </querytext>
</fullquery>

</queryset>

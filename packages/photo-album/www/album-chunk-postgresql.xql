<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_folder_info">      
      <querytext>
      select 
      cf.label as folder_name,
      cf.description as folder_description,
      case when acs_permission__permission_p(cf.folder_id, :user_id, 'admin') = 't' then 1 else 0 end as admin_p,
      case when acs_permission__permission_p(cf.folder_id, :user_id, 'pa_create_folder') = 't' then 1 else 0 end as subfolder_p,
      case when acs_permission__permission_p(cf.folder_id, :user_id, 'pa_create_album') = 't' then 1 else 0 end as album_p,
      case when acs_permission__permission_p(cf.folder_id, :user_id, 'write') = 't' then 1 else 0 end as write_p,
      case when acs_permission__permission_p(ci.parent_id, :user_id, 'write') = 't' then 1 else 0 end as parent_folder_write_p,
      (select count(*)  where exists (select 1 from cr_items ci2 where ci2.parent_id = cf.folder_id)) as has_children_p,
      case when acs_permission__permission_p(cf.folder_id, :user_id, 'delete') = 't' then 1 else 0 end as folder_delete_p
      from cr_folders cf,
      cr_items ci 
      where ci.item_id = cf.folder_id
      and ci.item_id = :folder_id
      </querytext>
</fullquery>

 
<fullquery name="get_children">      
      <querytext>
      
    select * from (
      select i.item_id,
        r.title as name,
        r.description,
        'Album' as type,
        1 as ordering_key,
        ic.image_id as iconic,
        ic.width,
        ic.height
      from   cr_items i,
        cr_revisions r,
        pa_albums a left outer join all_photo_images ic
          on (ic.item_id = a.iconic and ic.relation_tag='thumb')
      where i.content_type = 'pa_album'
        and i.parent_id     = :folder_id
        and i.live_revision = r.revision_id
        and a.pa_album_id = i.live_revision
      UNION ALL
      select i.item_id,
        f.label as name,
        f.description,
        'Folder',
        0,
        null as iconic,0,0
      from cr_items i,
        cr_folders f
      where i.parent_id = :folder_id      
        and i.item_id = f.folder_id
      ) as x 
    where acs_permission__permission_p(item_id, :user_id, 'read') = 't'
    order by ordering_key,name

      </querytext>
</fullquery>

 
</queryset>

<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_folder_info">      
      <querytext>
      
    select 
      cf.label as folder_name,
      cf.description as folder_description,
      decode(acs_permission.permission_p(cf.folder_id, :user_id, 'admin'),'t',1,0) as admin_p,
      decode(acs_permission.permission_p(cf.folder_id, :user_id, 'pa_create_folder'),'t',1,0) as subfolder_p,
      decode(acs_permission.permission_p(cf.folder_id, :user_id, 'pa_create_album'),'t',1,0) as album_p,
      decode(acs_permission.permission_p(cf.folder_id, :user_id, 'write'),'t',1,0) as write_p,
      decode(acs_permission.permission_p(ci.parent_id, :user_id, 'write'),'t',1,0) as parent_folder_write_p,
      (select count(*) from dual where exists (select 1 from cr_items ci2 where ci2.parent_id = cf.folder_id)) as has_children_p,
      decode(acs_permission.permission_p(cf.folder_id, :user_id, 'delete'),'t',1,0) as folder_delete_p
    from cr_folders cf,
      cr_items ci 
    where ci.item_id = cf.folder_id
      and ci.item_id = :folder_id

      </querytext>
</fullquery>

 
<fullquery name="get_children">      
      <querytext>
      
    select * from
      (select i.item_id,
        r.title as name,
        r.description,
        'Album' as type,
        1 as ordering_key,
        icon.image_id as iconic,
        icon.width,
        icon.height
      from   cr_items i,
        cr_revisions r,
        pa_albums a,
        (select item_id, image_id, height, width 
           from all_photo_images 
          where relation_tag = 'thumb') icon 
      where i.content_type = 'pa_album'
        and i.parent_id     = :folder_id
        and i.live_revision = r.revision_id
        and a.pa_album_id = i.live_revision
        and icon.item_id(+) = a.iconic
      UNION ALL
      select i.item_id,
        f.label as name,
        f.description,
        'Folder' as type,
	0 as ordering_key,
        0 as iconic,
        0,
        0
      from cr_items i,
        cr_folders f
      where i.parent_id = :folder_id      
        and i.item_id = f.folder_id
      ) x
    where acs_permission.permission_p(item_id, :user_id, 'read') = 't'
    order by ordering_key,name

      </querytext>
</fullquery>

 
</queryset>

-- /packages/photo-album/sql/oracle/photo-album-drop.sql

-- @cvs-id $Id: photo-album-drop.sql,v 1.3 2003/09/30 12:10:09 mohanp Exp $

@@ pa-clip-drop.sql

declare
  cursor priv_cursor is
    select object_id, grantee_id, privilege
    from acs_permissions 
    where privilege = 'pa_create_photo';
  priv_val  priv_cursor%ROWTYPE;
begin
  for priv_val in priv_cursor
    loop
      acs_permission.revoke_permission (
        object_id  => priv_val.object_id,
	    grantee_id => priv_val.grantee_id,
	    privilege  => priv_val.privilege
      );
    end loop;
end;
/
show errors

declare
  cursor priv_cursor is
    select object_id, grantee_id, privilege
    from acs_permissions 
    where privilege = 'pa_create_album';
  priv_val  priv_cursor%ROWTYPE;
begin
  for priv_val in priv_cursor
    loop
      acs_permission.revoke_permission (
        object_id  => priv_val.object_id,
    	grantee_id => priv_val.grantee_id,
    	privilege  => priv_val.privilege
      );
    end loop;
end;
/
show errors

declare
  cursor priv_cursor is
    select object_id, grantee_id, privilege
    from acs_permissions 
    where privilege = 'pa_create_folder';
  priv_val  priv_cursor%ROWTYPE;
begin
  for priv_val in priv_cursor
    loop
      acs_permission.revoke_permission (
        object_id  => priv_val.object_id,
	grantee_id => priv_val.grantee_id,
	privilege  => priv_val.privilege
      );
    end loop;
end;
/
show errors

begin
  -- kill stuff in permissions.sql
 
  acs_privilege.remove_child('create', 'pa_create_photo');
  acs_privilege.remove_child('create', 'pa_create_album');
  acs_privilege.remove_child('create', 'pa_create_folder');

  acs_privilege.drop_privilege('pa_create_album');
  acs_privilege.drop_privilege('pa_create_folder');
  acs_privilege.drop_privilege('pa_create_photo');

end;
/
show errors

begin
  content_type.unregister_child_type (
    parent_type => 'pa_album',
    child_type => 'pa_photo',
    relation_tag => 'generic'
  );

  content_type.unregister_child_type (
    parent_type => 'pa_photo',
    child_type => 'image',
    relation_tag => 'generic'
  );
end;
/
show errors

-- clear out all the reference that cause key violations when droping type

-- delete images
-- now that pa_image is just image
-- the query needs to be adjusted to be specific to photo-album
-- this needs to be standardized with content-repository (clearing out files)
-- there isn't currently a image__delete function
-- so this bit won't work
-- declare
--   cursor image_cursor is
--    select i.item_id
--    from cr_items i, cr_child_rels rels, cr_items i2
--    where i.content_type = 'image'
--    and i2.content_type = 'pa_photo'
--    and rels.child_id = i.item_id
--    and rels.parent_id = i2.item_id;
--  image_val  image_cursor%ROWTYPE;
--begin
--  for image_val in image_cursor
--    loop
--      image.del (
--        item_id  => image_val.item_id
--      );
--    end loop;
--end;
--/
--show errors;

-- delete photos
declare
  cursor photo_cursor is
    select item_id
    from cr_items 
    where content_type = 'pa_photo';
  photo_val  photo_cursor%ROWTYPE;
begin
  for photo_val in photo_cursor
    loop
      pa_photo.del (
        item_id  => photo_val.item_id
      );
    end loop;
end;
/
show errors

-- delete albums
declare
  cursor album_cursor is
    select item_id
    from cr_items 
    where content_type = 'pa_album';
  album_val  album_cursor%ROWTYPE;
begin
  for album_val in album_cursor
    loop
      pa_album.del (
        album_id  => album_val.item_id
      );
    end loop;
end;
/
show errors

declare
  cursor folder_cursor is
    select folder_id, content_type
    from cr_folder_type_map where content_type = 'pa_album';
  folder_val folder_cursor%ROWTYPE;
begin
  for folder_val in folder_cursor
    loop
      content_folder.unregister_content_type (
        folder_id    => folder_val.folder_id,
    	content_type => folder_val.content_type
      );
    end loop;
end;
/
show errors

drop package photo_album;

drop package pa_album;

drop package pa_photo;  

begin
  acs_object_type.drop_type('pa_photo');
end;
/
show errors

drop table pa_photos;

begin
  acs_object_type.drop_type('pa_album');
end;
/
show errors;

drop table pa_albums;

-- delete all the folder under the root folders of photo album instances
declare
  cursor folder_cur is
    select item_id as folder_id, level
    from cr_items
    where content_type = 'content_folder'
    connect by prior item_id = parent_id
    start with item_id in (select folder_id from pa_package_root_folder_map)
    order by level desc;
  folder_val folder_cur%ROWTYPE;
begin
  for folder_val in folder_cur 
    loop
      if folder_val.level = 1 then
        -- folder is a root folder, delete it from maping table to avoid fk constraint violation
        delete from pa_package_root_folder_map where folder_id = folder_val.folder_id;
      end if;
      content_folder.del (folder_id => folder_val.folder_id);
    end loop;
end;
/
show errors;
  
drop table pa_package_root_folder_map;

--drop table pa_files_to_delete;

drop view all_photo_images;



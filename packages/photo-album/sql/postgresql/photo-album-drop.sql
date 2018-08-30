-- /packages/photo-album/sql/postgresql/photo-album-drop.sql

-- @cvs-id $Id: photo-album-drop.sql,v 1.5 2003/09/02 23:44:04 vinodk Exp $

\i pa-clip-drop.sql

drop view all_photo_images;

create function tmp_pa_revoke () 
returns integer as '
declare
  priv_rec RECORD;
begin
  for priv_rec in select object_id, grantee_id, privilege
    from acs_permissions 
    where privilege = ''pa_create_photo''
    loop
      PERFORM acs_permission__revoke_permission (
        priv_rec.object_id,
        priv_rec.grantee_id,
        priv_rec.privilege
      );
    end loop;
    return 1;
end; ' language 'plpgsql';

select tmp_pa_revoke ();

drop function tmp_pa_revoke ();

create function tmp_pa_revoke2 () 
returns integer as '
declare
  priv_rec RECORD;
begin
  for priv_rec in select object_id, grantee_id, privilege
    from acs_permissions 
    where privilege = ''pa_create_album''
    loop
      PERFORM acs_permission__revoke_permission (
        priv_rec.object_id,
        priv_rec.grantee_id,
        priv_rec.privilege
      );
    end loop;
    return 1;
end; ' language 'plpgsql';

select tmp_pa_revoke2 ();

drop function tmp_pa_revoke2 ();

create function tmp_pa_revoke3 () 
returns integer as '
declare
  priv_rec RECORD;
begin
  for priv_rec in select object_id, grantee_id, privilege
    from acs_permissions 
    where privilege = ''pa_create_folder''
    loop
      PERFORM acs_permission__revoke_permission (
        priv_rec.object_id,
        priv_rec.grantee_id,
        priv_rec.privilege
      );
    end loop;
    return 1;
end; ' language 'plpgsql';

select tmp_pa_revoke3 ();

drop function tmp_pa_revoke3 ();

-- kill stuff in permissions.sql
select acs_privilege__remove_child('create', 'pa_create_photo');
select acs_privilege__remove_child('create', 'pa_create_album');
select acs_privilege__remove_child('create', 'pa_create_folder');

select acs_privilege__drop_privilege('pa_create_album');
select acs_privilege__drop_privilege('pa_create_folder');
select acs_privilege__drop_privilege('pa_create_photo');

-- pa_image changed to generic image content_type

select content_type__unregister_child_type (
 'pa_album',
 'pa_photo',
  'generic'
);

select content_type__unregister_child_type (
 'pa_photo',
 'image',
 'generic'
);

-- clear out all the reference that cause key violations when dropping type

-- delete images
-- now that pa_image is just image
-- the query needs to be adjusted to be specific to photo-album
-- this needs to be standardized with content-repository (clearing out files)
-- there isn't currently a image__delete function
-- so this bit won't work
create function tmp_pa_image_delete () 
returns integer as '
declare
  image_rec RECORD;
begin
  for image_rec in select i.item_id
    from cr_items i, cr_child_rels rels,
    cr_items i2
    where i.content_type = ''image''
    and i2.content_type = ''pa_photo''
    and rels.child_id = i.item_id
    and rels.parent_id = i2.item_id
    loop
      PERFORM image__delete (image_rec.item_id);
    end loop;
    return 1;
end; ' language 'plpgsql';

select tmp_pa_image_delete ();

drop function tmp_pa_image_delete ();

-- delete photos
create function tmp_pa_photo_delete () 
returns integer as '
declare
  pa_photo_rec RECORD;
begin
  for pa_photo_rec in select item_id
    from cr_items
    where content_type = ''pa_photo''
    loop
      PERFORM pa_photo__delete (pa_photo_rec.item_id);
    end loop;
    return 1;
end; ' language 'plpgsql';

select tmp_pa_photo_delete ();

drop function tmp_pa_photo_delete ();

-- delete albums
create function tmp_pa_album_delete () 
returns integer as '
declare
  pa_album_rec RECORD;
begin
  for pa_album_rec in select item_id
    from cr_items
    where content_type = ''pa_album''
    loop
      PERFORM pa_album__delete (pa_album_rec.item_id);
    end loop;
    return 1;
end; ' language 'plpgsql';

select tmp_pa_album_delete ();

drop function tmp_pa_album_delete ();

create function tmp_pa_folder_delete () returns integer as '
declare
  folder_rec RECORD;
begin
  for folder_rec in select folder_id, content_type
    from cr_folder_type_map where content_type = ''pa_album''
    loop
      PERFORM content_folder__unregister_content_type (
        folder_rec.folder_id,
    folder_rec.content_type,
        ''t''
      );
    end loop;
    return 1;
end; ' language 'plpgsql';

select tmp_pa_folder_delete ();

drop function tmp_pa_folder_delete ();

-- drop package photo_album;
drop function photo_album__new_root_folder (integer);
drop function photo_album__get_root_folder (integer);

-- this needs to drop the pa_album__ functions
-- drop package pa_album;
drop function pa_album__delete_revision (integer);
drop function pa_album__delete (integer);
drop function pa_album__new (varchar, integer, integer, boolean, integer, varchar, varchar, varchar, text, varchar, integer, timestamptz, varchar, integer, timestamptz, varchar) ;

-- this needs to drop the pa_photo__ functions
-- drop package pa_photo;  
drop function pa_photo__delete (integer);
drop function pa_photo__delete_revision (integer);
drop function pa_photo__new (varchar,integer,integer,integer,timestamptz, integer, varchar, varchar, integer, varchar, varchar, boolean, timestamptz, varchar, varchar, text);

-- these drop tables as well
select content_type__drop_type('pa_photo','f','t');

select content_type__drop_type('pa_album','f','t');

-- delete all the folders under the root folders of photo album instances
-- replacing a connect by with the tree_sort business
create function tmp_pa_folder_delete2 () returns integer as '
declare
  folder_rec RECORD;
begin
  for folder_rec in select i1.item_id, 
        tree_level(i1.tree_sortkey) - tree_level(i2.tree_sortkey) as level
      from cr_items i1, cr_items i2
      where i1.tree_sortkey between i2.tree_sortkey and tree_right(i2.tree_sortkey)
        and i2.item_id in (select folder_id from pa_package_root_folder_map)
      order by i2.item_id, level desc
    loop
      if folder_rec.level = 0 then
      -- folder is a root folder, delete it from maping table to avoid fk constraint violation
        delete from pa_package_root_folder_map where folder_id = folder_rec.item_id;
      end if;
      PERFORM content_folder__delete (folder_rec.item_id);
    end loop;
    return 0;
end; ' language 'plpgsql';

select tmp_pa_folder_delete2 ();

drop function tmp_pa_folder_delete2 ();
  
drop table pa_package_root_folder_map;

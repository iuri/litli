-- /packages/photo-album/sql/postgresql/pl-pgsql.sql
--
-- packages to support ACS photo ablum application
--
-- need to replace the aD info with OpenACS 4 info
--
-- Copyright (C) 2000-2001 ArsDigita Corporation
-- @author Tom Baginski (bags@arsdigita.com)
-- @creation-date 01/08/2000
--
-- @cvs-id $Id: pl-pgsql.sql,v 1.5 2006/12/15 22:45:40 emmar Exp $
--
-- This is free software distributed under the terms of the GNU Public
-- License.  Full text of the license is available from the GNU Project:
-- http://www.fsf.org/copyleft/gpl.html
-- 
-- ported from sql/oracle/plsql-packages.sql

/*
--  creates new pa_photo
--  associated pa_images must be created by calling script
*/
-- drop function pa_photo__new (varchar,integer,integer,integer,timestamptz, integer, varchar, varchar, integer, varchar, varchar, boolean, timestamptz, varchar, varchar, text);

create or replace function pa_photo__new (varchar,integer,integer,integer,timestamptz, integer, varchar, varchar, integer, varchar, varchar, boolean, timestamptz, varchar, varchar, text
  ) returns integer as '
  declare 
    new__name		alias for $1;
    new__parent_id	alias for $2; -- default null
    new__item_id	alias for $3; -- default null
    new__revision_id	alias for $4; -- default null
    new__creation_date  alias for $5; -- default now()
    new__creation_user  alias for $6; -- default null
    new__creation_ip    alias for $7; -- default null
    new__locale         alias for $8; -- default null
    new__context_id     alias for $9; -- default null
    new__title          alias for $10; -- default null
    new__description    alias for $11; -- default null
    new__is_live        alias for $12; -- default f
    new__publish_date	alias for $13; -- default now()
    new__nls_language	alias for $14; -- default null
    new__caption	alias for $15; -- default null
    new__story		alias for $16; -- default null
    -- mime_type determined by image content_type
    new__mime_type	varchar default null;
    -- the same as title
    -- user_filename	in pa_photos.user_filename%TYPE default null
    new__content_type  varchar default ''pa_photo'';	
    new__relation_tag  varchar default null;	
    
    v_item_id		cr_items.item_id%TYPE;
    v_revision_id	cr_revisions.revision_id%TYPE;
  begin
    
    v_item_id := content_item__new (
      new__name,
      new__parent_id,
      new__item_id,
      new__locale,
      new__creation_date,
      new__creation_user,	
      new__context_id,
      new__creation_ip,
      ''content_item'',
      new__content_type,
      null,
      null,
      null,
      null,
      null
    );

      -- not needed in the new call to content_item__new
      -- new__relation_tag,

    v_revision_id := content_revision__new (
      new__title,
      new__description,
      new__publish_date,
      new__mime_type,
      new__nls_language,
      null,
      v_item_id,
      new__revision_id,
      new__creation_date,
      new__creation_user,
      new__creation_ip

    );

    insert into pa_photos
    (pa_photo_id, caption, story, user_filename)
    values
    (v_revision_id, new__caption, new__story, new__title);

    if new__is_live = ''t'' then
       PERFORM content_item__set_live_revision (v_revision_id);
    end if;

    return v_item_id;
end; ' language 'plpgsql';

-- procedure delete_revision
-- drop function pa_photo__delete_revision (integer);

create or replace function pa_photo__delete_revision (integer) 
returns integer as '
declare
    revision_id		alias for $1;

    -- do not need to delete from the pa_photos
    -- the on delete cascade will take care of this
    -- during the content_revision.delete
begin
   PERFORM content_revision__delete (revision_id);
   return 0; 
end; ' language 'plpgsql';

-- procedure delete
-- drop function pa_photo__delete (integer);

create or replace function pa_photo__delete (integer) 
returns integer as '
declare
    del__item_id	alias for $1;
    v_rec		record;
begin
    for v_rec in 
	select child_id
	from cr_child_rels
	where parent_id = del__item_id
    LOOP
	PERFORM image__delete (v_rec.child_id);
    end loop;

    -- content_item__delete takes care of all revisions
    -- on delete cascades take care of rest

    PERFORM content_item__delete (del__item_id);

    return 0; 
end; ' language 'plpgsql';


/*
-- Creates a new pa_album
*/
-- drop function pa_album__new (varchar, integer, integer, boolean, integer, varchar, varchar, varchar, text, integer, timestamptz, varchar, integer, timestamptz, varchar);

create or replace function pa_album__new (varchar, integer, integer, boolean, integer, varchar, varchar, varchar, text, varchar, integer, timestamptz, varchar, integer, timestamptz, varchar) 
returns integer as '
  declare
    new__name		alias for $1;
    new__album_id       alias for $2;
    new__parent_id	alias for $3; -- default null
    new__is_live	alias for $4; -- default f
    new__creation_user  alias for $5; -- default null
    new__creation_ip    alias for $6; -- default null
    new__title		alias for $7; -- default null
    new__description    alias for $8; -- default null
    new__story	        alias for $9; -- default null	
    new__photographer   alias for $10; -- default null	
    new__revision_id    alias for $11; -- default null
    new__creation_date  alias for $12; -- default now()
    new__locale		alias for $13; -- default null
    new__context_id	alias for $14; -- default null
    new__publish_date   alias for $15; -- default now()
    new__nls_language   alias for $16; -- default null
    
    -- if we ever need another parameter space creation_date is the best bet
    -- new__creation_date	timestamp default now();
    new__content_type	varchar default ''pa_album'';
    new_relation_tag	varchar default null;
    new__mime_type	varchar default null;

    v_item_id       integer;
    v_revision_id   integer;
  begin
    v_item_id := content_item__new (
      new__name,
      new__parent_id,
      new__album_id,
      new__locale,
      new__creation_date,
      new__creation_user,	
      new__context_id,
      new__creation_ip,
      ''content_item'',
      new__content_type,
      null,
      null,
      null,
      null,
      null
    );

      -- not needed in the new call to content_item__new
      -- new__relation_tag,

    v_revision_id := content_revision__new (
      new__title,
      new__description,
      new__publish_date,
      new__mime_type,
      new__nls_language,
      null,
      v_item_id,
      new__revision_id,
      new__creation_date,
      new__creation_user,
      new__creation_ip
    );

    insert into pa_albums (pa_album_id, story, photographer)
    values 
    (v_revision_id, new__story, new__photographer);

    if new__is_live = ''t'' then
       PERFORM content_item__set_live_revision (v_revision_id);
    end if;

    return v_item_id;
end; ' language 'plpgsql';

--  procedure delete_revision
-- drop function pa_album__delete_revision (integer);

create or replace function pa_album__delete_revision (integer)
returns integer as '
declare
    revision_id		alias for $1;
  -- do not need to delete from the pa_albums
  -- the on delete cascade will take care of this
  -- during the content_revision.delete
begin
    PERFORM content_revision__delete (revision_id);
    return 0;    
end; ' language 'plpgsql';

-- procedure delete
-- drop function pa_album__delete (integer);

create or replace function pa_album__delete (integer) 
returns integer as '
declare
     v_album_id	    alias for $1;
     v_num_children integer;
begin
    -- check if album is empty (no rm -r *)
    select count(*) into v_num_children
    from cr_items 
    where parent_id = v_album_id;

    if v_num_children > 0 then
           raise exception ''The specified album % still contains photos.  An album must be empty before it can be deleted.'', album_id;
    end if;
    
    -- content_item.delete takes care of all revision
    -- on delete cascades take care of rest

    PERFORM content_item__delete (v_album_id);
    return 0;
end; ' language 'plpgsql';

/*
--  Package does not contain new or delete procedure because
--  it contains general funcition for the photo album application
--  and is not tied to a specific object.
*/

-- drop function photo_album__get_root_folder (integer);

create or replace function photo_album__get_root_folder (integer) 
returns integer as '
declare
        v_package_id		alias for $1;
	v_folder_id		integer;
begin
 select coalesce(folder_id,0) into v_folder_id
 from pa_package_root_folder_map
 where package_id = v_package_id;

 if v_folder_id > 0 then
    return v_folder_id;
 else
    return null;
 end if;        
end; ' language 'plpgsql';

-- drop function photo_album__new_root_folder (integer);

create or replace function photo_album__new_root_folder (integer) 
returns integer as '
declare
        v_package_id		alias for $1;
	v_folder_id		pa_package_root_folder_map.folder_id%TYPE;
	v_package_name		apm_packages.instance_name%TYPE;
	v_package_key		apm_packages.package_key%TYPE;
begin
 select instance_name, package_key 
 into v_package_name, v_package_key
 from apm_packages
 where package_id = v_package_id;

 v_folder_id := content_folder__new (
 v_package_key || ''_'' || v_package_id, -- name
 v_package_name || '' Home'', -- label 
 ''Home for '' || v_package_name, -- description 
 null,         -- parent_id
 v_package_id, --context_id,
 null,         --folder_id
 now(),        --creation_date
 null,         --creation_user
 null          --creation_ip
 );

 insert into pa_package_root_folder_map 
 (package_id, folder_id)
 values 
 (v_package_id, v_folder_id);

 -- allow child items to be added
 PERFORM content_folder__register_content_type(v_folder_id,''pa_album'', ''f'');
 PERFORM content_folder__register_content_type(v_folder_id,''content_folder'', ''f'');

 return v_folder_id;
end; ' language 'plpgsql';

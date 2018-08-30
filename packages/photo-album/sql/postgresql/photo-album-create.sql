-- /packages/photo-album/sql/postgresql/photo-album-create.sql
--
-- data model to support ACS photo ablum application
--
-- Copyright (C) 2000-2001 ArsDigita Corporation
-- @author Tom Baginski (bags@arsdigita.com)
-- @creation-date 12/11/2000
--
-- @cvs-id $Id: photo-album-create.sql,v 1.4 2004/04/29 15:23:05 jeffd Exp $
--
-- This is free software distributed under the terms of the GNU Public
-- License.  Full text of the license is available from the GNU Project:
-- http://www.fsf.org/copyleft/gpl.html

-- ported by Walter McGinnis (wtem@olywa.net), 2001-06-10
-- the content repository has been changed to be similar 
-- to the original photo-album's storage scheme 
-- (i.e. not using blobs in the database)
-- replaced photo-album's non-standard storage with
-- content-repository's standard one
-- one the key's to it is the adjustment to the content_item__new constructor

create table pa_albums (
    pa_album_id	      integer 
		      constraint pa_albums_id_fk
		      references cr_revisions on delete cascade
		      constraint pa_albums_id_pk 
		      primary key,
    story	      text,
    photographer      varchar(200),
    taken_start       timestamp,
    taken_end         timestamp,
    iconic            integer 
                      constraint pa_albums_iconic_fk
                      references cr_items on delete set null
);

comment on table pa_albums is '
  Table for storing custom fields of albums within content repository.  
  A pa_album is used to group zero or more pa_photos.
';

comment on column pa_albums.story is '
  Story behind the album. In postgresql we use the text datatype
  and there is no limit on text length.  This differs from the varchar2 with
  Oracle.
';

comment on column pa_albums.iconic is '
        The photo to use as the cover photo for this album.  If it is null a
        default icon is chosen
';

comment on column pa_albums.photographer is '
        The photographer who took the pictures.
';

comment on column pa_albums.taken_start is '
        The date the photos were taken (start of range)
';

comment on column pa_albums.taken_start is '
        The date the photos were taken (end of range)
';


 -- create the content type
 select content_type__create_type (
   'pa_album',		     -- content_type
   'content_revision',	     -- supertype	
   'Photo album',	     -- pretty_name 
   'Photo albums',	     -- pretty_plural
   'pa_albums',		     -- table_name 
   'pa_album_id',	     -- id_column 
   null			     -- name_method
 );

 -- create content type attributes
 select content_type__create_attribute (
   'pa_album',		     -- content_type
   'story',		     -- attribute_name
   'text',		     -- datatype
   'Story',		     -- pretty_name
   'Stories',		     -- pretty_plural
   null,		     -- sort_order
   null,		     -- default_value
   'text'		     -- column_spec
 );

 select content_type__create_attribute (
   'pa_album',		     -- content_type
   'photographer',		     -- attribute_name
   'text',		     -- datatype
   'Photographer',		     -- pretty_name
   'Photographers',		     -- pretty_plural
   null,		     -- sort_order
   null,		     -- default_value
   'varchar(200)'	     -- column_spec
 );


create table pa_photos (
    pa_photo_id	      integer
                      constraint pa_photos_id_fk
                      references cr_revisions on delete cascade
                      constraint pa_photo_pk
                      primary key,
    caption	      varchar(500),
    story	      text,
    user_filename     varchar(250),
    camera_model      varchar(250),
    date_taken        timestamp,
    flash             boolean,
    focal_length      numeric,
    exposure_time     numeric,
    aperture          varchar(32),
    focus_distance    numeric,
    metering          varchar(100),
    sha256            varchar(64),
    photographer      varchar(200)
);

comment on table pa_photos is '
   Table for storing custom fields of photos within content repository.
   A pa_photo stores descriptive attribute information about a user
   uploaded photo.  The actually binary image files are stored using
   associated images.
';


--------------------------------------------------------------------------------
 select content_type__create_type (
   'pa_photo',		     -- content_type
   'content_revision',	     -- supertype	
   'Album photo',	     -- pretty_name 
   'Album photos',	     -- pretty_plural
   'pa_photos',		     -- table_name 
   'pa_photo_id',	     -- id_column 
   null			     -- name_method
 );

 select content_type__create_attribute (
   'pa_photo',		     -- content_type
   'story',		     -- attribute_name
   'text',		     -- datatype
   'Story',		     -- pretty_name
   'Stories',		     -- pretty_plural
   null,		     -- sort_order
   null,		     -- default_value
   'text'		     -- column_spec
 );

 select content_type__create_attribute (
   'pa_photo',		     -- content_type
   'caption',		     -- attribute_name
   'text',		     -- datatype
   'Short photo caption',		     -- pretty_name
   'Short photo captions',		     -- pretty_plural
   null,		     -- sort_order
   null,		     -- default_value
   'varchar(500)'	     -- column_spec
 );

 select content_type__create_attribute (
   'pa_photo',		     -- content_type
   'user_filename',	     -- attribute_name
   'text',		     -- datatype
   'User filename',	     -- pretty_name
   'User filenames',	     -- pretty_plural
   null,		     -- sort_order
   null,		     -- default_value
   'varchar(250)'	     -- column_spec
 );


--
-- JCD Added for exif data 2002-07-01 
-- 
 select content_type__create_attribute (
   'pa_photo',		     -- content_type
   'camera_model',	     -- attribute_name
   'text',		     -- datatype
   'Camera',		     -- pretty_name
   'Cameras',		     -- pretty_plural
   null,		     -- sort_order
   null,		     -- default_value
   'text'		     -- column_spec
 );

select content_type__create_attribute (
   'pa_photo',		     -- content_type
   'date_taken',             -- attribute_name
   'date',		     -- datatype
   'Date taken',	     -- pretty_name
   'Dates taken',	     -- pretty_plural
   null,		     -- sort_order
   null,		     -- default_value
   'timestamp'		     -- column_spec
 );

select content_type__create_attribute (
   'pa_photo',		     -- content_type
   'flash',                  -- attribute_name
   'boolean',		     -- datatype
   'Flash used',	     -- pretty_name
   'Flash used',	     -- pretty_plural
   null,		     -- sort_order
   null,		     -- default_value
   'boolean'		     -- column_spec
 );

select content_type__create_attribute (
   'pa_photo',		     -- content_type
   'exposure_time',                  -- attribute_name
   'number',		     -- datatype
   'Exposure time',	     -- pretty_name
   'Exposure times',	     -- pretty_plural
   null,		     -- sort_order
   null,		     -- default_value
   'numeric'		     -- column_spec
 );

select content_type__create_attribute (
   'pa_photo',		     -- content_type
   'aperture',                  -- attribute_name
   'string',		     -- datatype
   'Aperture',	     -- pretty_name
   'Apertures',	     -- pretty_plural
   null,		     -- sort_order
   null,		     -- default_value
   'varchar'		     -- column_spec
 );

select content_type__create_attribute (
   'pa_photo',		     -- content_type
   'focus_distance',                  -- attribute_name
   'number',		     -- datatype
   'Focus distance',	     -- pretty_name
   'Focus distances',	     -- pretty_plural
   null,		     -- sort_order
   null,		     -- default_value
   'numeric'		     -- column_spec
 );

select content_type__create_attribute (
   'pa_photo',		     -- content_type
   'metering',                  -- attribute_name
   'string',		     -- datatype
   'Metering',	     -- pretty_name
   'Meterings',	     -- pretty_plural
   null,		     -- sort_order
   null,		     -- default_value
   'varchar'		     -- column_spec
 );


select content_type__create_attribute (
   'pa_photo',		     -- content_type
   'sha256',                  -- attribute_name
   'string',		     -- datatype
   'SHA256',	     -- pretty_name
   'SHA256',	     -- pretty_plural
   null,		     -- sort_order
   null,		     -- default_value
   'varchar'		     -- column_spec
 );

 select content_type__create_attribute (
   'pa_photo',		     -- content_type
   'photographer',		     -- attribute_name
   'text',		     -- datatype
   'Photographer',		     -- pretty_name
   'Photographers',		     -- pretty_plural
   null,		     -- sort_order
   null,		     -- default_value
   'varchar(200)'	     -- column_spec
 );


  -- wtem@olywa.net, 2001-08-3
  -- now that we are going with the new content-repository
  -- storage of binaries
  -- we no longer need a specialized pa_image content_type
  -- it is now replaced by cr_revisions.content (which holds file name)
  -- file_size is now under cr_revisions.content_size
  -- we use the standar image content_type instead

  select content_type__register_child_type (
    'pa_album',		     -- parent_type 
    'pa_photo',		     -- child_type
    'generic',		     -- relation_tag
    0,			     -- min_n
    null		     -- max_n
  );

  select content_type__register_child_type (
    'pa_photo',		     -- parent_type
    'image',		     -- child_type
    'generic',		     -- relation_tag
    0,			     -- min_n
    null		     -- max_n
  );


create table pa_package_root_folder_map (
  package_id       integer
		   constraint pa_pack_fldr_map_pk
		   primary key
                   constraint pa_pack_fldr_map_pack_id_fk
		   references apm_packages on delete cascade,
  folder_id	   integer
		   constraint pa_pack_fldr_map_fldr_id_fk
        	   references cr_folders on delete cascade
		   constraint pa_pack_fldr_map_fldr_id_unq
		   unique
);

--There cannot be much if any benefit from this index.  
--create index pa_package_folder_map_by_pack on pa_package_root_folder_map (package_id, folder_id);


comment on table pa_package_root_folder_map is '
  Table to keep track of root folder for each instance of the photo-album
  Used for sub-site support.  Each instance of the photo album has a unique 
  root folder.  All folders, pa_albums, pa_photos, and images within the 
  package instance are descendants of the root folder.
  The one-to-one mapping is done using this table to avoid adding a column to the apm_packages
  that pertains only to the photo-album.
';

-- wtem@olywa.net, 2001-09-27
-- replaced non-standard pa_files_to_delete with new cr_files_to_delete calls

-- check for the two default acceptable mime_types in cr_mime_types
-- add them if necessary
-- drop function inline_0 ();

create function inline_0 () returns integer as '
declare
  v_count integer;
begin
  select count(*) into v_count from cr_mime_types where mime_type = ''image/jpeg'';

  if v_count = 0 then
    insert into cr_mime_types values (''JPEG image'', ''image/jpeg'', ''jpeg'');
  end if;

  select count(*) into v_count from cr_mime_types where mime_type = ''image/gif'';

  if v_count = 0 then
    insert into cr_mime_types values (''GIF image'', ''image/gif'', ''gif'');
  end if;

  select count(*) into v_count from cr_mime_types where mime_type = ''image/png'';

  if v_count = 0 then
    insert into cr_mime_types values (''PNG image'', ''image/png'', ''png'');
  end if;

  select count(*) into v_count from cr_mime_types where mime_type = ''image/tiff'';

  if v_count = 0 then
    insert into cr_mime_types values (''TIFF image'', ''image/tiff'', ''tiff'');
  end if;

  return 1;
end; ' language 'plpgsql';

select inline_0 ();

drop function inline_0 ();


-- 
-- A view to make getting the photo info out less horrible...
-- 
create view all_photo_images as select i.item_id, ccr.relation_tag, im.*, p.*
      from cr_items i,
           cr_items i2,
           pa_photos p,
           cr_child_rels ccr,
           images im
 where i.item_id = ccr.parent_id 
   and p.pa_photo_id = i.live_revision
   and ccr.child_id = i2.item_id
   and i2.live_revision = im.image_id;

\i permissions.sql
\i pl-pgsql.sql
\i photo-album-clip.sql

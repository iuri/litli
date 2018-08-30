-- /packages/photo-album/sql/photo-album-create.sql
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
    story   	      varchar2(4000),
    photographer      varchar2(200),
    taken_start       date,
    taken_end         date,
    iconic            integer 
                      constraint pa_albums_iconic_fk
                      references cr_items on delete set null
);

comment on table pa_albums is '
  Table for storing custom fields of albums within content repository.  
  A pa_album is used to group zero or more pa_photos.
';

comment on column pa_albums.story is '
  Story behind the album.
  This may be changed to a clob in the future if many people want to upload 
  stories longer than 4000 characters.  
  varchar2(4000) used for ease of development.
';

comment on column pa_albums.iconic is '
        The photo to use as the cover page photo for this album.  If it is null a
        default icon is chosen
';

comment on column pa_albums.photographer is '
        The photographer who took the pictures.
';

comment on column pa_albums.taken_start is '
        The date the photos were taken (start of range)
';

comment on column pa_albums.taken_end is '
        The date the photos were taken (end of range)
';
 
 

declare
 attr_id        acs_attributes.attribute_id%TYPE;
begin
 -- create the content type
 content_type.create_type (
   content_type  => 'pa_album',
   pretty_name   => 'Photo album',
   pretty_plural => 'Photo albums',
   table_name    => 'pa_albums',
   id_column     => 'pa_album_id'
 );

 -- create content type attributes
 attr_id := content_type.create_attribute (
   content_type   => 'pa_album',
   attribute_name => 'story',
   datatype       => 'text',
   pretty_name    => 'Story',
   pretty_plural  => 'Stories',
   column_spec    => 'varchar2(4000)'
 );

 attr_id := content_type.create_attribute (
   content_type   => 'pa_album',
   attribute_name => 'photographer',
   datatype       => 'text',
   pretty_name    => 'Photographer',
   pretty_plural  => 'Photographers',
   sort_order     => null,
   default_value  => null,
   column_spec    => 'varchar2(200)'
 );
 
end;
/
show errors


create table pa_photos (
    pa_photo_id	      integer
                      constraint pa_photos_id_fk
                      references cr_revisions on delete cascade
                      constraint pa_photo_pk
                      primary key,
    caption	          varchar2(500),
    story	          varchar2(4000),
    user_filename     varchar2(250),
    camera_model      varchar2(250),
    date_taken        date,
    flash             char(1),
    focal_length      number,
    exposure_time     number,
    aperture          varchar2(32),
    focus_distance    number,
    metering          varchar2(100),
    sha256            varchar2(64),
    photographer      varchar2(200)
);

comment on table pa_photos is '
   Table for storing custom fields of photos within content repository.
   A pa_photo stores descriptive attribute information about a user
   uploaded photo.  The actually binary image files are stored using
   associated images.
';

declare
 attr_id        acs_attributes.attribute_id%TYPE;
begin

 -- create the content type
 content_type.create_type (
   content_type  => 'pa_photo',
   pretty_name   => 'Album photo',
   pretty_plural => 'Album photos',
   table_name    => 'pa_photos',
   id_column     => 'pa_photo_id'
 );

 -- create content type attributes
 attr_id := content_type.create_attribute (
   content_type   => 'pa_photo',
   attribute_name => 'caption',
   datatype       => 'text',
   pretty_name    => 'Short photo caption',
   pretty_plural  => 'Short photo captions',
   column_spec    => 'varchar2(500)'
 );

 attr_id := content_type.create_attribute (
   content_type   => 'pa_photo',
   attribute_name => 'story',
   datatype       => 'text',
   pretty_name    => 'Story',
   pretty_plural  => 'Stories',
   column_spec    => 'varchar2(4000)'
 );

 attr_id := content_type.create_attribute (
   content_type   => 'pa_photo',
   attribute_name => 'user_filename',
   datatype       => 'text',
   pretty_name    => 'User filename',
   pretty_plural  => 'User filenames',
   column_spec    => 'varchar2(250)'
 );

--
-- JCD Added for exif data 2002-07-01 
-- 
  attr_id := content_type.create_attribute (
    content_type    =>   'pa_photo',		     
    attribute_name  =>   'camera_model',	     
    datatype        =>   'text',		     
    pretty_name     =>   'Camera',		     
    pretty_plural   =>   'Cameras',		     
    column_spec     =>   'varchar2(500)'		     
  );

  attr_id := content_type.create_attribute (
    content_type    =>   'pa_photo',		     
    attribute_name  =>   'date_taken',             
    datatype        =>   'date',		     
    pretty_name     =>   'Date taken',	     
    pretty_plural   =>   'Dates taken',	     
    column_spec     =>   'date'		     
  );

  attr_id := content_type.create_attribute (
    content_type    =>   'pa_photo',		     
    attribute_name  =>   'flash',                  
    datatype        =>   'boolean',		     
    pretty_name     =>   'Flash used',	     
    pretty_plural   =>   'Flash used',	     
    column_spec     =>   'char(1)'
  );

  attr_id := content_type.create_attribute (
    content_type    =>   'pa_photo',		     
    attribute_name  =>   'exposure_time',                  
    datatype        =>   'number',		     
    pretty_name     =>   'Exposure time',	     
    pretty_plural   =>   'Exposure times',	     
    column_spec     =>   'number'		     
  );

  attr_id := content_type.create_attribute (
    content_type    =>   'pa_photo',		     
    attribute_name  =>   'aperture',                  
    datatype        =>   'string',		     
    pretty_name     =>   'Aperture',	     
    pretty_plural   =>   'Apertures',	     
    column_spec     =>   'varchar2(100)'		     
  );

  attr_id := content_type.create_attribute (
    content_type    =>   'pa_photo',		     
    attribute_name  =>   'focus_distance',                  
    datatype        =>   'number',		     
    pretty_name     =>   'Focus distance',	     
    pretty_plural   =>   'Focus distances',	     
    column_spec     =>   'number'		     
  );

  attr_id := content_type.create_attribute (
    content_type    =>   'pa_photo',		     
    attribute_name  =>   'metering',                  
    datatype        =>   'string',		     
    pretty_name     =>   'Metering',	     
    pretty_plural   =>   'Meterings',	     
    column_spec     =>   'varchar2(100)'		     
  );

  attr_id := content_type.create_attribute (
    content_type    =>   'pa_photo',		     
    attribute_name  =>   'sha256',                  
    datatype        =>   'string',		     
    pretty_name     =>   'SHA256',	     
    pretty_plural   =>   'SHA256',	     
    column_spec     =>   'varchar2(100)'		     
  );

  attr_id := content_type.create_attribute (
    content_type    =>   'pa_photo',		     
    attribute_name  =>   'photographer',		     
    datatype        =>   'text',		     
    pretty_name     =>   'Photographer',		     
    pretty_plural   =>   'Photographers',		     
    column_spec     =>   'varchar2(200)'	     
  );

end;
/
show errors

-- wtem@olywa.net, 2001-08-3
  -- now that we are going with the new content-repository
  -- storage of binaries
  -- we no longer need a specialized pa_image content_type
     -- it is now replaced by cr_revisions.content (which holds file name)
     -- file_size is now under cr_revisions.content_size
  -- we use the standar image content_type instead

begin
  content_type.register_child_type (
    parent_type => 'pa_album',
    child_type => 'pa_photo'
  );

  content_type.register_child_type (
    parent_type => 'pa_photo',
    child_type => 'image'
  );
end;
/
show errors

create table pa_package_root_folder_map (
  package_id       constraint pa_pack_fldr_map_pk
        		   primary key
                   constraint pa_pack_fldr_map_pack_id_fk
        		   references apm_packages on delete cascade,
  folder_id 	   constraint pa_pack_fldr_map_fldr_id_fk
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

declare
  v_count int;
begin
  select count(*) into v_count from cr_mime_types where mime_type = 'image/jpeg';

  if v_count = 0 then
    insert into cr_mime_types values ('JPEG image', 'image/jpeg', 'jpg');
  end if;

  select count(*) into v_count from cr_mime_types where mime_type = 'image/gif';

  if v_count = 0 then
    insert into cr_mime_types values ('GIF image', 'image/gif', 'gif');
  end if;

  select count(*) into v_count from cr_mime_types where mime_type = 'image/png';

  if v_count = 0 then
    insert into cr_mime_types values ('PNG image', 'image/png', 'png');
  end if;

  select count(*) into v_count from cr_mime_types where mime_type = 'image/tiff';

  if v_count = 0 then
    insert into cr_mime_types values ('TIFF image', 'image/tiff', 'tiff');
  end if;
end;
/
show errors

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


@@ plsql-packages.sql

@@ permissions.sql

@@ photo-album-clip.sql

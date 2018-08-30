-- /packages/photo-album/sql/postgresql/upgrade-4.0.1-4.5.sql

-- upgrade to Jeff's version
-- @author Vinod Kurup (vinod@kurup.com)
-- @creation-date 2003-04-30
-- @cvs-id $Id: upgrade-4.0.1-4.5.sql,v 1.3 2003/11/20 13:03:54 jlaine Exp $

update cr_mime_types 
    set file_extension='jpg' 
    where mime_type='image/jpg';

\i ../photo-album-clip.sql

alter table pa_albums add photographer varchar(200);
alter table pa_albums add taken_start  timestamp;
alter table pa_albums add taken_end    timestamp;
alter table pa_albums add iconic       integer
                                       constraint pa_albums_iconic_fk
                                       references cr_items on delete set null;

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


alter table pa_photos add camera_model      varchar(250);
alter table pa_photos add date_taken        timestamp;
alter table pa_photos add flash             boolean;
alter table pa_photos add focal_length      numeric;
alter table pa_photos add exposure_time     numeric;
alter table pa_photos add aperture          varchar(32);
alter table pa_photos add focus_distance    numeric;
alter table pa_photos add metering          varchar(100);
alter table pa_photos add sha256            varchar(64);
alter table pa_photos add photographer      varchar(200);


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

\i ../pl-pgsql.sql

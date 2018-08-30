-- /packages/photo-album/sql/postgresql/upgrade-4.0.1-4.5.sql

-- upgrade to Jeff's version
-- @author Vinod Kurup (vinod@kurup.com)
-- @creation-date 2003-04-30
-- @cvs-id $Id: upgrade-4.0.1-4.5.sql,v 1.2 2003/11/20 13:03:54 jlaine Exp $

update cr_mime_types 
    set file_extension='jpg' 
    where mime_type='image/jpg';

@@ ../photo-album-clip.sql

alter table pa_albums add (
    photographer    varchar2(200),
    taken_start     date,
    taken_end       date,
    iconic          integer 
                    constraint pa_albums_iconic_fk
                    references cr_items on delete set null
);

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
 

declare
 attr_id        acs_attributes.attribute_id%TYPE;
begin
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
 

alter table pa_photos add (
    camera_model      varchar2(250),
    date_taken        date,
    flash             char(1),
    focal_length      number,
    exposure_time     number,
    aperture          varchar(32),
    focus_distance    number,
    metering          varchar2(100),
    sha256            varchar2(64),
    photographer      varchar2(200)
);


--
-- JCD Added for exif data 2002-07-01 
-- 
declare
  attr_id        acs_attributes.attribute_id%TYPE;
begin
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


@@ ../plsql-packages.sql

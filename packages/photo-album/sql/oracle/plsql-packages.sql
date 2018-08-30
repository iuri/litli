-- /packages/photo-album/sql/plsql-packages.sql
--
-- packages to support ACS photo ablum application
--
-- Copyright (C) 2000-2001 ArsDigita Corporation
-- @author Tom Baginski (bags@arsdigita.com)
-- @creation-date 01/08/2000
--
-- @cvs-id $Id: plsql-packages.sql,v 1.5 2005/03/12 22:06:45 andrewg Exp $
--
-- This is free software distributed under the terms of the GNU Public
-- License.  Full text of the license is available from the GNU Project:
-- http://www.fsf.org/copyleft/gpl.html

-- wtem@olywa.net, 2001-09-27
-- pa_image package now replaced with CR standard image package

create or replace package pa_photo
as
  --/**
  --  creates new pa_photo
  --  associated images must be created by calling script
  --*/
  function new (
    name		in cr_items.name%TYPE,
    parent_id		in cr_items.parent_id%TYPE default null,
    item_id		in acs_objects.object_id%TYPE default null,
    revision_id		in acs_objects.object_id%TYPE default null,
    content_type	in acs_object_types.object_type%TYPE default 'pa_photo',
    creation_date	in acs_objects.creation_date%TYPE default sysdate, 
    creation_user	in acs_objects.creation_user%TYPE default null, 
    creation_ip		in acs_objects.creation_ip%TYPE default null, 
    locale		in cr_items.locale%TYPE default null,
    context_id		in acs_objects.context_id%TYPE default null,
    title		in cr_revisions.title%TYPE default 'photo',
    description		in cr_revisions.description%TYPE default null,
    relation_tag	in cr_child_rels.relation_tag%TYPE default null,
    is_live		in char default 'f',
    publish_date	in cr_revisions.publish_date%TYPE default sysdate,
    mime_type		in cr_revisions.mime_type%TYPE default null,
    nls_language	in cr_revisions.nls_language%TYPE default null,
    caption		in pa_photos.caption%TYPE default null,
    story		in pa_photos.story%TYPE default null
  ) return cr_items.item_id%TYPE;

  --/**
  --  Deletes a single revision of a pa_photo
  --*/
  procedure delete_revision (
    revision_id		in acs_objects.object_id%TYPE
  );

  --/**
  --  Deletes a a pa_photo and all revisions,
  --  Deletes associated images (which schedules binary files for deleation)
  --
  --  Be careful, cannot be undone (easily)
  --*/
  procedure del (
    item_id             in acs_objects.object_id%TYPE
  );

end pa_photo;
/
show errors;

create or replace package body pa_photo
as
  function new (
    name		in cr_items.name%TYPE,
    parent_id		in cr_items.parent_id%TYPE default null,
    item_id		in acs_objects.object_id%TYPE default null,
    revision_id		in acs_objects.object_id%TYPE default null,
    content_type	in acs_object_types.object_type%TYPE default 'pa_photo',
    creation_date	in acs_objects.creation_date%TYPE default sysdate, 
    creation_user	in acs_objects.creation_user%TYPE default null, 
    creation_ip		in acs_objects.creation_ip%TYPE default null, 
    locale		in cr_items.locale%TYPE default null,
    context_id		in acs_objects.context_id%TYPE default null,
    title		in cr_revisions.title%TYPE default 'photo',
    description		in cr_revisions.description%TYPE default null,
    relation_tag	in cr_child_rels.relation_tag%TYPE default null,
    is_live		in char default 'f',
    publish_date	in cr_revisions.publish_date%TYPE default sysdate,
    mime_type		in cr_revisions.mime_type%TYPE default null,
    nls_language	in cr_revisions.nls_language%TYPE default null,
    caption		in pa_photos.caption%TYPE default null,
    story		in pa_photos.story%TYPE default null
  ) return cr_items.item_id%TYPE
  is
    v_item_id		cr_items.item_id%TYPE;
    v_revision_id	cr_revisions.revision_id%TYPE;
  begin
    
    v_item_id := content_item.new (
      name          => name,
      item_id	    => item_id,
      parent_id	    => parent_id,
      relation_tag  => relation_tag,
      content_type  =>  content_type,
      creation_date => sysdate,
      creation_user => creation_user,
      creation_ip   => creation_ip,
      locale	    => locale,
      context_id    => context_id
    );

    v_revision_id := content_revision.new (
      title => title,
      description   => description,
      item_id	    => v_item_id,
      revision_id   => revision_id,
      publish_date  => publish_date,
      mime_type	    => mime_type,
      nls_language  => nls_language,
      creation_date => sysdate,
      creation_user => creation_user,
      creation_ip   => creation_ip
    );

    insert into pa_photos
    (pa_photo_id, caption, story, user_filename)
    values
    (v_revision_id, caption, story, title);

    -- is_live => 't' not used as part of content_item.new
    -- because content_item.new does not let developer specify revision_id and doesn't return revision_id,
    -- revision_id needed for the insert to pa_photos

    if is_live = 't' then
       content_item.set_live_revision (
         revision_id => v_revision_id
    );
    end if;

    return v_item_id;
  end new;

  procedure delete_revision (
    revision_id		in acs_objects.object_id%TYPE
  )
  is

    -- do not need to delete from the pa_photos
    -- the on delete cascade will take care of this
    -- during the content_revision.delete
  begin
    content_revision.del (
      revision_id    => revision_id
    );

  end delete_revision;

  procedure del (
    item_id             in acs_objects.object_id%TYPE
  )
  is
    cursor pa_image_cur is
      select
        child_id
      from
        cr_child_rels
      where
        parent_id = pa_photo.del.item_id;

  begin
    
    -- delete all the images associated with the photo
    for v_pa_image_val in pa_image_cur loop
      image.del (
        item_id => v_pa_image_val.child_id
      );
    end loop;

    -- content_item.delete takes care of all revision
    -- on delete cascades take care of rest

    content_item.del (
      item_id   =>  item_id
    );

  end del;

end pa_photo;
/
show errors


create or replace package pa_album
as
  --/**
  -- Creates a new pa_album
  --*/
  function new (
     name           in cr_items.name%TYPE,
     album_id       in cr_items.item_id%TYPE default null,
     parent_id	    in cr_items.parent_id%TYPE default null,
     is_live	    in char default 'f',
     creation_user  in acs_objects.creation_user%TYPE default null, 
     creation_ip    in acs_objects.creation_ip%TYPE default null, 
     title  	    in cr_revisions.title%TYPE default null,
     description    in cr_revisions.description%TYPE default null,
     story  	    in pa_albums.story%TYPE default null,
     photographer   in pa_albums.photographer%TYPE default null,
     revision_id    in cr_revisions.revision_id%TYPE default null,
     creation_date  in acs_objects.creation_date%TYPE default sysdate, 
     locale 	    in cr_items.locale%TYPE default null,
     context_id	    in acs_objects.context_id%TYPE default null,
     publish_date   in cr_revisions.publish_date%TYPE default sysdate,
     nls_language   in cr_revisions.nls_language%TYPE default null,
     content_type   in acs_object_types.object_type%TYPE default 'pa_album',
     relation_tag   in cr_child_rels.relation_tag%TYPE default null,
     mime_type	    in cr_revisions.mime_type%TYPE default null
  ) return cr_items.item_id%TYPE;

  --/**
  -- Deletes a single revision of a pa_album
  --*/
  procedure delete_revision (
     revision_id    in cr_revisions.revision_id%TYPE
  );
  
  --/**
  -- Deletes a pa_album and all revisions
  -- Album must be empty to be deleted,
  -- otherwise delete throws error
  --*/
  procedure del (
     album_id	    in cr_items.item_id%TYPE
  );

end pa_album;
/
show errors

create or replace package body pa_album
as
  function new (
     name           in cr_items.name%TYPE,
     album_id       in cr_items.item_id%TYPE default null,
     parent_id	    in cr_items.parent_id%TYPE default null,
     is_live	    in char default 'f',
     creation_user  in acs_objects.creation_user%TYPE default null, 
     creation_ip    in acs_objects.creation_ip%TYPE default null, 
     title  	    in cr_revisions.title%TYPE default null,
     description    in cr_revisions.description%TYPE default null,
     story  	    in pa_albums.story%TYPE default null,
     photographer   in pa_albums.photographer%TYPE default null,
     revision_id    in cr_revisions.revision_id%TYPE default null,
     creation_date  in acs_objects.creation_date%TYPE default sysdate, 
     locale 	    in cr_items.locale%TYPE default null,
     context_id	    in acs_objects.context_id%TYPE default null,
     publish_date   in cr_revisions.publish_date%TYPE default sysdate,
     nls_language   in cr_revisions.nls_language%TYPE default null,
     content_type   in acs_object_types.object_type%TYPE default 'pa_album',
     relation_tag   in cr_child_rels.relation_tag%TYPE default null,
     mime_type	    in cr_revisions.mime_type%TYPE default null
  ) return cr_items.item_id%TYPE
  is
    v_item_id       integer;
    v_revision_id   integer;
  begin
    v_item_id := content_item.new (
      name          => name,
      item_id	    => album_id,
      parent_id	    => parent_id,
      relation_tag  => relation_tag,
      content_type  => content_type,
      creation_date => sysdate,
      creation_user => creation_user,
      creation_ip   => creation_ip,
      locale	    => locale,
      context_id    => context_id
    );

    v_revision_id := content_revision.new (
      title         => title,
      description   => description,
      item_id	    => v_item_id,
      revision_id   => revision_id,
      publish_date  => publish_date,
      mime_type	    => mime_type,
      nls_language  => nls_language,
      creation_date => sysdate,
      creation_user => creation_user,
      creation_ip   => creation_ip
    );

    insert into pa_albums (pa_album_id, story, photographer)
    values 
    (v_revision_id, story, photographer);

    if is_live = 't' then
       content_item.set_live_revision (
         revision_id => v_revision_id
    );
    end if;

    return v_item_id;

  end new;

  procedure delete_revision (
    revision_id		in cr_revisions.revision_id%TYPE
  )
  is
  -- do not need to delete from the pa_albums
  -- the on delete cascade will take care of this
  -- during the content_revision.delete
  begin
    content_revision.del (
      revision_id    => revision_id
    );

  end delete_revision;

  procedure del (
     album_id	    in cr_items.item_id%TYPE
  )
  is
    v_num_children integer;
  begin
    -- check if album is empty (no rm -r *)
    select count(*) into v_num_children
    from cr_items 
    where parent_id = pa_album.del.album_id;

    if v_num_children > 0 then
           raise_application_error(-20000,
          'The specified album ' || album_id || ' still contains photos.  
	  An album must be empty before it can be deleted.');
    end if;
    
    -- content_item.delete takes care of all revision
    -- on delete cascades take care of rest

    content_item.del (
      item_id   =>  album_id
    );

  end del;

end pa_album;
/
show errors

--/**
--  Package does not contain new or delete procedure because
--  it contains general funcition for the photo album application
--  and is not tied to a specific object.
--*/
create or replace package photo_album
as

    --/**
    -- Returns the root folder corresponding to a package instance.
    -- If root folder does not already exist, function returns null
    --
    -- tcl proc that calls this function from the index page
    -- takes care of the case that there is no root folder (new package instance)
    -- and creates one with appropriate permissions
    --*/

    function get_root_folder (
	package_id in apm_packages.package_id%TYPE
    ) return pa_package_root_folder_map.folder_id%TYPE;

    -- wtem@olywa.net, 2001-09-22
    -- wrapped up some pl-sql from tcl/photo-album-procs.tcl.pa_new_root_folder
    function new_root_folder (	
	package_id in apm_packages.package_id%TYPE
    ) return pa_package_root_folder_map.folder_id%TYPE;
    
end photo_album;
/
show errors

create or replace package body photo_album
as

    function get_root_folder (
        package_id in apm_packages.package_id%TYPE
    ) return pa_package_root_folder_map.folder_id%TYPE 
    is
	v_folder_id	pa_package_root_folder_map.folder_id%TYPE;
    begin
	
	-- this uses 0 as a magic number for
	-- no root folder
	-- in acs there will never be a folder with id 0

        select nvl(folder_id,0) into v_folder_id
	from pa_package_root_folder_map
	where package_id = get_root_folder.package_id;
        
	if v_folder_id > 0 then
	    return v_folder_id;
	else
	    return null;
	end if;

    end get_root_folder;

    function new_root_folder (	
	package_id in apm_packages.package_id%TYPE
    ) return pa_package_root_folder_map.folder_id%TYPE
    is 
    	v_folder_id     pa_package_root_folder_map.folder_id%TYPE;
	v_package_name  apm_packages.instance_name%TYPE;
	v_package_key   apm_packages.package_key%TYPE;
    begin

	select instance_name, package_key 
	into v_package_name, v_package_key
	from apm_packages
	where package_id = new_root_folder.package_id;

	v_folder_id := content_folder.new (
	name        => v_package_key || '_' || new_root_folder.package_id,
	label       => v_package_name || ' Home',
	description => 'Home for ' || v_package_name,
        context_id  => new_root_folder.package_id
	);

	insert into pa_package_root_folder_map 
	(package_id, folder_id)
	values 
	(new_root_folder.package_id, v_folder_id);

	-- allow child items to be added
        content_folder.register_content_type(v_folder_id,'pa_album');
        content_folder.register_content_type(v_folder_id,'content_folder');

	return v_folder_id;
    end new_root_folder;

end photo_album;
/
show errors

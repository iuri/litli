-- /packages/photo-album/sql/postgresql/photo-album-clip.sql
--
--
-- Extremely simple image clipboard to support photo
-- ordering and presentation generation
--
-- Oracle support added: vinod@kurup.com
-- 
-- Copyright (C) 2002 Jeff Davis
-- @author Jeff Davis davis@xarg.net
-- @creation-date 10/30/2002
--
-- @cvs-id $Id: photo-album-clip.sql,v 1.2 2003/09/30 12:10:09 mohanp Exp $
--
-- This is free software distributed under the terms of the GNU Public
-- License.  Full text of the license is available from the GNU Project:
-- http://www.fsf.org/copyleft/gpl.html

create table pa_collections ( 
    collection_id     integer 
		              constraint pa_collection_id_fk
        		      references acs_objects(object_id)
        		      constraint pa_collections_pk
        		      primary key,
    owner_id          integer
                      constraint pa_collections_owner_id_fk
                      references users(user_id) on delete cascade
                      constraint pa_collections_owner_id_nn
                      not null,
    title             varchar(255)
                      constraint  pa_collections_title_nn
                      not null
);

comment on table pa_collections is '
  Table for saving a collection of photos
';

create table pa_collection_photo_map (
   collection_id      integer
                      constraint pa_collections_fk
                      references pa_collections(collection_id) on delete cascade, 
   photo_id           integer 
                      constraint pa_photos_fk
                      references cr_items(item_id) on delete cascade,
   constraint pa_collection_photo_map_pk 
   primary key (collection_id, photo_id)
);

comment on table pa_collections is '
   Map a photo into the collection.
';


begin
    acs_object_type.create_type(
        object_type => 'photo_collection',
        pretty_name => 'Photo Collection',
        pretty_plural => 'Photo Collections',
        supertype => 'acs_object',
        table_name => 'pa_collections',
        id_column => 'collection_id'
    );
end;
/
show errors

create or replace package pa_collection
as
    function new (
        p_collection_id in pa_collections.collection_id%TYPE default null,
        p_owner_id      in pa_collections.owner_id%TYPE default null,
        p_title         in pa_collections.title%TYPE,
        p_creation_date in acs_objects.creation_date%TYPE default sysdate,
        p_creation_user in acs_objects.creation_user%TYPE default null,
        p_creation_ip   in acs_objects.creation_ip%TYPE default null,
        p_context_id    in acs_objects.context_id%TYPE default null
    ) return pa_collections.collection_id%TYPE;

    procedure del (
        p_collection_id       in pa_collections.collection_id%TYPE
    );

    function title (
        p_collection_id       in pa_collections.collection_id%TYPE
    ) return pa_collections.title%TYPE;

end pa_collection;
/
show errors

create or replace package body pa_collection
as
    function new (
        p_collection_id in pa_collections.collection_id%TYPE default null,
        p_owner_id      in pa_collections.owner_id%TYPE default null,
        p_title         in pa_collections.title%TYPE,
        p_creation_date in acs_objects.creation_date%TYPE default sysdate,
        p_creation_user in acs_objects.creation_user%TYPE default null,
        p_creation_ip   in acs_objects.creation_ip%TYPE default null,
        p_context_id    in acs_objects.context_id%TYPE default null
    ) return pa_collections.collection_id%TYPE
    is
        v_collection_id     pa_collections.collection_id%TYPE;
    begin
        v_collection_id := acs_object.new (
                object_id => p_collection_id,
                object_type => 'photo_collection',
                creation_date => p_creation_date,
                creation_user => p_creation_user,
                creation_ip => p_creation_ip,
                context_id => p_context_id
        );

        insert into pa_collections
          (collection_id, owner_id, title)
        values
          (v_collection_id, p_owner_id, p_title);

        acs_permission.grant_permission (
          v_collection_id,
          p_owner_id,
          'admin'
        );

        return v_collection_id;
    end new;


    procedure del (
        p_collection_id in pa_collections.collection_id%TYPE
    )
    is
    begin
        delete from acs_permissions
           where object_id = p_collection_id;

        delete from pa_collections
           where collection_id = p_collection_id;

        acs_object.del(p_collection_id);
    end del;


    function title (
        p_collection_id in pa_collections.collection_id%TYPE
    ) return pa_collections.title%TYPE
    is
        v_title             pa_collections.title%TYPE;
    begin
        select title into v_title
            from pa_collections
            where collection_id = p_collection_id;
        return v_title;
    end title;

end pa_collection;
/
show errors;

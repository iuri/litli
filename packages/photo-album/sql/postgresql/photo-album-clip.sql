-- /packages/photo-album/sql/postgresql/photo-album-clip.sql
--
--
-- Extremely simple image clipboard to support photo
-- ordering and presentation generation
-- 
-- Copyright (C) 2002 Jeff Davis
-- @author Jeff Davis davis@xarg.net
-- @creation-date 10/30/2002
--
-- @cvs-id $Id: photo-album-clip.sql,v 1.4 2004/03/17 11:00:48 jeffd Exp $
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


select acs_object_type__create_type(
        'photo_collection',
        'Photo Collection',
        'Photo Collections',
        'acs_object',
        'pa_collections',
        'collection_id',
        'photo_album',
        'f',
        null,
        'pa_collection__title'
    );


create or replace function pa_collection__new (integer,integer,varchar,timestamptz,integer,varchar,integer)
returns integer as '
declare
  p_collection_id                       alias for $1;       -- default null
  p_owner_id                            alias for $2;       -- default null
  p_title                               alias for $3;
  p_creation_date                       alias for $4;       -- default now()
  p_creation_user                       alias for $5;       -- default null
  p_creation_ip                         alias for $6;       -- default null
  p_context_id                          alias for $7;       -- default null
  v_collection_id                                     pa_collections.collection_id%TYPE;
begin
        v_collection_id := acs_object__new (
                p_collection_id,
                ''photo_collection'',
                p_creation_date,
                p_creation_user,
                p_creation_ip,
                p_context_id
        );

        insert into pa_collections
          (collection_id, owner_id, title)
        values
          (v_collection_id, p_owner_id, p_title);

        PERFORM acs_permission__grant_permission(
          v_collection_id,
          p_owner_id,
          ''admin''
    );

    return v_collection_id;

end;' language 'plpgsql';

create or replace function pa_collection__delete (integer)
returns integer as '
declare
  p_collection_id                             alias for $1;
begin
    delete from acs_permissions
           where object_id = p_collection_id;

    delete from pa_collections
           where collection_id = p_collection_id;

    raise NOTICE ''Deleting photo_collection...'';
    PERFORM acs_object__delete(p_collection_id);

    return 0;

end;' language 'plpgsql';


create or replace function pa_collection__title (integer)
returns varchar as '
declare
    p_collection_id        alias for $1;
    v_title           varchar;
begin
    select title into v_title
        from pa_collections
        where collection_id = p_collection_id;
    return v_title;
end;
' language 'plpgsql';


-- /packages/photo-album/sql/postgresql/pa-clip-drop.sql

-- drop the clip stuff
-- @author Vinod Kurup (vinod@kurup.com)
-- @creation-date 2003-04-30
-- @cvs-id $Id: pa-clip-drop.sql,v 1.2 2003/06/26 02:45:08 vinodk Exp $


create function tmp_pa_delete () 
returns integer as '
declare
  coll_rec RECORD;
begin
  for coll_rec in select object_id
      from acs_objects
      where object_type = ''photo_collection''
    loop
      PERFORM acs_object__delete (coll_rec.object_id);
    end loop;

    return 1;
end; ' language 'plpgsql';

select tmp_pa_delete ();

drop function tmp_pa_delete ();

select acs_object_type__drop_type('photo_collection', 'f');

drop function pa_collection__new (integer,integer,varchar,timestamptz,integer,varchar,integer);
drop function pa_collection__delete (integer);
drop function pa_collection__title (integer);

drop table pa_collection_photo_map;
drop table pa_collections;

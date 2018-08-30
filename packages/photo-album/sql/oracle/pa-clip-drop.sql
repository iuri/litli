-- /packages/photo-album/sql/oracle/pa-clip-drop.sql

-- drop the clip stuff
-- @author Vinod Kurup (vinod@kurup.com)
-- @creation-date 2003-04-30
-- @cvs-id $Id: pa-clip-drop.sql,v 1.2 2003/09/30 12:10:09 mohanp Exp $

declare
  cursor coll_cursor is
    select object_id
    from acs_objects
    where object_type = 'photo_collection';
  coll_val  coll_cursor%ROWTYPE;
begin
  for coll_val in coll_cursor
    loop
      acs_object.del (object_id  => coll_val.object_id);
    end loop;
end;
/
show errors;

begin
    acs_object_type.drop_type('photo_collection');
end;
/
show errors;

drop package pa_collection;

drop table pa_collection_photo_map;
drop table pa_collections;

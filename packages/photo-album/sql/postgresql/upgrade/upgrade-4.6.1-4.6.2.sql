-- few more PG 7.3 fixes
-- @author Vinod Kurup vinod@kurup.com
-- @cvs-id $Id: upgrade-4.6.1-4.6.2.sql,v 1.1 2003/06/26 02:45:08 vinodk Exp $

-- drop the old function
-- since the signature is new, 'create or replace' will create, not replace

drop function pa_collection__new (integer,integer,varchar,timestamp,integer,varchar,integer);

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
  v_collection_id                       pa_collections.collection_id%TYPE;
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


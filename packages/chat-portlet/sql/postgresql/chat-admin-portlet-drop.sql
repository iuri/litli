--
-- Copyright (C) 2004 University of Valencia
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--
--
--   Procedures to support the chat portlet
--
--   @author agustin (Agustin.Lopez@uv.es)
--   @creation-date 2004-10-10
--   @version $Id: chat-admin-portlet-drop.sql,v 0.1 2004/10/10



--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE  
  ds_id portal_datasources.datasource_id%TYPE;
BEGIN

  select datasource_id into ds_id
    from portal_datasources
    where name = 'chat_admin_portlet';

    if not found then
        raise exception 'No datasource_id found here ',ds_id ;
        ds_id := null;        
    end if;

      
  if ds_id is NOT null then
    perform portal_datasource__delete(ds_id);
  end if;

return 0;

END;
$$ LANGUAGE plpgsql;

select inline_0 ();

drop function inline_0 ();

-- create the implementation
select acs_sc_impl__delete (
                'portal_datasource',
                'chat_admin_portlet'
);

-- delete all the hooks
select acs_sc_impl_alias__delete (
               'portal_datasource',
               'chat_admin_portlet',
               'GetMyName'
);

select acs_sc_impl_alias__delete (
               'portal_datasource',
               'chat_admin_portlet',
               'GetPrettyName'
);

select acs_sc_impl_alias__delete (
               'portal_datasource',
               'chat_admin_portlet',
               'Link'
);

select acs_sc_impl_alias__delete (
               'portal_datasource',
               'chat_admin_portlet',
               'AddSelfToPage'
);

select acs_sc_impl_alias__delete (
               'portal_datasource',
               'chat_admin_portlet',
               'Show'
);

select acs_sc_impl_alias__delete (
               'portal_datasource',
               'chat_admin_portlet',
               'Edit'
);

select acs_sc_impl_alias__delete (
               'portal_datasource',
               'chat_admin_portlet',
               'RemoveSelfFromPage'
);

-- Add the binding
select acs_sc_binding__delete (
                'portal_datasource',
                'chat_admin_portlet'
);

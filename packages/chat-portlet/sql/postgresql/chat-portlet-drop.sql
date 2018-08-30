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
--   @version $Id: chat-portlet-drop.sql,v 0.1 2004/10/10



--
-- procedure inline_1/0
--
CREATE OR REPLACE FUNCTION inline_1(

) RETURNS integer AS $$
DECLARE  
  ds_id portal_datasources.datasource_id%TYPE;
BEGIN

  select datasource_id into ds_id
      from portal_datasources
     where name = 'chat_portlet';

   if not found then
     RAISE EXCEPTION ' No datasource id found ', ds_id;
     ds_id := null;
   end if;

  if ds_id is NOT null then
    perform portal_datasource__delete(ds_id);
  end if;

        -- drop the hooks
        perform acs_sc_impl_alias__delete (
               'portal_datasource',
               'chat_portlet',
               'GetMyName'
        );

        perform acs_sc_impl_alias__delete (
               'portal_datasource',
               'chat_portlet',
               'GetPrettyName'
        );


        perform acs_sc_impl_alias__delete (
               'portal_datasource',
               'chat_portlet',
               'Link'
        );

        perform acs_sc_impl_alias__delete (
               'portal_datasource',
               'chat_portlet',
               'AddSelfToPage'
        );

        perform acs_sc_impl_alias__delete (
               'portal_datasource',
               'chat_portlet',
               'Show'
        );

        perform acs_sc_impl_alias__delete (
               'portal_datasource',
               'chat_portlet',
               'Edit'
        );

        perform acs_sc_impl_alias__delete (
               'portal_datasource',
               'chat_portlet',
               'RemoveSelfFromPage'
        );

        -- Drop the binding
        perform acs_sc_binding__delete (
            'portal_datasource',
            'chat_portlet'
        );

        -- drop the impl
        perform acs_sc_impl__delete (
                'portal_datasource',
                'chat_portlet'
        );
        
        return 0;
END;
$$ LANGUAGE plpgsql;

select inline_1();
drop function inline_1();

\i chat-admin-portlet-drop.sql





--
--  Copyright (C) 2001, 2002 MIT
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
-- Drops the bulk-mail portlet
--
-- @author yon (yon@openforce.net)
-- @creation-date 2002-05-13
-- @version $Id: bm-portlet-drop.sql,v 1.3 2014/10/27 16:41:06 victorg Exp $
--
-- Postgresql port adarsh@symphinity.com
--  
-- 11th July 2002
--



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
    where name = 'bm_portlet';

    if not found then
        raise notice 'No datasource_id found here ', ds_id ;
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


select acs_sc_impl_alias__delete (
        'portal_datasource',
        'bm_portlet',
        'GetMyName'
);

select acs_sc_impl_alias__delete (
        'portal_datasource',
        'bm_portlet',
        'GetPrettyName'
);

select acs_sc_impl_alias__delete (
        'portal_datasource',
        'bm_portlet',
        'Link'
);

select acs_sc_impl_alias__delete (
        'portal_datasource',
        'bm_portlet',
        'AddSelfToPage'
);

select acs_sc_impl_alias__delete (
        'portal_datasource',
        'bm_portlet',
        'Show'
);

select acs_sc_impl_alias__delete (
        'portal_datasource',
        'bm_portlet',
        'Edit'
);

select acs_sc_impl_alias__delete (
        'portal_datasource',
        'bm_portlet',
        'RemoveSelfFromPage'
);

--drop the binding
select acs_sc_binding__delete (
        'portal_datasource',
        'bm_portlet'
);

--drop the impl
select acs_sc_impl__delete (
        'portal_datasource',
        'bm_portlet'
);

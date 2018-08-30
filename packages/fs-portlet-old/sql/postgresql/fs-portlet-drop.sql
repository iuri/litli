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
-- /fs-portlet/sql/oracle/fs-portlet-drop.sql
--

-- Drops fs portlet

-- @author Arjun Sanyal (arjun@openforce.net)
-- @creation-date 2001-30-09

-- $Id: fs-portlet-drop.sql,v 1.3 2014/10/27 16:41:41 victorg Exp $

-- This is free software distributed under the terms of the GNU Public
-- License version 2 or higher.  Full text of the license is available
-- from the GNU Project: http://www.fsf.org/copyleft/gpl.html



--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE  
  ds_id portal_datasources.datasource_id%TYPE;
BEGIN

--  begin 
    select datasource_id into ds_id
      from portal_datasources
     where name = 'fs-portlet';
--   exception when no_data_found then
--     ds_id := null;
--  end;

  if ds_id is not null then
    portal_datasource__delete(ds_id);
  end if;

return 0;
END;
$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();



--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE
	foo integer;
BEGIN

	-- drop the hooks
	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'fs-portlet',
	       'GetMyName'
	);

	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'fs-portlet',
	       'GetPrettyName'
	);


	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'fs-portlet',
	       'Link'
	);

	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'fs-portlet',
	       'AddSelfToPage'
	);

	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'fs-portlet',
	       'Show'
	);

	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'fs-portlet',
	       'Edit'
	);

	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'fs-portlet',
	       'RemoveSelfFromPage'
	);

	-- Drop the binding
	perform acs_sc_binding__delete (
	    'portal_datasource',
	    'fs-portlet'
	);

	-- drop the impl
	foo := acs_sc_impl__delete (
		'portal_datasource',
		'fs-portlet'
	);
	
	return 0;

END;
$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();


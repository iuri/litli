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
-- packages/dotlrn-portlet/sql/oracle/dotlrn-portlet-drop.sql
--

-- Drops dotlrn PE

-- @author Arjun Sanyal (arjun@openforce.net)
-- @creation-date 2001-30-09

-- $Id: dotlrn-portlet-drop.sql,v 1.4 2014/10/27 16:41:23 victorg Exp $

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
     where name = 'dotlrn-portlet';
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
-- procedure inline_1/0
--
CREATE OR REPLACE FUNCTION inline_1(

) RETURNS integer AS $$
DECLARE
	foo integer;
BEGIN

	-- add all the hooks
	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'dotlrn_portlet',
	       'GetMyName'
	);

	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'dotlrn_portlet',
	       'GetPrettyName'
	);


	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'dotlrn_portlet',
	       'Link'
	);

	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'dotlrn_portlet',
	       'AddSelfToPage'
	);

	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'dotlrn_portlet',
	       'Show'
	);

	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'dotlrn_portlet',
	       'Edit'
	);

	foo := acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'dotlrn_portlet',
	       'RemoveSelfFromPage'
	);

	-- Drop the binding
	perform acs_sc_binding__delete (
	   'portal_datasource',
	   'dotlrn_portlet'
	);

	-- drop the impl
	foo := acs_sc_impl__delete (
		'portal_datasource',
		'dotlrn_portlet'
	);

	return 0;

  return 0;

END;
$$ LANGUAGE plpgsql;

select inline_1();
drop function inline_1();



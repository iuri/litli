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
-- static-admin-portlet-drop.sql
--

-- Deletes a portal datasource for the static portlet factory
-- (admin interface)

-- Copyright (C) 2001 MIT
-- @author Arjun Sanyal (arjun@openforce.net)

-- $Id: static-admin-portlet-drop.sql,v 1.3 2014/10/27 16:41:55 victorg Exp $

-- This is free software distributed under the terms of the GNU Public
-- License version 2 or higher.  Full text of the license is available
-- from the GNU Project: http://www.fsf.org/copyleft/gpl.html
--
-- PostGreSQL port samir@symphinity.com 11 July 2002
--





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
     where name = 'static_admin_portlet';

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
	       'static_admin_portlet',
	       'GetMyName'
	);

	perform acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'static_admin_portlet',
	       'GetPrettyName'
	);


	perform acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'static_admin_portlet',
	       'Link'
	);

	perform acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'static_admin_portlet',
	       'AddSelfToPage'
	);

	perform acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'static_admin_portlet',
	       'Show'
	);

	perform acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'static_admin_portlet',
	       'Edit'
	);

	perform acs_sc_impl_alias__delete (
	       'portal_datasource',
	       'static_admin_portlet',
	       'RemoveSelfFromPage'
	);

	-- Drop the binding
	perform acs_sc_binding__delete (
	    'portal_datasource',
	    'static_admin_portlet'
	);

	-- drop the impl
	perform acs_sc_impl__delete (
		'portal_datasource',
		'static_admin_portlet'
	);
  	
	return 0;
END;
$$ LANGUAGE plpgsql;

select inline_1();
drop function inline_1();


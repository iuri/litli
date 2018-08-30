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
-- static-admin-portlet.sql
--

-- Creates a portal datasource for the static portlet factory 
-- (admin interface)

-- Copyright (C) 2001 MIT
-- @author Arjun Sanyal (arjun@openforce.net)

-- $Id: static-admin-portlet.sql,v 1.3 2014/10/27 16:41:55 victorg Exp $

-- This is free software distributed under the terms of the GNU Public
-- License version 2 or higher.  Full text of the license is available
-- from the GNU Project: http://www.fsf.org/copyleft/gpl.html
--
-- PostGreSQL port samir@symphinity.com 11 July 2002
--



--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE
  ds_id portal_datasources.datasource_id%TYPE;
BEGIN
  ds_id := portal_datasource__new(
    	'static_admin_portlet',											-- name
    	'Displays the admin interface for the static data portlets'		-- Description
  );

  -- 4 defaults procs

  -- shadeable_p 
  perform portal_datasource__set_def_param (
	ds_id,				-- datasource_id
	't',				-- config_required_p
	't',				-- configured_p
	'shadeable_p',		-- key
	'f'				-- value
);	

  -- shaded_p 
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	't',
	'shaded_p',
	'f'
);	

  -- hideable_p 
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	't',
	'hideable_p',
	't'
);	

  -- user_editable_p 
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	't',
	'user_editable_p',
	'f'
);	

  -- link_hideable_p 
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	't',
	'link_hideable_p',
	't'
);	


  -- static-admin-specific procs

  -- package_id must be configured
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	'f',
	'package_id',
	''
);	
  return 0;
END;
$$ LANGUAGE plpgsql;

select inline_0();

drop function inline_0();


CREATE OR REPLACE FUNCTION inline_1() RETURNS integer AS $$
BEGIN
	-- create the implementation
	perform acs_sc_impl__new (
		'portal_datasource',
		'static_admin_portlet',
		'static_admin_portlet'
	);

	-- add all the hooks
	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'static_admin_portlet',
	       'GetMyName',
	       'static_admin_portlet::get_my_name',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'static_admin_portlet',
	       'GetPrettyName',
	       'static_admin_portlet::get_pretty_name',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'static_admin_portlet',
	       'Link',
	       'static_admin_portlet::link',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'static_admin_portlet',
	       'AddSelfToPage',
	       'static_admin_portlet::add_self_to_page',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'static_admin_portlet',
	       'Show',
	       'static_admin_portlet::show',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'static_admin_portlet',
	       'Edit',
	       'static_admin_portlet::edit',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'static_admin_portlet',
	       'RemoveSelfFromPage',
	       'static_admin_portlet::remove_self_from_page',
	       'TCL'
	);

	-- Add the binding
	perform acs_sc_binding__new (
	    'portal_datasource',			-- contract_name 
	    'static_admin_portlet'			-- impl_name
	);

  	return 0;
END;
$$ LANGUAGE plpgsql;

select inline_1();

drop function inline_1();

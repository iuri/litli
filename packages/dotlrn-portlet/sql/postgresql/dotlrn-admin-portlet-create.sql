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
-- packages/dotlrn-portlet/sql/oracle/dotlrn-portlets-create.sql
--

-- Creates dotlrn admin datasource

-- Copyright (C) 2001 MIT
-- @author Arjun Sanyal (arjun@openforce.net)
-- @author Ben Adida (ben@openforce.net)   
-- @creation-date 2002-01-19

-- $Id: dotlrn-admin-portlet-create.sql,v 1.4 2014/10/27 16:41:22 victorg Exp $

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
  ds_id := portal_datasource__new(
         'dotlrn_admin_portlet',
         'Displays the dotlrn community admin info '
  );



  -- 4 defaults procs

  -- shadeable_p 
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	't',
	'shadeable_p',
	'f'
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
	'f'
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

  -- portlet-specific procs

  -- community_id must be configured!
  perform portal_datasource__set_def_param (
	ds_id,
	't',
	'f',
	'community_id',
	''
);	

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
	-- create the implementation
	foo := acs_sc_impl__new (
		'portal_datasource',
		'dotlrn_admin_portlet',
		'dotlrn_admin_portlet'
	);

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

	-- add all the hooks
	foo := acs_sc_impl_alias__new (
	       'portal_datasource',
	       'dotlrn_admin_portlet',
	       'GetMyName',
	       'dotlrn_admin_portlet::get_my_name',
	       'TCL'
	);

	foo := acs_sc_impl_alias__new (
	       'portal_datasource',
	       'dotlrn_admin_portlet',
	       'GetPrettyName',
	       'dotlrn_admin_portlet::get_pretty_name',
	       'TCL'
	);

	foo := acs_sc_impl_alias__new (
	       'portal_datasource',
	       'dotlrn_admin_portlet',
	       'Link',
	       'dotlrn_admin_portlet::link',
	       'TCL'
	);

	foo := acs_sc_impl_alias__new (
	       'portal_datasource',
	       'dotlrn_admin_portlet',
	       'AddSelfToPage',
	       'dotlrn_admin_portlet::add_self_to_page',
	       'TCL'
	);

	foo := acs_sc_impl_alias__new (
	       'portal_datasource',
	       'dotlrn_admin_portlet',
	       'Show',
	       'dotlrn_admin_portlet::show',
	       'TCL'
	);

	foo := acs_sc_impl_alias__new (
	       'portal_datasource',
	       'dotlrn_admin_portlet',
	       'Edit',
	       'dotlrn_admin_portlet::edit',
	       'TCL'
	);

	foo := acs_sc_impl_alias__new (
	       'portal_datasource',
	       'dotlrn_admin_portlet',
	       'RemoveSelfFromPage',
	       'dotlrn_admin_portlet::remove_self_from_page',
	       'TCL'
	);

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

	-- Add the binding
	perform acs_sc_binding__new (
	    'portal_datasource',
	    'dotlrn_admin_portlet'
	);

  return 0;

END;
$$ LANGUAGE plpgsql;
select inline_0();
drop function inline_0();


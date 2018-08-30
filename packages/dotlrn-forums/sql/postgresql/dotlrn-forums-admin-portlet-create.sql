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
-- packages/dotlrn-forums/sql/dotlrn-forums-portlets-create.sql
--

-- Creates the dotlrn forums admin datasources for portal portlets

-- This is a modified version of the standard forums admin portlet which includes
-- some admin UI options tied to dotlrn specific features.   The particular feature
-- that triggered the creation of this custom portlet is the optional autosubscribing
-- of dotlrn community members to a forum.

-- @author Don Baccus (arjun@openforce.net)
-- @creation-date 2002-08-29

-- $Id: dotlrn-forums-admin-portlet-create.sql,v 1.3 2014/10/27 16:41:19 victorg Exp $

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
         'dotlrn_forums_admin_portlet', --     name
         'Displays the dotlrn_forums_admin' --     description
  );

  -- 4 defaults procs

  -- shadeable_p 
  perform portal_datasource__set_def_param (
         ds_id, -- 	datasource_id
         't', -- 	config_required_p
         't', -- 	configured_p
         'shadeable_p', -- 	key
         'f' -- 	value
  );	

  -- shaded_p 
  perform portal_datasource__set_def_param (
         ds_id, -- 	datasource_id
         't', -- 	config_required_p
         't', -- 	configured_p
         'shaded_p', -- 	key
         'f' -- 	value
  );	

  -- hideable_p 
  perform portal_datasource__set_def_param (
         ds_id, -- 	datasource_id
         't', -- 	config_required_p
         't', -- 	configured_p
         'hideable_p', -- 	key
         't' -- 	value
  );	

  -- user_editable_p 
  perform portal_datasource__set_def_param (
         ds_id, -- 	datasource_id
         't', -- 	config_required_p
         't', -- 	configured_p
         'user_editable_p', -- 	key
         'f' -- 	value
  );	

  -- link_hideable_p 
  perform portal_datasource__set_def_param (
         ds_id, -- 	datasource_id
         't', -- 	config_required_p
         't', -- 	configured_p
         'link_hideable_p', -- 	key
         't' -- 	value
  );	


  -- forums_admin-specific procs

  -- package_id must be configured
  perform portal_datasource__set_def_param (
         ds_id, -- 	datasource_id
         't', -- 	config_required_p
         'f', -- 	configured_p
         'package_id', -- 	key
         '' -- 	value
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
	perform acs_sc_impl__new (
		'portal_datasource',
		'dotlrn_forums_admin_portlet',
		'dotlrn_forums_admin_portlet'
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
	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'dotlrn_forums_admin_portlet',
	       'GetMyName',
	       'dotlrn_forums_admin_portlet::get_my_name',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'dotlrn_forums_admin_portlet',
	       'GetPrettyName',
	       'dotlrn_forums_admin_portlet::get_pretty_name',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'dotlrn_forums_admin_portlet',
	       'Link',
	       'dotlrn_forums_admin_portlet::link',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'dotlrn_forums_admin_portlet',
	       'AddSelfToPage',
	       'dotlrn_forums_admin_portlet::add_self_to_page',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'dotlrn_forums_admin_portlet',
	       'Show',
	       'dotlrn_forums_admin_portlet::show',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'dotlrn_forums_admin_portlet',
	       'Edit',
	       'dotlrn_forums_admin_portlet::edit',
	       'TCL'
	);

	perform acs_sc_impl_alias__new (
	       'portal_datasource',
	       'dotlrn_forums_admin_portlet',
	       'RemoveSelfFromPage',
	       'dotlrn_forums_admin_portlet::remove_self_from_page',
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
                'portal_datasource', -- 	    contract_name
                'dotlrn_forums_admin_portlet' -- 	    impl_name
	);
  return 0;

END;
$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();

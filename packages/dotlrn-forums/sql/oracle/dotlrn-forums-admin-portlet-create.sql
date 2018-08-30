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
-- @creation-date 2002-29-08

-- $Id: dotlrn-forums-admin-portlet-create.sql,v 1.4 2003/09/30 13:11:40 mohanp Exp $

-- This is free software distributed under the terms of the GNU Public
-- License version 2 or higher.  Full text of the license is available
-- from the GNU Project: http://www.fsf.org/copyleft/gpl.html

declare
  ds_id portal_datasources.datasource_id%TYPE;
begin
  ds_id := portal_datasource.new(
    name             => 'dotlrn_forums_admin_portlet',
    description      => 'Displays the dotlrn_forums_admin'
  );

  -- 4 defaults procs

  -- shadeable_p 
  portal_datasource.set_def_param (
	datasource_id => ds_id,
	config_required_p => 't',
	configured_p => 't',
	key => 'shadeable_p',
	value => 'f'
);	

  -- shaded_p 
  portal_datasource.set_def_param (
	datasource_id => ds_id,
	config_required_p => 't',
	configured_p => 't',
	key => 'shaded_p',
	value => 'f'
);	

  -- hideable_p 
  portal_datasource.set_def_param (
	datasource_id => ds_id,
	config_required_p => 't',
	configured_p => 't',
	key => 'hideable_p',
	value => 't'
);	

  -- user_editable_p 
  portal_datasource.set_def_param (
	datasource_id => ds_id,
	config_required_p => 't',
	configured_p => 't',
	key => 'user_editable_p',
	value => 'f'
);	

  -- link_hideable_p 
  portal_datasource.set_def_param (
	datasource_id => ds_id,
	config_required_p => 't',
	configured_p => 't',
	key => 'link_hideable_p',
	value => 't'
);	


  -- forums_admin-specific procs

  -- package_id must be configured
  portal_datasource.set_def_param (
	datasource_id => ds_id,
	config_required_p => 't',
	configured_p => 'f',
	key => 'package_id',
	value => ''
);	


end;
/
show errors


declare
	foo integer;
begin
	-- create the implementation
	foo := acs_sc_impl.new (
		impl_contract_name => 'portal_datasource',
		impl_name => 'dotlrn_forums_admin_portlet',
		impl_pretty_name => 'dotlrn_forums_admin_portlet',
		impl_owner_name => 'dotlrn_forums_admin_portlet'
	);

end;
/
show errors

declare
	foo integer;
begin

	-- add all the hooks
	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'dotlrn_forums_admin_portlet',
	       'GetMyName',
	       'dotlrn_forums_admin_portlet::get_my_name',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'dotlrn_forums_admin_portlet',
	       'GetPrettyName',
	       'dotlrn_forums_admin_portlet::get_pretty_name',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'dotlrn_forums_admin_portlet',
	       'Link',
	       'dotlrn_forums_admin_portlet::link',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'dotlrn_forums_admin_portlet',
	       'AddSelfToPage',
	       'dotlrn_forums_admin_portlet::add_self_to_page',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'dotlrn_forums_admin_portlet',
	       'Show',
	       'dotlrn_forums_admin_portlet::show',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'dotlrn_forums_admin_portlet',
	       'Edit',
	       'dotlrn_forums_admin_portlet::edit',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'dotlrn_forums_admin_portlet',
	       'RemoveSelfFromPage',
	       'dotlrn_forums_admin_portlet::remove_self_from_page',
	       'TCL'
	);

end;
/
show errors

declare
	foo integer;
begin

	-- Add the binding
	acs_sc_binding.new (
	    contract_name => 'portal_datasource',
	    impl_name => 'dotlrn_forums_admin_portlet'
	);
end;
/
show errors


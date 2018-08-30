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
--   @author Emma (eraffenne@innova.uned.es)
--   @creation-date 2006-01-04
--   @version $Id: chat-admin-portlet-create.sql,v 1.1 2006/03/14 12:23:37 emmar Exp $

declare
	ds_id portal_datasources.datasource_id%TYPE;
begin

	ds_id  := portal_datasource.new( 
		name		=> 'chat_admin_portlet', 
		description	=> 'Chat Admin portlet'
	);


--  the standard 4 params

-- shadeable_p 
	portal_datasource.set_def_param (
		datasource_id 		=> ds_id,
		config_required_p 	=> 't',
		configured_p 		=> 't',
		key 				=> 'shadeable_p',
		value 				=> 'f'
	);      


-- hideable_p 
	portal_datasource.set_def_param (
		datasource_id 		=> ds_id,
		config_required_p 	=> 't',
		configured_p 		=> 't',
		key 				=> 'hideable_p',
		value 				=> 'f'
	);      

-- user_editable_p 
	portal_datasource.set_def_param (
		datasource_id 		=> ds_id,
		config_required_p 	=> 't',
		configured_p 		=> 't',
		key 				=> 'user_editable_p',
		value 				=> 'f'
	);      

-- shaded_p 
	portal_datasource.set_def_param (
		datasource_id 		=> ds_id,
		config_required_p 	=> 't',
		configured_p 		=> 't',
		key 				=> 'shaded_p',
		value 				=> 'f'
	);      

-- link_hideable_p 
	portal_datasource.set_def_param (
		datasource_id 		=> ds_id,
		config_required_p 	=> 't',
		configured_p 		=> 't',
		key 				=> 'link_hideable_p',
		value 				=> 't'
	);  

-- chat_admin-specific params

-- package_id must be configured
	portal_datasource.set_def_param (
		datasource_id 		=> ds_id,
		config_required_p 	=> 't',
		configured_p 		=> 'f',
		key 				=> 'package_id',
		value 				=> ''
	);

end;
/
show errors

declare
	v_impl_id acs_sc_impls.impl_id%TYPE;
begin

-- create the implementation
	v_impl_id := acs_sc_impl.new (
		impl_contract_name 	=> 'portal_datasource',
		impl_name 			=> 'chat_admin_portlet',
		impl_pretty_name 	=> 'Chat Admin portlet',
		impl_owner_name 	=> 'chat_admin_portlet'
	);

-- add all the hooks
	v_impl_id := acs_sc_impl_alias.new(
		impl_contract_name	=> 'portal_datasource',
		impl_name			=> 'chat_admin_portlet',
		impl_operation_name	=> 'GetMyName',
		impl_alias			=> 'chat_admin_portlet::get_my_name',
		impl_pl				=> 'TCL'
	);

	v_impl_id := acs_sc_impl_alias.new (
		impl_contract_name	=> 'portal_datasource',
		impl_name			=> 'chat_admin_portlet',
		impl_operation_name	=> 'GetPrettyName',
		impl_alias			=> 'chat_admin_portlet::get_pretty_name',
		impl_pl				=> 'TCL'
	);

	v_impl_id := acs_sc_impl_alias.new (
		impl_contract_name	=> 'portal_datasource',
		impl_name			=> 'chat_admin_portlet',
		impl_operation_name	=> 'Link',
		impl_alias			=> 'chat_admin_portlet::link',
		impl_pl				=> 'TCL'
	);

	v_impl_id := acs_sc_impl_alias.new (
		impl_contract_name	=> 'portal_datasource',
		impl_name			=> 'chat_admin_portlet',
		impl_operation_name	=> 'AddSelfToPage',
		impl_alias			=> 'chat_admin_portlet::add_self_to_page',
		impl_pl				=> 'TCL'
	);

	v_impl_id := acs_sc_impl_alias.new (
		impl_contract_name	=> 'portal_datasource',
		impl_name			=> 'chat_admin_portlet',
		impl_operation_name	=> 'Show',
		impl_alias			=> 'chat_admin_portlet::show',
		impl_pl				=> 'TCL'
	);

	v_impl_id := acs_sc_impl_alias.new (
		impl_contract_name	=> 'portal_datasource',
		impl_name			=> 'chat_admin_portlet',
		impl_operation_name	=> 'Edit',
		impl_alias			=> 'chat_admin_portlet::edit',
		impl_pl				=> 'TCL'
	);

	v_impl_id := acs_sc_impl_alias.new (
		impl_contract_name	=> 'portal_datasource',
		impl_name			=> 'chat_admin_portlet',
		impl_operation_name	=> 'RemoveSelfFromPage',
		impl_alias			=> 'chat_admin_portlet::remove_self_from_page',
		impl_pl				=> 'TCL'
	);

-- Add the binding
	acs_sc_binding.new (
		contract_name	=> 'portal_datasource',
		impl_name		=> 'chat_admin_portlet'
	);

end;
/
show errors

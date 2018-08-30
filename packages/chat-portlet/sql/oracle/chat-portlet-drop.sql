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
--   @version $Id: chat-portlet-drop.sql,v 1.1 2006/03/14 12:23:37 emmar Exp $

declare  
	ds_id portal_datasources.datasource_id%TYPE;
	v_impl_id acs_sc_impls.impl_id%TYPE;
begin

	select datasource_id into ds_id
	from portal_datasources
	where name = 'chat_portlet';

	if not found then
		RAISE EXCEPTION ' No datasource id found ', ds_id;
		ds_id := null;
	end if;

	if ds_id is NOT null then
		portal_datasource.del(ds_id);
	end if;

-- drop the hooks
	v_impl_id := acs_sc_impl_alias.del (
		impl_contract_name	=> 'portal_datasource',
		impl_name			=> 'chat_portlet',
		impl_operation_name	=> 'GetMyName'
	);

	v_impl_id := acs_sc_impl_alias.del (
		impl_contract_name	=> 'portal_datasource',
		impl_name			=> 'chat_portlet',
		impl_operation_name	=> 'GetPrettyName'
	);


	v_impl_id := acs_sc_impl_alias.del (
		impl_contract_name	=> 'portal_datasource',
		impl_name			=> 'chat_portlet',
		impl_operation_name	=> 'Link'
	);

	v_impl_id := acs_sc_impl_alias.del (
		impl_contract_name	=> 'portal_datasource',
		impl_name			=> 'chat_portlet',
		impl_operation_name	=> 'AddSelfToPage'
	);

	v_impl_id := acs_sc_impl_alias.del (
		impl_contract_name	=> 'portal_datasource',
		impl_name			=> 'chat_portlet',
		impl_operation_name	=> 'Show'
	);

	v_impl_id := acs_sc_impl_alias.del (
		impl_contract_name	=> 'portal_datasource',
		impl_name			=> 'chat_portlet',
		impl_operation_name	=> 'Edit'
	);

	v_impl_id := acs_sc_impl_alias.del (
		impl_contract_name	=> 'portal_datasource',
		impl_name			=> 'chat_portlet',
		impl_operation_name	=> 'RemoveSelfFromPage'
	);

-- Drop the binding
	acs_sc_binding.delete (
		contract_name	=> 'portal_datasource',
		impl_name		=> 'chat_portlet'
	);

-- drop the impl
	acs_sc_impl.del (
		impl_contract_name	=> 'portal_datasource',
		impl_name			=> 'chat_portlet'
	);

end;
/
show errors

@@ chat-admin-portlet-drop.sql

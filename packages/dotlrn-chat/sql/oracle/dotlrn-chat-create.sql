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
--   Procedures to support the dotlrn chat
--
--   @author Emma (eraffenne@innova.uned.es)
--   @creation-date 2006-01-04
--   @version $Id: dotlrn-chat-create.sql,v 1.1 2006/03/14 12:30:02 emmar Exp $

declare
	v_impl_id acs_sc_impls.impl_id%TYPE;
	v_impl_alias_id acs_sc_impl_aliases.impl_id%TYPE;
begin

-- create the implementation
	v_impl_id := acs_sc_impl.new (
                impl_contract_name	=> 'dotlrn_applet',
                impl_name			=> 'dotlrn_chat',
				impl_pretty_name	=> 'Chat applet',
                impl_owner_name		=> 'dotlrn_chat'
	);

-- add all the hooks

-- GetPrettyName
	v_impl_alias_id := acs_sc_impl_alias.new (
               impl_contract_name	=> 'dotlrn_applet',
               impl_name			=> 'dotlrn_chat',
               impl_operation_name	=> 'GetPrettyName',
               impl_alias			=> 'dotlrn_chat::get_pretty_name',
               impl_pl				=> 'TCL'
	);

-- AddApplet
	v_impl_alias_id := acs_sc_impl_alias.new (
               impl_contract_name	=> 'dotlrn_applet',
               impl_name			=> 'dotlrn_chat',
               impl_operation_name	=> 'AddApplet',
               impl_alias			=> 'dotlrn_chat::add_applet',
               impl_pl				=> 'TCL'
	);

-- RemoveApplet
	v_impl_alias_id := acs_sc_impl_alias.new (
               impl_contract_name	=> 'dotlrn_applet',
               impl_name			=> 'dotlrn_chat',
               impl_operation_name	=> 'RemoveApplet',
               impl_alias			=> 'dotlrn_chat::remove_applet',
               impl_pl				=> 'TCL'
	);

-- AddAppletToCommunity
	v_impl_alias_id := acs_sc_impl_alias.new (
               impl_contract_name	=> 'dotlrn_applet',
               impl_name			=> 'dotlrn_chat',
               impl_operation_name	=> 'AddAppletToCommunity',
               impl_alias			=> 'dotlrn_chat::add_applet_to_community',
               impl_pl				=> 'TCL'
	);

-- RemoveAppletFromCommunity
	v_impl_alias_id := acs_sc_impl_alias.new (
               impl_contract_name	=> 'dotlrn_applet',
               impl_name			=> 'dotlrn_chat',
               impl_operation_name	=> 'RemoveAppletFromCommunity',
               impl_alias			=> 'dotlrn_chat::remove_applet_from_community',
               impl_pl				=> 'TCL'
	);

-- AddUser
	v_impl_alias_id := acs_sc_impl_alias.new (
               impl_contract_name	=> 'dotlrn_applet',
               impl_name			=> 'dotlrn_chat',
               impl_operation_name	=> 'AddUser',
               impl_alias			=> 'dotlrn_chat::add_user',
               impl_pl				=> 'TCL'
	);

-- RemoveUser
	v_impl_alias_id := acs_sc_impl_alias.new (
               impl_contract_name	=> 'dotlrn_applet',
               impl_name			=> 'dotlrn_chat',
               impl_operation_name	=> 'RemoveUser',
               impl_alias			=> 'dotlrn_chat::remove_user',
               impl_pl				=> 'TCL'
	);

-- AddUserToCommunity
	v_impl_alias_id := acs_sc_impl_alias.new (
               impl_contract_name	=> 'dotlrn_applet',
               impl_name			=> 'dotlrn_chat',
               impl_operation_name	=> 'AddUserToCommunity',
               impl_alias			=> 'dotlrn_chat::add_user_to_community',
               impl_pl				=> 'TCL'
	);

-- RemoveUserFromCommunity
	v_impl_alias_id := acs_sc_impl_alias.new (
               impl_contract_name	=> 'dotlrn_applet',
               impl_name			=> 'dotlrn_chat',
               impl_operation_name	=> 'RemoveUserFromCommunity',
               impl_alias			=> 'dotlrn_chat::remove_user_from_community',
               impl_pl				=> 'TCL'
	);

-- AddPortlet
	v_impl_alias_id := acs_sc_impl_alias.new (
        impl_contract_name	=> 'dotlrn_applet',
        impl_name			=> 'dotlrn_chat',
        impl_operation_name	=> 'AddPortlet',
        impl_alias			=> 'dotlrn_chat::add_portlet',
        impl_pl				=> 'TCL'
    );

-- RemovePortlet
	v_impl_alias_id := acs_sc_impl_alias.new (
        impl_contract_name	=> 'dotlrn_applet',
        impl_name			=> 'dotlrn_chat',
        impl_operation_name	=> 'RemovePortlet',
        impl_alias			=> 'dotlrn_chat::remove_portlet',
        impl_pl				=> 'TCL'
	);

-- Clone
	v_impl_alias_id := acs_sc_impl_alias.new (
        impl_contract_name	=> 'dotlrn_applet',
        impl_name			=> 'dotlrn_chat',
        impl_operation_name	=> 'Clone',
        impl_alias			=> 'dotlrn_chat::clone',
        impl_pl				=> 'TCL'
	);

	v_impl_alias_id := acs_sc_impl_alias.new (
        impl_contract_name	=> 'dotlrn_applet',
        impl_name			=> 'dotlrn_chat',
        impl_operation_name	=> 'ChangeEventHandler',
        impl_alias			=> 'dotlrn_chat::change_event_handler',
        impl_pl				=> 'TCL'
	);

-- Add the binding
	acs_sc_binding.new (
            contract_name 	=> 'dotlrn_applet',
            impl_name		=> 'dotlrn_chat'
	);
end;
/
show errors

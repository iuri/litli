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
--   @version $Id: dotlrn-chat-drop.sql,v 1.1 2006/03/14 12:30:02 emmar Exp $

declare
	v_impl_id acs_sc_impls.impl_id%TYPE;
begin

	acs_sc_impl.del(
		impl_contract_name	=> 'dotlrn_applet',
		impl_name			=> 'dotlrn_chat'
	);


-- add all the hooks

-- GetPrettyName
	v_impl_id := acs_sc_impl_alias.del (
		impl_contract_name	=> 'dotlrn_applet',
		impl_name			=> 'dotlrn_chat',
		impl_operation_name	=> 'GetPrettyName'
	);

-- AddApplet
	v_impl_id := acs_sc_impl_alias.del (
		impl_contract_name	=> 'dotlrn_applet',
        impl_name			=> 'dotlrn_chat',
        impl_operation_name	=> 'AddApplet'
	);

-- RemoveApplet
	v_impl_id := acs_sc_impl_alias.del (
               impl_contract_name	=> 'dotlrn_applet',
               impl_name			=> 'dotlrn_chat',
               impl_operation_name	=> 'RemoveApplet'
	);

-- AddAppletToCommunity
	v_impl_id := acs_sc_impl_alias.del (
               impl_contract_name	=> 'dotlrn_applet',
               impl_name			=> 'dotlrn_chat',
               impl_operation_name	=> 'AddAppletToCommunity'
	);

-- RemoveAppletFromCommunity
	v_impl_id := acs_sc_impl_alias.del (
               impl_contract_name	=> 'dotlrn_applet',
               impl_name			=> 'dotlrn_chat',
               impl_operation_name	=> 'RemoveAppletFromCommunity'
	);

-- AddUser
	v_impl_id := acs_sc_impl_alias.del (
               impl_contract_name	=> 'dotlrn_applet',
               impl_name			=> 'dotlrn_chat',
               impl_operation_name	=> 'AddUser'
	);

-- RemoveUser
	v_impl_id := acs_sc_impl_alias.del (
               impl_contract_name	=> 'dotlrn_applet',
               impl_name			=> 'dotlrn_chat',
               impl_operation_name	=> 'RemoveUser'
	);

-- AddUserToCommunity
	v_impl_id := acs_sc_impl_alias.del (
               impl_contract_name	=> 'dotlrn_applet',
               impl_name			=> 'dotlrn_chat',
               impl_operation_name	=> 'AddUserToCommunity'
	);

-- RemoveUserFromCommunity
	v_impl_id := acs_sc_impl_alias.del (
               impl_contract_name	=> 'dotlrn_applet',
               impl_name			=> 'dotlrn_chat',
               impl_operation_name	=> 'RemoveUserFromCommunity'
	);

-- AddPortlet
	v_impl_id := acs_sc_impl_alias.del (
        impl_contract_name	=> 'dotlrn_applet',
        impl_name			=> 'dotlrn_chat',
        impl_operation_name	=> 'AddPortlet'
    );

-- RemovePortlet
	v_impl_id := acs_sc_impl_alias.del (
        impl_contract_name	=> 'dotlrn_applet',
        impl_name			=> 'dotlrn_chat',
        impl_operation_name	=> 'RemovePortlet'
	);

-- Clone
	v_impl_id := acs_sc_impl_alias.del (
        impl_contract_name	=> 'dotlrn_applet',
        impl_name			=> 'dotlrn_chat',
        impl_operation_name	=> 'Clone'
	);


-- Add the binding
	acs_sc_binding.del (
            contract_name	=> 'dotlrn_applet',
            impl_name		=> 'dotlrn_chat'
	);
end;
/
show errors

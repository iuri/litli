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
-- The "dotLRN members" applet for dotLRN
--
-- ben,arjun@openforce.net
--
-- 10/05/2001
--


declare
	foo integer;
begin
	-- create the implementation
	foo := acs_sc_impl.new (
		impl_contract_name => 'dotlrn_applet',
		impl_name => 'dotlrn_members',
		impl_pretty_name => 'dotlrn_members',
		impl_owner_name => 'dotlrn_members'
	);

	-- add all the hooks

	-- GetPrettyName
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_members',
	       'GetPrettyName',
	       'dotlrn_members::get_pretty_name',
	       'TCL'
	);

	-- AddApplet
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_members',
	       'AddApplet',
	       'dotlrn_members::add_applet',
	       'TCL'
	);

	-- RemoveApplet
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_members',
	       'RemoveApplet',
	       'dotlrn_members::remove_applet',
	       'TCL'
	);

	-- AddAppletToCommunity
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_members',
	       'AddAppletToCommunity',
	       'dotlrn_members::add_applet_to_community',
	       'TCL'
	);

	-- RemoveAppletFromCommunity
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_members',
	       'RemoveAppletFromCommunity',
	       'dotlrn_members::remove_applet_from_community',
	       'TCL'
	);

	-- AddUser
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_members',
	       'AddUser',
	       'dotlrn_members::add_user',
	       'TCL'
	);

	-- RemoveUser
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_members',
	       'RemoveUser',
	       'dotlrn_members::remove_user',
	       'TCL'
	);

	-- AddUserToCommunity
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_members',
	       'AddUserToCommunity',
	       'dotlrn_members::add_user_to_community',
	       'TCL'
	);

	-- RemoveUserFromCommunity
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_members',
	       'RemoveUserFromCommunity',
	       'dotlrn_members::remove_user_from_community',
	       'TCL'
	);

    -- AddPortlet
    foo := acs_sc_impl.new_alias (
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_members',
        impl_operation_name => 'AddPortlet',
        impl_alias => 'dotlrn_members::add_portlet',
        impl_pl => 'TCL'
    );

    -- RemovePortlet
    foo := acs_sc_impl.new_alias (
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_members',
        impl_operation_name => 'RemovePortlet',
        impl_alias => 'dotlrn_members::remove_portlet',
        impl_pl => 'TCL'
    );

    -- Clone
    foo := acs_sc_impl.new_alias (
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_members',
        impl_operation_name => 'Clone',
        impl_alias => 'dotlrn_members::clone',
        impl_pl => 'TCL'
    );

    foo := acs_sc_impl.new_alias (
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_members',
        impl_operation_name => 'ChangeEventHandler',
        impl_alias => 'dotlrn_members::change_event_handler',
        impl_pl => 'TCL'
    );

	-- Add the binding
	acs_sc_binding.new (
	    contract_name => 'dotlrn_applet',
	    impl_name => 'dotlrn_members'
	);
end;
/
show errors

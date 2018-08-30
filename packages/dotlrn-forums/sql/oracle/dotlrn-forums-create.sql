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
-- @author Ben Adida (ben@openforce.net)
-- @creation-date 2002-05-29
-- @version $Id: dotlrn-forums-create.sql,v 1.6 2003/09/30 13:11:40 mohanp Exp $
--
-- 10/05/2001
-- redone for Forums by Ben 05/29/2002
--


declare
	foo integer;
begin
	-- create the implementation
	foo := acs_sc_impl.new (
		impl_contract_name => 'dotlrn_applet',
		impl_name => 'dotlrn_forums',
		impl_pretty_name => 'dotlrn_forums',
		impl_owner_name => 'dotlrn_forums'
	);

	-- add all the hooks

	-- GetPrettyName
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_forums',
	       'GetPrettyName',
	       'dotlrn_forums::get_pretty_name',
	       'TCL'
	);

	-- AddApplet
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_forums',
	       'AddApplet',
	       'dotlrn_forums::add_applet',
	       'TCL'
	);

	-- RemoveApplet
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_forums',
	       'RemoveApplet',
	       'dotlrn_forums::remove_applet',
	       'TCL'
	);

	-- AddAppletToCommunity
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_forums',
	       'AddAppletToCommunity',
	       'dotlrn_forums::add_applet_to_community',
	       'TCL'
	);

	-- RemoveAppletFromCommunity
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_forums',
	       'RemoveAppletFromCommunity',
	       'dotlrn_forums::remove_applet_from_community',
	       'TCL'
	);
	-- AddUser
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_forums',
	       'AddUser',
	       'dotlrn_forums::add_user',
	       'TCL'
	);

	-- RemoveUser
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_forums',
	       'RemoveUser',
	       'dotlrn_forums::remove_user',
	       'TCL'
	);

	-- AddUserToCommunity
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_forums',
	       'AddUserToCommunity',
	       'dotlrn_forums::add_user_to_community',
	       'TCL'
	);

	-- RemoveUserFromCommunity
	foo := acs_sc_impl.new_alias (
	       'dotlrn_applet',
	       'dotlrn_forums',
	       'RemoveUserFromCommunity',
	       'dotlrn_forums::remove_user_from_community',
	       'TCL'
	);

    -- AddPortlet
    foo := acs_sc_impl.new_alias (
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_forums',
        impl_operation_name => 'AddPortlet',
        impl_alias => 'dotlrn_forums::add_portlet',
        impl_pl => 'TCL'
    );

    -- RemovePortlet
    foo := acs_sc_impl.new_alias (
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_forums',
        impl_operation_name => 'RemovePortlet',
        impl_alias => 'dotlrn_forums::remove_portlet',
        impl_pl => 'TCL'
    );

    -- Clone
    foo := acs_sc_impl.new_alias (
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_forums',
        impl_operation_name => 'Clone',
        impl_alias => 'dotlrn_forums::clone',
        impl_pl => 'TCL'
    );

    -- Change Event Handler

    foo := acs_sc_impl.new_alias(
        impl_contract_name => 'dotlrn_applet',
        impl_name => 'dotlrn_forums',
        impl_operation_name => 'ChangeEventHandler',
        impl_alias => 'dotlrn_forums::change_event_handler',
        impl_pl => 'TCL'
    );


	-- Add the binding
	acs_sc_binding.new (
	    contract_name => 'dotlrn_applet',
	    impl_name => 'dotlrn_forums'
	);
end;
/
show errors;

-- DRB: This is a bit of a hack but I can't really think of any reason why the dotlrn forums
-- applet should be forbidden from altering the forums table to track whether or not the
-- forum is an autosubscribe forum.  We don't want to modify the forums package itself
-- because autosubscription is very much a dotLRN feature inherited from SSV1.

-- An alternative would be to create an acs relationship to track which forums users should
-- be autosubscribed to, but each relationship is an object.  This is a heavyweight way to
-- accomplish something simple.

alter table forums_forums add (
    autosubscribe_p                 char(1)
                                    default 'f'
                                    constraint forums_autosubscribe_p_nn
                                    not null
                                    constraint forums_autosubscribe_p_ck
                                    check (autosubscribe_p in ('t','f'))
);

@dotlrn-forums-admin-portlet-create

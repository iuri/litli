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
-- ported to pg by dan chak (chak@openforce.net)
-- 2002-07-08



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
		'dotlrn_applet',
		'dotlrn_members_staff',
		'dotlrn_members_staff'
	);

	-- add all the hooks

	-- GetPrettyName
	foo := acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_members_staff',
	       'GetPrettyName',
	       'dotlrn_members_staff::get_pretty_name',
	       'TCL'
	);

	-- AddApplet
	foo := acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_members_staff',
	       'AddApplet',
	       'dotlrn_members_staff::add_applet',
	       'TCL'
	);

	-- RemoveApplet
	foo := acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_members_staff',
	       'RemoveApplet',
	       'dotlrn_members_staff::remove_applet',
	       'TCL'
	);

	-- AddAppletToCommunity
	foo := acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_members_staff',
	       'AddAppletToCommunity',
	       'dotlrn_members_staff::add_applet_to_community',
	       'TCL'
	);

	-- RemoveAppletFromCommunity
	foo := acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_members_staff',
	       'RemoveAppletFromCommunity',
	       'dotlrn_members_staff::remove_applet_from_community',
	       'TCL'
	);

	-- AddUser
	foo := acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_members_staff',
	       'AddUser',
	       'dotlrn_members_staff::add_user',
	       'TCL'
	);

	-- RemoveUser
	foo := acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_members_staff',
	       'RemoveUser',
	       'dotlrn_members_staff::remove_user',
	       'TCL'
	);

	-- AddUserToCommunity
	foo := acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_members_staff',
	       'AddUserToCommunity',
	       'dotlrn_members_staff::add_user_to_community',
	       'TCL'
	);

	-- RemoveUserFromCommunity
	foo := acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_members_staff',
	       'RemoveUserFromCommunity',
	       'dotlrn_members_staff::remove_user_from_community',
	       'TCL'
	);

    -- AddPortlet
    foo := acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_members_staff',
        'AddPortlet',
        'dotlrn_members_staff::add_portlet',
        'TCL'
    );

    -- RemovePortlet
    foo := acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_members_staff',
        'RemovePortlet',
        'dotlrn_members_staff::remove_portlet',
        'TCL'
    );

    -- Clone
    foo := acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_members_staff',
        'Clone',
        'dotlrn_members_staff::clone',
        'TCL'
    );

    foo := acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_members_staff',
        'ChangeEventHandler',
        'dotlrn_members_staff::change_event_handler',
        'TCL'
    );

	-- Add the binding
    perform acs_sc_binding__new (
	    'dotlrn_applet',
	    'dotlrn_members_staff'
	);

	return 0;

END;
$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();

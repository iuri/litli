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
-- The dotlrn applet for the STATIC data portlet
--
-- arjun@openforce.net
--
-- $Id: dotlrn-static-create.sql,v 1.4 2014/10/27 16:41:23 victorg Exp $
--
-- PostGreSQL port samir@symphinity.com 11 July 2002
--
CREATE OR REPLACE FUNCTION inline_0() RETURNS integer AS $$
BEGIN
	-- create the implementation
	perform acs_sc_impl__new (
		'dotlrn_applet',
		'dotlrn_static',
		'dotlrn_static'
	);

	-- add all the hooks

	-- GetPrettyName
	perform acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'GetPrettyName',
	       'dotlrn_static::get_pretty_name',
	       'TCL'
	);

	-- AddApplet
	perform acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'AddApplet',
	       'dotlrn_static::add_applet',
	       'TCL'
	);

	-- RemoveApplet
	perform acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'RemoveApplet',
	       'dotlrn_static::remove_applet',
	       'TCL'
	);

	-- AddAppletToCommunity
	perform acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'AddAppletToCommunity',
	       'dotlrn_static::add_applet_to_community',
	       'TCL'
	);

	-- RemoveAppletFromCommunity
	perform acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'RemoveAppletFromCommunity',
	       'dotlrn_static::remove_applet_from_community',
	       'TCL'
	);

	-- AddUser
	perform acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'AddUser',
	       'dotlrn_static::add_user',
	       'TCL'
	);

	-- RemoveUser
	perform acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'RemoveUser',
	       'dotlrn_static::remove_user',
	       'TCL'
	);

	-- AddUserToCommunity
	perform acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'AddUserToCommunity',
	       'dotlrn_static::add_user_to_community',
	       'TCL'
	);

	-- RemoveUserFromCommunity
	perform acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'RemoveUserFromCommunity',
	       'dotlrn_static::remove_user_from_community',
	       'TCL'
	);

    -- AddPortlet
	perform acs_sc_impl_alias__new (
        	'dotlrn_applet',									-- impl_contract_name
	        'dotlrn_static',									-- impl_name
 	      	'AddPortlet',										-- impl_operation_name
  	      	'dotlrn_static::add_portlet',						-- impl_alias
   	     	'TCL'												-- impl_pl
    	);
	
    -- RemovePortlet
	perform acs_sc_impl_alias__new (
     	   	'dotlrn_applet',
      	  	'dotlrn_static',
       	 	'RemovePortlet',
        	'dotlrn_static::remove_portlet',
        	'TCL'
    );

    -- Clone
    	perform acs_sc_impl_alias__new (
        	'dotlrn_applet',
        	'dotlrn_static',
        	'Clone',
        	'dotlrn_static::clone',
        	'TCL'
    	);

    perform acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_static',
        'ChangeEventHandler',
        'dotlrn_static::change_event_handler',
        'TCL'
    );

	-- Add the binding
	perform acs_sc_binding__new (
	    	'dotlrn_applet',
	    	'dotlrn_static'
	);
	return 0;
END;
$$ LANGUAGE plpgsql;

select inline_0();

drop function inline_0();


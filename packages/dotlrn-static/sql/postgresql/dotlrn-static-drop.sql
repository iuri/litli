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
-- $Id: dotlrn-static-drop.sql,v 1.3 2014/10/27 16:41:23 victorg Exp $
--
-- PostGreSQL port samir@symphinity.com 11 July 2002
--
CREATE OR REPLACE FUNCTION inline_0() RETURNS integer AS $$
BEGIN

	perform acs_sc_impl__delete(
	   'dotlrn_applet',		-- impl_contract_name
     'dotlrn_static'		-- impl_name
  );


-- delete all the hooks

-- GetPrettyName
	perform  acs_sc_impl_alias__delete (
	    'dotlrn_applet',
	    'dotlrn_static',
	    'GetPrettyName'
 );


	-- AddApplet
	perform  acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'AddApplet'
	);



	-- RemoveApplet
	perform  acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'RemoveApplet'
	);

	-- AddAppletToCommunity
	perform  acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'AddAppletToCommunity'
	);


	-- RemoveAppletFromCommunity
	perform  acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'RemoveAppletFromCommunity'
	);

	-- AddUser
	perform  acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'AddUser'
	);

	-- RemoveUser
	perform  acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'RemoveUser'
	);

	-- AddUserToCommunity
	perform  acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'AddUserToCommunity'
	);

	-- RemoveUserFromCommunity
	perform  acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_static',
	       'RemoveUserFromCommunity'
	);

    -- AddPortlet
	perform  acs_sc_impl_alias__delete (
        	'dotlrn_applet',									-- impl_contract_name
	        'dotlrn_static',									-- impl_name
 	      	'AddPortlet'  										-- impl_operation_name
    	);
	
    -- RemovePortlet
	perform  acs_sc_impl_alias__delete (
     	   	'dotlrn_applet',
     	  	'dotlrn_static',
       	 	'RemovePortlet'
    );

    -- Clone
	perform  acs_sc_impl_alias__delete (
        	'dotlrn_applet',
        	'dotlrn_static',
        	'Clone'
    	);


	-- Remove the binding
	perform acs_sc_binding__delete (
	    'dotlrn_applet',
	    'dotlrn_static'
		);

	RAISE NOTICE ' Finished deleting dotlrn-static sc....';
	
return 0;
END;
$$ LANGUAGE plpgsql;

select inline_0();

drop function inline_0();


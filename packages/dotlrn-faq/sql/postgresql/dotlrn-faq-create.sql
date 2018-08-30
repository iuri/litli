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
-- The faq applet for dotLRN
--
-- ben,arjun@openforce.net
--
-- 10/05/2001
--
-- Postgresql port adarsh@symphinity.com
--  
-- 10th July 2002
--


-- create the implementation

select acs_sc_impl__new (
		'dotlrn_applet',
		'dotlrn_faq',
		'dotlrn_faq'
);


-- add all the hooks

-- GetPrettyName
select acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'GetPrettyName',
	       'dotlrn_faq::get_pretty_name',
	       'TCL'
);

-- AddApplet
select acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'AddApplet',
	       'dotlrn_faq::add_applet',
	       'TCL'
);

-- RemoveApplet
select acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'RemoveApplet',
	       'dotlrn_faq::remove_applet',
	       'TCL'
);

-- AddAppletToCommunity
select acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'AddAppletToCommunity',
	       'dotlrn_faq::add_applet_to_community',
	       'TCL'
);

-- RemoveAppletFromCommunity
select acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'RemoveAppletFromCommunity',
	       'dotlrn_faq::remove_applet_from_community',
	       'TCL'
);

-- AddUser
select acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'AddUser',
	       'dotlrn_faq::add_user',
	       'TCL'
);

-- RemoveUser
select acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'RemoveUser',
	       'dotlrn_faq::remove_user',
	       'TCL'
);

-- AddUserToCommunity
select acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'AddUserToCommunity',
	       'dotlrn_faq::add_user_to_community',
	       'TCL'
);

-- RemoveUserFromCommunity
select acs_sc_impl_alias__new (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'RemoveUserFromCommunity',
	       'dotlrn_faq::remove_user_from_community',
	       'TCL'
);

-- AddPortlet
select acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_faq',
        'AddPortlet',
        'dotlrn_faq::add_portlet',
        'TCL'
);

-- RemovePortlet
select acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_faq',
        'RemovePortlet',
        'dotlrn_faq::remove_portlet',
        'TCL'
);

-- Clone
select acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_faq',
        'Clone',
        'dotlrn_faq::clone',
        'TCL'
);

select acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_faq',
        'ChangeEventHandler',
        'dotlrn_faq::change_event_handler',
        'TCL'
);

-- Add the binding
select acs_sc_binding__new (
	    'dotlrn_applet',
	    'dotlrn_faq'
);

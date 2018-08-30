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


-- delete the implementation

select acs_sc_impl__delete (
		'dotlrn_applet',
		'dotlrn_faq'
);




-- GetPrettyName
select acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'GetPrettyName'
);

-- AddApplet
select acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'AddApplet'
);

-- RemoveApplet
select acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'RemoveApplet'
);

-- AddAppletToCommunity
select acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'AddAppletToCommunity'
);

-- RemoveAppletFromCommunity
select acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'RemoveAppletFromCommunity'
);

-- AddUser
select acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'AddUser'
);

-- RemoveUser
select acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'RemoveUser'
);

-- AddUserToCommunity
select acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'AddUserToCommunity'
);

-- RemoveUserFromCommunity
select acs_sc_impl_alias__delete (
	       'dotlrn_applet',
	       'dotlrn_faq',
	       'RemoveUserFromCommunity'
);

-- AddPortlet
select acs_sc_impl_alias__delete (
        'dotlrn_applet',
        'dotlrn_faq',
        'AddPortlet'
);

-- RemovePortlet
select acs_sc_impl_alias__delete (
        'dotlrn_applet',
        'dotlrn_faq',
        'RemovePortlet'
);

-- Clone
select acs_sc_impl_alias__delete (
        'dotlrn_applet',
        'dotlrn_faq',
        'Clone'
);

-- Add the binding
select acs_sc_binding__delete (
	    'dotlrn_applet',
	    'dotlrn_faq'
);

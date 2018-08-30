--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or(at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- Creates the bulk-mail portlet
--
-- @author yon (yon@openforce.net)
-- @creation-date 2002-05-13
-- @version $Id: dotlrn-bm-create.sql,v 1.3 2002/08/09 18:39:27 yon Exp $
--
-- Postgresql port adarsh@symphinity.com
--  
-- 11th July 2002
--

select acs_sc_impl__new(
        'dotlrn_applet',					-- impl contract name
        'dotlrn_bm',						-- impl name 
        'dotlrn_bm'							-- impl owner name
);

select acs_sc_impl_alias__new(
        'dotlrn_applet',					-- impl contract name
        'dotlrn_bm',						-- impl name 
        'GetPrettyName',					-- impl operation name
        'dotlrn_bm::get_pretty_name',		-- impl alias
        'TCL'								-- impl pl
);

select acs_sc_impl_alias__new(
        'dotlrn_applet',
        'dotlrn_bm',
        'AddApplet',
        'dotlrn_bm::add_applet',
        'TCL'
);

select acs_sc_impl_alias__new(
        'dotlrn_applet',
        'dotlrn_bm',
        'RemoveApplet',
        'dotlrn_bm::remove_applet',
        'TCL'
);

select acs_sc_impl_alias__new(
        'dotlrn_applet',
        'dotlrn_bm',
        'AddAppletToCommunity',
        'dotlrn_bm::add_applet_to_community',
        'TCL'
);

select acs_sc_impl_alias__new(
        'dotlrn_applet',
        'dotlrn_bm',
        'RemoveAppletFromCommunity',
        'dotlrn_bm::remove_applet_from_community',
        'TCL'
);

select acs_sc_impl_alias__new(
        'dotlrn_applet',
        'dotlrn_bm',
        'AddUser',
        'dotlrn_bm::add_user',
        'TCL'
);

select acs_sc_impl_alias__new(
        'dotlrn_applet',
        'dotlrn_bm',
        'RemoveUser',
        'dotlrn_bm::remove_user',
        'TCL'
);

select acs_sc_impl_alias__new(
        'dotlrn_applet',
        'dotlrn_bm',
        'AddUserToCommunity',
        'dotlrn_bm::add_user_to_community',
        'TCL'
);

select acs_sc_impl_alias__new(
        'dotlrn_applet',
        'dotlrn_bm',
        'RemoveUserFromCommunity',
        'dotlrn_bm::remove_user_from_community',
        'TCL'
);

select acs_sc_impl_alias__new(
        'dotlrn_applet',
        'dotlrn_bm',
        'AddPortlet',
        'dotlrn_bm::add_portlet',
        'TCL'
);

select acs_sc_impl_alias__new(
        'dotlrn_applet',
        'dotlrn_bm',
        'RemovePortlet',
        'dotlrn_bm::remove_portlet',
        'TCL'
);

select acs_sc_impl_alias__new(
        'dotlrn_applet',     
        'dotlrn_bm',
        'Clone',
        'dotlrn_bm::clone',
        'TCL'
);

select acs_sc_impl_alias__new(
        'dotlrn_applet',     
        'dotlrn_bm',
        'ChangeEventHandler',
        'dotlrn_bm::change_event_handler',
        'TCL'
);

select acs_sc_binding__new(
        'dotlrn_applet',				--contract name			     	  
        'dotlrn_bm'						--impl name					   
);

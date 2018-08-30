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
-- Drops the bulk-mail portlet
--
-- @author yon (yon@openforce.net)
-- @creation-date 2002-05-13
-- @version $Id: dotlrn-bm-drop.sql,v 1.2 2002/08/09 18:39:27 yon Exp $
--
-- Postgresql port adarsh@symphinity.com
--  
-- 11th July 2002
--

select acs_sc_impl__delete(
        'dotlrn_applet',					-- impl contract name
        'dotlrn_bm'	 						-- impl name 
);

select acs_sc_impl_alias__delete(
        'dotlrn_applet',					-- impl contract name
        'dotlrn_bm',						-- impl name 
        'GetPrettyName'						-- impl operation name
);

select acs_sc_impl_alias__delete(
        'dotlrn_applet',
        'dotlrn_bm',
        'AddApplet'
);

select acs_sc_impl_alias__delete(
        'dotlrn_applet',
        'dotlrn_bm',
        'RemoveApplet'
);

select acs_sc_impl_alias__delete(
        'dotlrn_applet',
        'dotlrn_bm',
        'AddAppletToCommunity'
);

select acs_sc_impl_alias__delete(
        'dotlrn_applet',
        'dotlrn_bm',
        'RemoveAppletFromCommunity'
);

select acs_sc_impl_alias__delete(
        'dotlrn_applet',
        'dotlrn_bm',
        'AddUser'
);

select acs_sc_impl_alias__delete(
        'dotlrn_applet',
        'dotlrn_bm',
        'RemoveUser'
);

select acs_sc_impl_alias__delete(
        'dotlrn_applet',
        'dotlrn_bm',
        'AddUserToCommunity'
);

select acs_sc_impl_alias__delete(
        'dotlrn_applet',
        'dotlrn_bm',
        'RemoveUserFromCommunity'
);

select acs_sc_impl_alias__delete(
        'dotlrn_applet',
        'dotlrn_bm',
        'AddPortlet'
);

select acs_sc_impl_alias__delete(
        'dotlrn_applet',
        'dotlrn_bm',
        'RemovePortlet'
);

select acs_sc_impl_alias__delete(
        'dotlrn_applet',     
        'dotlrn_bm',
        'Clone'
);

select acs_sc_binding__delete(
        'dotlrn_applet',			     	   --contract name
        'dotlrn_bm'							   --impl name
);



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
--   @author agustin (Agustin.Lopez@uv.es)
--   @creation-date 2004-10-10
--   @version $Id: dotlrn-chat-drop.sql,v 0.1 2004/10/10

select acs_sc_impl__delete(
           'dotlrn_applet',             -- impl_contract_name
           'dotlrn_chat'                -- impl_name
);


-- add all the hooks

-- GetPrettyName
select acs_sc_impl_alias__delete (
               'dotlrn_applet',
               'dotlrn_chat',
               'GetPrettyName'
);

-- AddApplet
select acs_sc_impl_alias__delete (
               'dotlrn_applet',
               'dotlrn_chat',
               'AddApplet'
);

-- RemoveApplet
select acs_sc_impl_alias__delete (
               'dotlrn_applet',
               'dotlrn_chat',
               'RemoveApplet'
);

-- AddAppletToCommunity
select acs_sc_impl_alias__delete (
               'dotlrn_applet',
               'dotlrn_chat',
               'AddAppletToCommunity'
);

-- RemoveAppletFromCommunity
select acs_sc_impl_alias__delete (
               'dotlrn_applet',
               'dotlrn_chat',
               'RemoveAppletFromCommunity'
);

-- AddUser
select acs_sc_impl_alias__delete (
               'dotlrn_applet',
               'dotlrn_chat',
               'AddUser'
);

-- RemoveUser
select acs_sc_impl_alias__delete (
               'dotlrn_applet',
               'dotlrn_chat',
               'RemoveUser'
);

-- AddUserToCommunity
select acs_sc_impl_alias__delete (
               'dotlrn_applet',
               'dotlrn_chat',
               'AddUserToCommunity'
);

-- RemoveUserFromCommunity
select acs_sc_impl_alias__delete (
               'dotlrn_applet',
               'dotlrn_chat',
               'RemoveUserFromCommunity'
);

-- AddPortlet
select acs_sc_impl_alias__delete (
        'dotlrn_applet',
        'dotlrn_chat',
        'AddPortlet'
    );

-- RemovePortlet
select acs_sc_impl_alias__delete (
        'dotlrn_applet',
        'dotlrn_chat',
        'RemovePortlet'
);

-- Clone
select acs_sc_impl_alias__delete (
        'dotlrn_applet',
        'dotlrn_chat',
        'Clone'
);


-- Add the binding
select acs_sc_binding__delete (
            'dotlrn_applet',
            'dotlrn_chat'
);

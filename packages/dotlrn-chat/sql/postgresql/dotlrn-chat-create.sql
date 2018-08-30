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
--   @version $Id: dotlrn-chat-create.sql,v 0.1 2004/10/10

-- create the implementation
select acs_sc_impl__new (
                'dotlrn_applet',
                'dotlrn_chat',
                'dotlrn_chat'
);

-- add all the hooks

-- GetPrettyName
select acs_sc_impl_alias__new (
               'dotlrn_applet',
               'dotlrn_chat',
               'GetPrettyName',
               'dotlrn_chat::get_pretty_name',
               'TCL'
);

-- AddApplet
select acs_sc_impl_alias__new (
               'dotlrn_applet',
               'dotlrn_chat',
               'AddApplet',
               'dotlrn_chat::add_applet',
               'TCL'
);

-- RemoveApplet
select acs_sc_impl_alias__new (
               'dotlrn_applet',
               'dotlrn_chat',
               'RemoveApplet',
               'dotlrn_chat::remove_applet',
               'TCL'
);

-- AddAppletToCommunity
select acs_sc_impl_alias__new (
               'dotlrn_applet',
               'dotlrn_chat',
               'AddAppletToCommunity',
               'dotlrn_chat::add_applet_to_community',
               'TCL'
);

-- RemoveAppletFromCommunity
select acs_sc_impl_alias__new (
               'dotlrn_applet',
               'dotlrn_chat',
               'RemoveAppletFromCommunity',
               'dotlrn_chat::remove_applet_from_community',
               'TCL'
);

-- AddUser
select acs_sc_impl_alias__new (
               'dotlrn_applet',
               'dotlrn_chat',
               'AddUser',
               'dotlrn_chat::add_user',
               'TCL'
);

-- RemoveUser
select acs_sc_impl_alias__new (
               'dotlrn_applet',
               'dotlrn_chat',
               'RemoveUser',
               'dotlrn_chat::remove_user',
               'TCL'
);

-- AddUserToCommunity
select acs_sc_impl_alias__new (
               'dotlrn_applet',
               'dotlrn_chat',
               'AddUserToCommunity',
               'dotlrn_chat::add_user_to_community',
               'TCL'
);

-- RemoveUserFromCommunity
select acs_sc_impl_alias__new (
               'dotlrn_applet',
               'dotlrn_chat',
               'RemoveUserFromCommunity',
               'dotlrn_chat::remove_user_from_community',
               'TCL'
);

-- AddPortlet
select acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_chat',
        'AddPortlet',
        'dotlrn_chat::add_portlet',
        'TCL'
    );

-- RemovePortlet
select acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_chat',
        'RemovePortlet',
        'dotlrn_chat::remove_portlet',
        'TCL'
);

-- Clone
select acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_chat',
        'Clone',
        'dotlrn_chat::clone',
        'TCL'
);

select acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_chat',
        'ChangeEventHandler',
        'dotlrn_chat::change_event_handler',
        'TCL'
);

-- Add the binding
select acs_sc_binding__new (
            'dotlrn_applet',
            'dotlrn_chat'
);

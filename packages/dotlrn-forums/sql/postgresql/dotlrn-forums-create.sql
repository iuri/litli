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
-- The forums applet for dotLRN
--
-- @author Ben Adida (ben@openforce.net)
-- @creation-date 2002-05-29
-- @version $Id: dotlrn-forums-create.sql,v 1.5.2.1 2016/05/15 10:49:15 gustafn Exp $
--
-- ported to postgres by mohan pakkurti (mohan@pakkurti.com)
-- 2002-07-12
--

CREATE OR REPLACE FUNCTION inline_0() RETURNS integer AS $$
BEGIN

    perform acs_sc_impl__new (
        'dotlrn_applet',
        'dotlrn_forums',
        'dotlrn_forums'
    );

    perform acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_forums',
        'GetPrettyName',
        'dotlrn_forums::get_pretty_name',
        'TCL'
    );

    perform acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_forums',
        'AddApplet',
        'dotlrn_forums::add_applet',
        'TCL'
    );

    perform acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_forums',
        'RemoveApplet',
        'dotlrn_forums::remove_applet',
        'TCL'
    );

    perform acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_forums',
        'AddAppletToCommunity',
        'dotlrn_forums::add_applet_to_community',
        'TCL'
    );

    perform acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_forums',
        'RemoveAppletFromCommunity',
        'dotlrn_forums::remove_applet_from_community',
        'TCL'
    );

    perform acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_forums',
        'AddUser',
        'dotlrn_forums::add_user',
        'TCL'
    );

    perform acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_forums',
        'RemoveUser',
        'dotlrn_forums::remove_user',
        'TCL'
    );

    perform acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_forums',
        'AddUserToCommunity',
        'dotlrn_forums::add_user_to_community',
        'TCL'
    );

    perform acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_forums',
        'RemoveUserFromCommunity',
        'dotlrn_forums::remove_user_from_community',
        'TCL'
    );

    perform acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_forums',
        'AddPortlet',
        'dotlrn_forums::add_portlet',
        'TCL'
    );

    perform acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_forums',
        'RemovePortlet',
        'dotlrn_forums::remove_portlet',
        'TCL'
    );

    perform acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_forums',
        'Clone',
        'dotlrn_forums::clone',
        'TCL'
    );

    perform acs_sc_impl_alias__new (
        'dotlrn_applet',
        'dotlrn_forums',
        'ChangeEventHandler',
        'dotlrn_forums::change_event_handler',
        'TCL'
    );

    perform acs_sc_binding__new (
        'dotlrn_applet',
        'dotlrn_forums'
    );

    return 0;

END;
$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();

-- DRB: This is a bit of a hack but I can't really think of any reason why the dotlrn forums
-- applet should be forbidden from altering the forums table to track whether or not the
-- forum is an autosubscribe forum.  We don't want to modify the forums package itself
-- because autosubscription is very much a dotLRN feature inherited from SSV1.

-- An alternative would be to create an acs relationship to track which forums users should
-- be autosubscribed to, but each relationship is an object.  This is a heavyweight way to
-- accomplish something simple.

-- JCD: postgres won't let us do this all as one step like oracle will...
alter table forums_forums add autosubscribe_p  boolean;
update forums_forums set autosubscribe_p = false
 where autosubscribe_p is null;
alter table forums_forums alter column autosubscribe_p  SET DEFAULT false;

\i dotlrn-forums-admin-portlet-create.sql

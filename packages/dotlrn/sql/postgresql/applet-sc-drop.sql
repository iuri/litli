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
-- drop the dotLRN applet service contract
--
-- started October 1st, 2001
-- we remember September 11th
--
-- @author dan chak (chak@openforce.net)
-- porting to PG on 2002-07-01

CREATE OR REPLACE FUNCTION inline_0()  RETURNS integer AS $$
BEGIN

    perform acs_sc_operation__delete(
        'dotlrn_applet',
        'GetPrettyName'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.GetPrettyName.InputType'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.GetPrettyName.OutputType'
    );

    perform acs_sc_operation__delete(
        'dotlrn_applet',
        'AddApplet'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.AddApplet.InputType'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.AddApplet.OutputType'
    );

    perform acs_sc_operation__delete(
        'dotlrn_applet',
        'RemoveApplet'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.RemoveApplet.InputType'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.RemoveApplet.OutputType'
    );

    perform acs_sc_operation__delete(
        'dotlrn_applet',
        'AddAppletToCommunity'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.AddAppletToCommunity.InputType'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.AddAppletToCommunity.OutputType'
    );

    perform acs_sc_operation__delete(
        'dotlrn_applet',
        'RemoveAppletFromCommunity'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.RemoveAppletFromCommunity.InputType'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.RemoveAppletFromCommunity.OutputType'
    );

    perform acs_sc_operation__delete(
        'dotlrn_applet',
        'AddUser'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.AddUser.InputType'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.AddUser.OutputType'
    );

    perform acs_sc_operation__delete(
        'dotlrn_applet',
        'RemoveUser'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.RemoveUser.InputType'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.RemoveUser.OutputType'
    );

    perform acs_sc_operation__delete(
        'dotlrn_applet',
        'AddUserToCommunity'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.AddUserToCommunity.InputType'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.AddUserToCommunity.OutputType'
    );

    perform acs_sc_operation__delete(
        'dotlrn_applet',
        'RemoveUserFromCommunity'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.RemoveUserFromCommunity.InputType'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.RemoveUserFromCommunity.OutputType'
    );

    perform acs_sc_operation__delete(
        'dotlrn_applet',
        'AddPortlet'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.AddPortlet.InputType'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.AddPortlet.OutputType'
    );

    perform acs_sc_operation__delete(
        'dotlrn_applet',
        'RemovePortlet'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.RemovePortlet.InputType'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.RemovePortlet.OutputType'
    );

    perform acs_sc_operation__delete(
        'dotlrn_applet',
        'Clone'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.Clone.InputType'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.Clone.OutputType'
    );

    perform acs_sc_operation__delete(
        'dotlrn_applet',
        'ChangeEventHandler'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.ChangeEventHandler.InputType'
    );

    perform acs_sc_msg_type__delete(
        'dotlrn_applet.ChangeEventHandler.OutputType'
    );

    perform acs_sc_contract__delete(
        'dotlrn_applet'
    );

    return 0;

END;
$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();

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

declare
begin

    acs_sc_operation.del(
        contract_name => 'dotlrn_applet',
        operation_name => 'GetPrettyName'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.GetPrettyName.InputType'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.GetPrettyName.OutputType'
    );

    acs_sc_operation.del(
        contract_name => 'dotlrn_applet',
        operation_name => 'AddApplet'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.AddApplet.InputType'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.AddApplet.OutputType'
    );

    acs_sc_operation.del(
        contract_name => 'dotlrn_applet',
        operation_name => 'RemoveApplet'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.RemoveApplet.InputType'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.RemoveApplet.OutputType'
    );

    acs_sc_operation.del(
        contract_name => 'dotlrn_applet',
        operation_name => 'AddAppletToCommunity'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.AddAppletToCommunity.InputType'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.AddAppletToCommunity.OutputType'
    );

    acs_sc_operation.del(
        contract_name => 'dotlrn_applet',
        operation_name => 'RemoveAppletFromCommunity'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.RemoveAppletFromCommunity.InputType'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.RemoveAppletFromCommunity.OutputType'
    );

    acs_sc_operation.del(
        contract_name => 'dotlrn_applet',
        operation_name => 'AddUser'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.AddUser.InputType'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.AddUser.OutputType'
    );

    acs_sc_operation.del(
        contract_name => 'dotlrn_applet',
        operation_name => 'RemoveUser'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.RemoveUser.InputType'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.RemoveUser.OutputType'
    );

    acs_sc_operation.del(
        contract_name => 'dotlrn_applet',
        operation_name => 'AddUserToCommunity'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.AddUserToCommunity.InputType'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.AddUserToCommunity.OutputType'
    );

    acs_sc_operation.del(
        contract_name => 'dotlrn_applet',
        operation_name => 'RemoveUserFromCommunity'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.RemoveUserFromCommunity.InputType'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.RemoveUserFromCommunity.OutputType'
    );

    acs_sc_operation.del(
        contract_name => 'dotlrn_applet',
        operation_name => 'AddPortlet'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.AddPortlet.InputType'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.AddPortlet.OutputType'
    );

    acs_sc_operation.del(
        contract_name => 'dotlrn_applet',
        operation_name => 'RemovePortlet'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.RemovePortlet.InputType'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.RemovePortlet.OutputType'
    );

    acs_sc_operation.del(
        contract_name => 'dotlrn_applet',
        operation_name => 'Clone'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.Clone.InputType'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.Clone.OutputType'
    );

    acs_sc_operation.del(
        contract_name => 'dotlrn_applet',
        operation_name => 'ChangeEventHandler'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.ChangeEventHandler.InputType'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'dotlrn_applet.ChangeEventHandler.OutputType'
    );

    acs_sc_contract.del(
        contract_name => 'dotlrn_applet'
    );

end;
/
show errors

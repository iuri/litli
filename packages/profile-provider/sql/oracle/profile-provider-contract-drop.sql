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
-- Profile Provider interface definition
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: profile-provider-contract-drop.sql,v 1.4 2003/09/30 13:11:41 mohanp Exp $
--

declare
begin

    -- drop the methods of this interface

    -- name method
    acs_sc_operation.del(
        contract_name => 'profile_provider',
        operation_name => 'name'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'profile_provider.name.InputType'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'profile_provider.name.OutputType'
    );

    -- prettyName method
    acs_sc_operation.del(
        contract_name => 'profile_provider',
        operation_name => 'prettyName'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'profile_provider.prettyName.InputType'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'profile_provider.prettyName.OutputType'
    );

    -- render method
    acs_sc_operation.del(
        contract_name => 'profile_provider',
        operation_name => 'render'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'profile_provider.render.InputType'
    );

    acs_sc_msg_type.del(
        msg_type_name => 'profile_provider.render.OutputType'
    );

    -- create the interface
    acs_sc_contract.del(
        contract_name => 'profile_provider'
    );

end;
/
show errors

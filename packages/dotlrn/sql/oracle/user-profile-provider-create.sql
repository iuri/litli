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
-- Implementation of the profile provider interface for dotlrn users.
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: user-profile-provider-create.sql,v 1.4 2006/08/08 21:26:21 donb Exp $
--

declare
    foo                         integer;
begin

    -- create the implementation
    foo := acs_sc_impl.new(
        impl_contract_name => 'profile_provider',
        impl_name => 'dotlrn_user_profile_provider',
        impl_pretty_name => 'Dotlrn user profile provider',
        impl_owner_name => 'dotlrn_user_profile_provider'
    );

    -- add the bindings to the method implementations

        -- name method
        foo := acs_sc_impl.new_alias(
            impl_contract_name => 'profile_provider',
            impl_name => 'dotlrn_user_profile_provider',
            impl_operation_name => 'name',
            impl_alias => 'dotlrn_user_profile_provider::name',
            impl_pl => 'TCL'
        );

        -- prettyName method
        foo := acs_sc_impl.new_alias(
            impl_contract_name => 'profile_provider',
            impl_name => 'dotlrn_user_profile_provider',
            impl_operation_name => 'prettyName',
            impl_alias => 'dotlrn_user_profile_provider::prettyName',
            impl_pl => 'TCL'
        );

        -- render method
        foo := acs_sc_impl.new_alias(
            impl_contract_name => 'profile_provider',
            impl_name => 'dotlrn_user_profile_provider',
            impl_operation_name => 'render',
            impl_alias => 'dotlrn_user_profile_provider::render',
            impl_pl => 'TCL'
        );

    -- bind this implementation to the interface it implements
    acs_sc_binding.new(
        contract_name => 'profile_provider',
        impl_name => 'dotlrn_user_profile_provider'
    );

end;
/
show errors

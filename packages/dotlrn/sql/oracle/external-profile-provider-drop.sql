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
-- Implementation of the profile provider interface for dotLRN Externals.
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: external-profile-provider-drop.sql,v 1.4 2006/08/08 21:26:21 donb Exp $
--

declare
    foo                         integer;
begin

    -- drop the binding between this implementation and the interface it
    -- implements.
    acs_sc_binding.del(
        contract_name => 'profile_provider',
        impl_name => 'dotlrn_external_profile_provider'
    );

    -- drop the bindings to the method implementations

        -- name method
        foo := acs_sc_impl.delete_alias(
            impl_contract_name => 'profile_provider',
            impl_name => 'dotlrn_external_profile_provider',
            impl_operation_name => 'name'
        );

        -- prettyName method
        foo := acs_sc_impl.delete_alias(
            impl_contract_name => 'profile_provider',
            impl_name => 'dotlrn_external_profile_provider',
            impl_operation_name => 'prettyName'
        );

        -- render method
        foo := acs_sc_impl.delete_alias(
            impl_contract_name => 'profile_provider',
            impl_name => 'dotlrn_external_profile_provider',
            impl_operation_name => 'render'
        );

    -- drop the implementation
    acs_sc_impl.del(
        impl_contract_name => 'profile_provider',
        impl_name => 'dotlrn_external_profile_provider'
    );

end;
/
show errors

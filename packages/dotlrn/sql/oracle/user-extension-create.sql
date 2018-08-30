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
-- The dotLRN extension to user data notifications
--
-- @author Ben Adida (ben@openforce.net)
-- @creation-date 2002-01-22
--


declare
    foo integer;
begin

    -- create the implementation
    foo := acs_sc_impl.new (
        impl_contract_name => 'UserData',
        impl_name => 'dotlrn_user_extension',
        impl_pretty_name => 'Dotlrn user extension',
        impl_owner_name => 'dotlrn_user_extension'
    );

    -- UserNew
    foo := acs_sc_impl.new_alias (
        'UserData',
        'dotlrn_user_extension',
        'UserNew',
        'dotlrn_user_extension::user_new',
        'TCL'
    );

    -- UserNew
    foo := acs_sc_impl.new_alias (
        'UserData',
        'dotlrn_user_extension',
        'UserApprove',
        'dotlrn_user_extension::user_approve',
        'TCL'
    );

    -- UserNew
    foo := acs_sc_impl.new_alias (
        'UserData',
        'dotlrn_user_extension',
        'UserDeapprove',
        'dotlrn_user_extension::user_deapprove',
        'TCL'
    );

    -- UserNew
    foo := acs_sc_impl.new_alias (
        'UserData',
        'dotlrn_user_extension',
        'UserModify',
        'dotlrn_user_extension::user_modify',
        'TCL'
    );

    -- UserNew
    foo := acs_sc_impl.new_alias (
        'UserData',
        'dotlrn_user_extension',
        'UserDelete',
        'dotlrn_user_extension::user_delete',
        'TCL'
    );

    -- Add the binding
    acs_sc_binding.new (
        contract_name => 'UserData',
        impl_name => 'dotlrn_user_extension'
    );

end;
/
show errors

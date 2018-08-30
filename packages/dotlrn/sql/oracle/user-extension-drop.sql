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

    acs_sc_binding.del (
        contract_name => 'UserData',
        impl_name => 'dotlrn_user_extension'
    );

    foo := acs_sc_impl.delete_alias (
        'UserData',
        'dotlrn_user_extension',
        'UserNew'
    );

    foo := acs_sc_impl.delete_alias (
        'UserData',
        'dotlrn_user_extension',
        'UserApprove'
    );

    foo := acs_sc_impl.delete_alias (
        'UserData',
        'dotlrn_user_extension',
        'UserDeapprove'
    );

    foo := acs_sc_impl.delete_alias (
        'UserData',
        'dotlrn_user_extension',
        'UserModify'
    );

    foo := acs_sc_impl.delete_alias (
        'UserData',
        'dotlrn_user_extension',
        'UserDelete'
    );

    -- create the implementation
    acs_sc_impl.del(
        'UserData',
        'dotlrn_user_extension'
    );

end;
/
show errors

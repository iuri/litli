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
-- @author dan chak (chak@mit.edu)
-- @version $Id: user-extension-drop.sql,v 1.4 2013/11/01 21:08:29 gustafn Exp $
--
-- 
--

CREATE OR REPLACE FUNCTION inline_0()  RETURNS integer AS $$
BEGIN

    perform acs_sc_binding__delete (
        'UserData',
        'dotlrn_user_extension'
    );

    perform acs_sc_impl_alias__delete (
        'UserData',
        'dotlrn_user_extension',
        'UserNew'
    );

    perform acs_sc_impl_alias__delete (
        'UserData',
        'dotlrn_user_extension',
        'UserApprove'
    );

    perform acs_sc_impl_alias__delete (
        'UserData',
        'dotlrn_user_extension',
        'UserDeapprove'
    );

    perform acs_sc_impl_alias__delete (
        'UserData',
        'dotlrn_user_extension',
        'UserModify'
    );

    perform acs_sc_impl_alias__delete (
        'UserData',
        'dotlrn_user_extension',
        'UserDelete'
    );

    -- create the implementation
    perform acs_sc_impl__delete(
        'UserData',
        'dotlrn_user_extension'
    );

    return 0;

END;
$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();

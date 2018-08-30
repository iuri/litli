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
-- Implementation of the profile provider interface for dotLRN Admins.
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: admin-profile-provider-create.sql,v 1.4 2013/11/01 21:08:28 gustafn Exp $
--

CREATE OR REPLACE FUNCTION inline_0() RETURNS integer AS $$
BEGIN

    -- create the implementation
    perform acs_sc_impl__new(
        'profile_provider',
        'dotlrn_admin_profile_provider',
        'dotlrn_admin_profile_provider'
    );

    -- add the bindings to the method implementations

        -- name method
        perform acs_sc_impl_alias__new(
            'profile_provider',
            'dotlrn_admin_profile_provider',
            'name',
            'dotlrn_admin_profile_provider::name',
            'TCL'
        );

        -- prettyName method
        perform acs_sc_impl_alias__new(
            'profile_provider',
            'dotlrn_admin_profile_provider',
            'prettyName',
            'dotlrn_admin_profile_provider::prettyName',
            'TCL'
        );

        -- render method
        perform acs_sc_impl_alias__new(
            'profile_provider',
            'dotlrn_admin_profile_provider',
            'render',
            'dotlrn_admin_profile_provider::render',
            'TCL'
        );

    -- bind this implementation to the interface it implements
    perform acs_sc_binding__new(
        'profile_provider',
        'dotlrn_admin_profile_provider'
    );

    return 0;

END;
$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();

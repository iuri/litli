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
-- Implementation of the profile provider interface for dotLRN Professors.
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @author dan chak (chak@openforce.net)
-- @version $Id: professor-profile-provider-drop.sql,v 1.4 2013/11/01 21:08:29 gustafn Exp $
--



--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE
    foo                         integer;
BEGIN

    -- drop the binding between this implementation and the interface it
    -- implements.
    perform acs_sc_binding__delete(
        'profile_provider',
        'dotlrn_professor_profile_provider'
    );

    -- drop the bindings to the method implementations

        -- name method
        perform acs_sc_impl_alias__delete(
            'profile_provider',
            'dotlrn_professor_profile_provider',
            'name'
        );

        -- prettyName method
        perform acs_sc_impl_alias__delete(
            'profile_provider',
            'dotlrn_professor_profile_provider',
            'prettyName'
        );

        -- render method
        perform acs_sc_impl_alias__delete(
            'profile_provider',
            'dotlrn_professor_profile_provider',
            'render'
        );

    -- drop the implementation
    perform acs_sc_impl__delete(
        'profile_provider',
        'dotlrn_professor_profile_provider'
    );

    return 0;
END;

$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();

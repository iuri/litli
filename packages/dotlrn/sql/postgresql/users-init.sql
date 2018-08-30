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
-- Initialize the User Profile package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: users-init.sql,v 1.4.4.1 2016/08/31 18:57:41 gustafn Exp $
--



--
-- procedure inline_1/0
--
CREATE OR REPLACE FUNCTION inline_1(

) RETURNS integer AS $$
DECLARE
    foo                         integer;
BEGIN

    perform acs_rel_type__create_type(
        'dotlrn_user_profile_rel',
        'dotLRN Profile User',
        'dotLRN Profile Users',
        'user_profile_rel',
        'dotlrn_user_profile_rels',
        'rel_id',
        'dotlrn_user_profile_rel',
        'profiled_group',
        null,
        0,
        null::integer,
        'user',
        null,
        0,
        1
    );

    select min(impl_id)
    into foo
    from acs_sc_impls
    where impl_name = 'dotlrn_user_profile_provider';

    foo := profiled_group__new(
        foo,
        'dotLRN Users'
    );

    foo := rel_segment__new(
        'dotLRN Users',
        foo,
        'dotlrn_user_profile_rel'
    );

    return(0);
END;

$$ LANGUAGE plpgsql;

select inline_1();
drop function inline_1();

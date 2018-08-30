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
-- Sanitize the dotLRN External package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @author dan chak (chak@openforce.net)
-- @version $Id: externals-sanitize.sql,v 1.4 2013/11/01 21:08:29 gustafn Exp $
--



--
-- procedure inline_0/0
--
CREATE OR REPLACE FUNCTION inline_0(

) RETURNS integer AS $$
DECLARE
    foo                         integer;
BEGIN

    select min(segment_id)
    into foo
    from rel_segments
    where segment_name = 'dotLRN Full Profiled Externals';

    perform rel_segment__delete(
        foo
    );

    perform acs_rel_type__drop_type(
        'dotlrn_full_external_profile_rel',
        't'
    );

    return 0;

END;
$$ LANGUAGE plpgsql;

select inline_0();
drop function inline_0();



--
-- procedure inline_1/0
--
CREATE OR REPLACE FUNCTION inline_1(

) RETURNS integer AS $$
DECLARE
    foo                         integer;
BEGIN

    select min(segment_id)
    into foo
    from rel_segments
    where segment_name = 'dotLRN Profiled Externals';

    perform rel_segment__delete(
        foo
    );

    select min(group_id)
    into foo
    from profiled_groups
    where profile_provider = (select min(impl_id)
                              from acs_sc_impls
                              where impl_name = 'dotlrn_external_profile_provider');

    delete
    from dotlrn_user_types
    where group_id = foo;

    perform profiled_group__delete(
        foo
    );

    perform acs_rel_type__drop_type(
        'dotlrn_external_profile_rel',
        't'
    );

    return 0;

END;

$$ LANGUAGE plpgsql;

select inline_1();
drop function inline_1();

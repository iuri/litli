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
-- Initialize the dotLRN Students package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: students-init.sql,v 1.6.4.1 2016/09/09 08:14:42 gustafn Exp $
--




--
-- procedure inline_1/0
--
CREATE OR REPLACE FUNCTION inline_1(

) RETURNS integer AS $$
DECLARE
    foo                         integer;
    gid				integer;
    sid				integer;
    dotlrn_users_group_id       integer;
BEGIN

    PERFORM acs_rel_type__create_type(
        'dotlrn_student_profile_rel',
        'dotLRN Profile Student',
        'dotLRN Profile Students',
	'dotlrn_user_profile_rel',
        'dotlrn_student_profile_rels',
        'rel_id',
        'dotlrn_student_profile_rel',
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
    where impl_name = 'dotlrn_student_profile_provider';

    gid := profiled_group__new(
        foo,
        'dotLRN Students'
    );

    sid := rel_segment__new(
        'dotLRN Students',
        gid,
        'dotlrn_student_profile_rel'
    );

    insert
    into dotlrn_user_types
    (type, pretty_name, rel_type, group_id, segment_id)
    values
    ('student', '#dotlrn.student_role_pretty_name#', 'dotlrn_student_profile_rel', gid, sid);

    select group_id
    into dotlrn_users_group_id
    from groups
    where group_name = 'dotLRN Users';

    foo := composition_rel__new(
        dotlrn_users_group_id,
        gid
    );

    return 0;

END;

$$ LANGUAGE plpgsql;

select inline_1();
drop function inline_1();


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
-- Initialize the dotLRN Professors package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: professors-init.sql,v 1.5 2006/08/08 21:26:21 donb Exp $
--

declare
    foo                         integer;
    group_id                    integer;
    segment_id                  integer;
    dotlrn_users_group_id       integer;
begin

    acs_rel_type.create_type(
        rel_type => 'dotlrn_professor_profile_rel',
        supertype => 'dotlrn_user_profile_rel',
        pretty_name => 'dotLRN Profile Professor',
        pretty_plural => 'dotLRN Profile Professors',
        package_name => 'dotlrn_professor_profile_rel',
        table_name => 'dotlrn_professor_profile_rels',
        id_column => 'rel_id',
        object_type_one => 'profiled_group',
        role_one => null,
        min_n_rels_one => 0,
        max_n_rels_one => null,
        object_type_two => 'user',
        role_two => null,
        min_n_rels_two => 0,
        max_n_rels_two => 1
    );

    select min(impl_id)
    into foo
    from acs_sc_impls
    where impl_name = 'dotlrn_professor_profile_provider';

    group_id := profiled_group.new(
        profile_provider => foo,
        group_name => 'dotLRN Professors'
    );

    segment_id := rel_segment.new(
        segment_name => 'dotLRN Professors',
        group_id => group_id,
        rel_type => 'dotlrn_professor_profile_rel'
    );

    insert
    into dotlrn_user_types
    (type, pretty_name, rel_type, group_id, segment_id)
    values
    ('professor', '#dotlrn.instructor_role_pretty_name#', 'dotlrn_professor_profile_rel', group_id, segment_id);

    select group_id
    into dotlrn_users_group_id
    from groups
    where group_name = 'dotLRN Users';

    foo := composition_rel.new(
        object_id_one => dotlrn_users_group_id,
        object_id_two => group_id
    );

end;
/
show errors

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
-- @version $Id: user-profile-init.sql,v 1.3 2002/08/09 20:56:32 yon Exp $
--

declare
    foo                         integer;
begin

    acs_rel_type.create_type(
        rel_type => 'user_profile_rel',
        supertype => 'membership_rel',
        pretty_name => 'Profiled User Membership',
        pretty_plural => 'Profiled User Memberships',
        package_name => 'user_profile_rel',
        table_name => 'user_profile_rels',
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
    where impl_name = 'user_profile_provider';

    foo := profiled_group.new(
        profile_provider => foo,
        group_name => 'Profiled Users'
    );

    foo := rel_segment.new(
        segment_name => 'Profiled Users',
        group_id => foo,
        rel_type => 'user_profile_rel'
    );

end;
/
show errors

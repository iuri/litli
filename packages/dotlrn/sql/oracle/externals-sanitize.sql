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
-- @version $Id: externals-sanitize.sql,v 1.4 2006/08/08 21:26:21 donb Exp $
--

declare
    foo                         integer;
begin

    select min(segment_id)
    into foo
    from rel_segments
    where segment_name = 'dotLRN Externals';

    rel_segment.del(
        segment_id => foo
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

    profiled_group.del(
        group_id => foo
    );

    acs_rel_type.drop_type(
        rel_type => 'dotlrn_external_profile_rel',
        cascade_p => 't'
    );

end;
/
show errors

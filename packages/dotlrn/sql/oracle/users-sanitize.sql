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
-- Sanitize the User Profile package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: users-sanitize.sql,v 1.5 2006/08/08 21:26:21 donb Exp $
--

declare
    v_segment_id                        integer;
    v_group_id                          integer;
begin

    select segment_id, group_id
    into v_segment_id, v_group_id
    from rel_segments
    where rel_type = 'dotlrn_user_profile_rel';

    delete
    from acs_permissions
    where grantee_id = v_segment_id;

    rel_segment.del(
        segment_id => v_segment_id
    );

    delete
    from acs_permissions
    where grantee_id = v_group_id;

    profiled_group.del(
        group_id => v_group_id
    );

    acs_rel_type.drop_type(
        rel_type => 'dotlrn_user_profile_rel',
        cascade_p => 't'
    );

end;
/
show errors

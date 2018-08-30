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
-- Create the User Profile package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: user-profile-package-create.sql,v 1.4 2003/09/30 13:11:42 mohanp Exp $
--

create or replace package user_profile_rel
as
    function new (
        rel_id in user_profile_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'user_profile_rel',
        group_id in groups.group_id%TYPE default null,
        user_id in users.user_id%TYPE,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return user_profile_rels.rel_id%TYPE;

    procedure del (
        rel_id in user_profile_rels.rel_id%TYPE
    );

end;
/
show errors

create or replace package body user_profile_rel
as
    function new (
        rel_id in user_profile_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'user_profile_rel',
        group_id in groups.group_id%TYPE default null,
        user_id in users.user_id%TYPE,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return user_profile_rels.rel_id%TYPE
    is
        v_rel_id                membership_rels.rel_id%TYPE;
        v_group_id              groups.group_id%TYPE;
    begin
        if group_id is null then
            select min(group_id)
            into v_group_id
            from profiled_groups
            where profile_provider = (select min(impl_id)
                                      from acs_sc_impls
                                      where impl_name = 'user_profile_provider');
        else
             v_group_id := group_id;
        end if;

        v_rel_id := membership_rel.new(
            rel_id => rel_id,
            rel_type => rel_type,
            object_id_one => v_group_id,
            object_id_two => user_id,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into user_profile_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in user_profile_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from user_profile_rels
        where rel_id = user_profile_rel.del.rel_id;

        membership_rel.del(rel_id);
    end;

end;
/
show errors

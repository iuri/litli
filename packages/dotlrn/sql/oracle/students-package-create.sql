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
-- Create the Student package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: students-package-create.sql,v 1.5 2006/08/08 21:26:21 donb Exp $
--

create or replace package dotlrn_student_profile_rel
as
    function new (
        rel_id in dotlrn_student_profile_rels.rel_id%TYPE default null,
        user_id in users.user_id%TYPE,
        portal_id in dotlrn_user_profile_rels.portal_id%TYPE,
        theme_id in dotlrn_user_profile_rels.theme_id%TYPE default null,
        id in dotlrn_user_profile_rels.id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_student_profile_rel',
        group_id in groups.group_id%TYPE default null,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_user_profile_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_student_profile_rels.rel_id%TYPE
    );

end;
/
show errors

create or replace package body dotlrn_student_profile_rel
as
    function new (
        rel_id in dotlrn_student_profile_rels.rel_id%TYPE default null,
        user_id in users.user_id%TYPE,
        portal_id in dotlrn_user_profile_rels.portal_id%TYPE,
        theme_id in dotlrn_user_profile_rels.theme_id%TYPE default null,
        id in dotlrn_user_profile_rels.id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_student_profile_rel',
        group_id in groups.group_id%TYPE default null,
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_user_profile_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_user_profile_rels.rel_id%TYPE;
        v_group_id              groups.group_id%TYPE;
    begin
        if group_id is null then
            select min(group_id)
            into v_group_id
            from profiled_groups
            where profile_provider = (select min(impl_id)
                                      from acs_sc_impls
                                      where impl_name = 'dotlrn_student_profile_provider');
        else
             v_group_id := group_id;
        end if;

        v_rel_id := dotlrn_user_profile_rel.new(
            rel_id => rel_id,
            user_id => user_id,
            portal_id => portal_id,
            theme_id => theme_id,
            id => id,
            rel_type => rel_type,
            group_id => v_group_id,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_student_profile_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_student_profile_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_student_profile_rels
        where rel_id = dotlrn_student_profile_rel.del.rel_id;

        dotlrn_user_profile_rel.del(rel_id);
    end;

end;
/
show errors

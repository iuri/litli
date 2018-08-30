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
-- create the dotLRN memberships packages
--
-- @author Ben Adida (ben@openforce.net)
-- @creation-daate 2001-11-06
-- @version $Id: community-memberships-packages-create.sql,v 1.6 2006/08/08 21:26:21 donb Exp $
--

create or replace package dotlrn_member_rel
is

    function new (
        rel_id in dotlrn_member_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_member_rel',
        community_id in dotlrn_communities_all.community_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_member_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_member_rels.rel_id%TYPE
    );

end;
/
show errors;

create or replace package body dotlrn_member_rel
is

    function new (
        rel_id in dotlrn_member_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_member_rel',
        community_id in dotlrn_communities_all.community_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_member_rels.rel_id%TYPE
    is
        v_rel_id                membership_rels.rel_id%TYPE;
    begin
        v_rel_id:= membership_rel.new(
            rel_id => rel_id,
            rel_type => rel_type,
            object_id_one => community_id,
            object_id_two => user_id,
            member_state => dotlrn_member_rel.new.member_state,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_member_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_member_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_member_rels
        where rel_id = dotlrn_member_rel.del.rel_id;

        membership_rel.del(rel_id);
    end;

end;
/
show errors;

create or replace package dotlrn_admin_rel
is

    function new (
        rel_id in dotlrn_admin_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_admin_rel',
        community_id in dotlrn_communities_all.community_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_admin_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_admin_rels.rel_id%TYPE
    );

end;
/
show errors;

create or replace package body dotlrn_admin_rel
is

    function new (
        rel_id in dotlrn_admin_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_admin_rel',
        community_id in dotlrn_communities_all.community_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_admin_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_admin_rels.rel_id%TYPE;
    begin
        v_rel_id:= dotlrn_member_rel.new(
            rel_id => rel_id,
            rel_type => rel_type,
            community_id => community_id,
            user_id => user_id,
            member_state => dotlrn_admin_rel.new.member_state,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_admin_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_admin_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_admin_rels
        where rel_id = dotlrn_admin_rel.del.rel_id;

        dotlrn_member_rel.del(rel_id);
    end;

end;
/
show errors;

create or replace package dotlrn_student_rel
is

    function new (
        rel_id in dotlrn_student_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_student_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_student_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_student_rels.rel_id%TYPE
    );

end;
/
show errors;

create or replace package body dotlrn_student_rel
is

    function new (
        rel_id in dotlrn_student_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_student_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_student_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_student_rels.rel_id%TYPE;
    begin
        v_rel_id:= dotlrn_member_rel.new(
            rel_id => rel_id,
            rel_type => rel_type,
            community_id => class_instance_id,
            user_id => user_id,
            member_state => dotlrn_student_rel.new.member_state,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_student_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_student_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_student_rels
        where rel_id = dotlrn_student_rel.del.rel_id;

        dotlrn_member_rel.del(rel_id);
    end;

end;
/
show errors;

create or replace package dotlrn_ta_rel
is

    function new (
        rel_id in dotlrn_ta_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_ta_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_ta_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_ta_rels.rel_id%TYPE
    );

end;
/
show errors;

create or replace package body dotlrn_ta_rel
is

    function new (
        rel_id in dotlrn_ta_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_ta_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_ta_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_ta_rels.rel_id%TYPE;
    begin
        v_rel_id:= dotlrn_admin_rel.new(
            rel_id => rel_id,
            rel_type => rel_type,
            community_id => class_instance_id,
            user_id => user_id,
            member_state => dotlrn_ta_rel.new.member_state,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_ta_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_ta_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_ta_rels
        where rel_id = dotlrn_ta_rel.del.rel_id;

        dotlrn_admin_rel.del(rel_id);
    end;

end;
/
show errors;

create or replace package dotlrn_ca_rel
is

    function new (
        rel_id in dotlrn_ca_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_ca_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_ca_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_ca_rels.rel_id%TYPE
    );

end;
/
show errors;

create or replace package body dotlrn_ca_rel
is

    function new (
        rel_id in dotlrn_ca_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_ca_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_ca_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_ca_rels.rel_id%TYPE;
    begin
        v_rel_id:= dotlrn_admin_rel.new(
            rel_id => rel_id,
            rel_type => rel_type,
            community_id => class_instance_id,
            user_id => user_id,
            member_state => dotlrn_ca_rel.new.member_state,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_ca_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_ca_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_ca_rels
        where rel_id = dotlrn_ca_rel.del.rel_id;

        dotlrn_admin_rel.del(rel_id);
    end;

end;
/
show errors;

create or replace package dotlrn_cadmin_rel
is

    function new (
        rel_id in dotlrn_cadmin_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_cadmin_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_cadmin_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_cadmin_rels.rel_id%TYPE
    );

end;
/
show errors;

create or replace package body dotlrn_cadmin_rel
is

    function new (
        rel_id in dotlrn_cadmin_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_cadmin_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_cadmin_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_cadmin_rels.rel_id%TYPE;
    begin
        v_rel_id:= dotlrn_admin_rel.new(
            rel_id => rel_id,
            rel_type => rel_type,
            community_id => class_instance_id,
            user_id => user_id,
            member_state => dotlrn_cadmin_rel.new.member_state,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_cadmin_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_cadmin_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_cadmin_rels
        where rel_id = dotlrn_cadmin_rel.del.rel_id;

        dotlrn_admin_rel.del(rel_id);
    end;

end;
/
show errors;

create or replace package dotlrn_instructor_rel
is

    function new (
        rel_id in dotlrn_instructor_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_instructor_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_instructor_rels.rel_id%TYPE;

    procedure del (
        rel_id in dotlrn_instructor_rels.rel_id%TYPE
    );

end;
/
show errors;

create or replace package body dotlrn_instructor_rel
is

    function new (
        rel_id in dotlrn_instructor_rels.rel_id%TYPE default null,
        rel_type in acs_rels.rel_type%TYPE default 'dotlrn_instructor_rel',
        class_instance_id in dotlrn_class_instances.class_instance_id%TYPE,
        user_id in users.user_id%TYPE,
        member_state in membership_rels.member_state%TYPE default 'approved',
        creation_user in acs_objects.creation_user%TYPE default null,
        creation_ip in acs_objects.creation_ip%TYPE default null
    ) return dotlrn_instructor_rels.rel_id%TYPE
    is
        v_rel_id                dotlrn_instructor_rels.rel_id%TYPE;
    begin
        v_rel_id:= dotlrn_admin_rel.new(
            rel_id => rel_id,
            rel_type => rel_type,
            community_id => class_instance_id,
            user_id => user_id,
            member_state => dotlrn_instructor_rel.new.member_state,
            creation_user => creation_user,
            creation_ip => creation_ip
        );

        insert
        into dotlrn_instructor_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
    end;

    procedure del (
        rel_id in dotlrn_instructor_rels.rel_id%TYPE
    )
    is
    begin
        delete
        from dotlrn_instructor_rels
        where rel_id = dotlrn_instructor_rel.del.rel_id;

        dotlrn_admin_rel.del(rel_id);
    end;

end;
/
show errors;

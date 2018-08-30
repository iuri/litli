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
-- The DotLRN memberships packages
--
-- ben@openforce.net
-- started November 6th, 2001
--

--
-- Basic dotLRN membership rel
--

select define_function_args('dotlrn_member_rel__new','rel_id,rel_type;dotlrn_member_rel,portal_id,community_id,user_id,member_state;approved,creation_user,creation_ip');



--
-- procedure dotlrn_member_rel__new/8
--
CREATE OR REPLACE FUNCTION dotlrn_member_rel__new(
   p_rel_id integer,
   p_rel_type varchar,     -- default 'dotlrn_member_rel'
   p_portal_id integer,
   p_community_id integer,
   p_user_id integer,
   p_member_state varchar, -- default 'approved'
   p_creation_user integer,
   p_creation_ip varchar

) RETURNS integer AS $$
DECLARE
        v_rel_id                integer;
BEGIN
        v_rel_id:= membership_rel__new(
            p_rel_id,
            p_rel_type,
            p_community_id,
            p_user_id,
            p_member_state,
            p_creation_user,
            p_creation_ip
        );

        insert
        into dotlrn_member_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
END;

$$ LANGUAGE plpgsql;


select define_function_args('dotlrn_member_rel__delete','rel_id');



--
-- procedure dotlrn_member_rel__delete/1
--
CREATE OR REPLACE FUNCTION dotlrn_member_rel__delete(
   p_rel_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
        delete from dotlrn_member_rels where rel_id = p_rel_id; 

        PERFORM membership_rel__delete(p_rel_id);

        return 0;
END;

$$ LANGUAGE plpgsql;



select define_function_args('dotlrn_admin_rel__new','rel_id,rel_type;dotlrn_admin_rel,community_id,user_id,member_state,portal_id,creation_user,creation_ip');



--
-- procedure dotlrn_admin_rel__new/8
--
CREATE OR REPLACE FUNCTION dotlrn_admin_rel__new(
   p_rel_id integer,
   p_rel_type varchar, -- default 'dotlrn_admin_rel'
   p_community_id integer,
   p_user_id integer,
   p_member_state varchar,
   p_portal_id integer,
   p_creation_user integer,
   p_creation_ip varchar

) RETURNS integer AS $$
DECLARE
        v_rel_id                integer;
BEGIN
        v_rel_id:= dotlrn_member_rel__new(
            p_rel_id,
            p_rel_type,
            p_portal_id,
            p_community_id,
            p_user_id,
            p_member_state,
            p_creation_user,
            p_creation_ip
        );

        insert
        into dotlrn_admin_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
END;

$$ LANGUAGE plpgsql;


select define_function_args('dotlrn_admin_rel__delete','rel_id');



--
-- procedure dotlrn_admin_rel__delete/1
--
CREATE OR REPLACE FUNCTION dotlrn_admin_rel__delete(
   p_rel_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
        delete from dotlrn_admin_rels where rel_id = p_rel_id;

        PERFORM dotlrn_member_rel__delete(p_rel_id);

        return 0;
END;

$$ LANGUAGE plpgsql;


select define_function_args('dotlrn_student_rel__new','rel_id,rel_type;dotlrn_student_rel,portal_id,class_instance_id,user_id,member_state,creation_user,creation_ip');



--
-- procedure dotlrn_student_rel__new/8
--
CREATE OR REPLACE FUNCTION dotlrn_student_rel__new(
   p_rel_id integer,
   p_rel_type varchar, -- default 'dotlrn_student_rel'
   p_portal_id integer,
   p_class_instance_id integer,
   p_user_id integer,
   p_member_state varchar,
   p_creation_user integer,
   p_creation_ip varchar

) RETURNS integer AS $$
DECLARE
        v_rel_id                integer;
BEGIN
        v_rel_id:= dotlrn_member_rel__new(
            p_rel_id,
            p_rel_type,
            p_portal_id,
            p_class_instance_id,
            p_user_id,
            p_member_state,
            p_creation_user,
            p_creation_ip
        );

        insert
        into dotlrn_student_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
END;

$$ LANGUAGE plpgsql;


select define_function_args('dotlrn_student_rel__delete','rel_id');



--
-- procedure dotlrn_student_rel__delete/1
--
CREATE OR REPLACE FUNCTION dotlrn_student_rel__delete(
   p_rel_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
        delete from dotlrn_student_rels where rel_id= p_rel_id;

        PERFORM dotlrn_member_rel__delete(p_rel_id);

        return 0;
END;

$$ LANGUAGE plpgsql;



select define_function_args('dotlrn_ta_rel__new','rel_id,rel_type;dotlrn_ta_rel,class_instance_id,user_id,member_state,portal_id,creation_user,creation_ip');

select define_function_args('dotlrn_ta_rel__delete','rel_id');




--
-- procedure dotlrn_ta_rel__new/8
--
CREATE OR REPLACE FUNCTION dotlrn_ta_rel__new(
   p_rel_id integer,
   p_rel_type varchar, -- default 'dotlrn_ta_rel'
   p_class_instance_id integer,
   p_user_id integer,
   p_member_state varchar,
   p_portal_id integer,
   p_creation_user integer,
   p_creation_ip varchar

) RETURNS integer AS $$
DECLARE
        v_rel_id                integer;
BEGIN
        v_rel_id:= dotlrn_admin_rel__new(
            p_rel_id,
            p_rel_type,
            p_class_instance_id,
            p_user_id,
            p_member_state,
            p_portal_id,
            p_creation_user,
            p_creation_ip
        );

        insert
        into dotlrn_ta_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
END;

$$ LANGUAGE plpgsql;




--
-- procedure dotlrn_ta_rel__delete/1
--
CREATE OR REPLACE FUNCTION dotlrn_ta_rel__delete(
   p_rel_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
        delete
        from dotlrn_ta_rels
        where rel_id = p_rel_id;

        PERFORM dotlrn_admin_rel__delete(p_rel_id);
        
        return 0;
END;

$$ LANGUAGE plpgsql;


-- ca rel

select define_function_args('dotlrn_ca_rel__new','rel_id,rel_type;dotlrn_ca_rel,class_instance_id,user_id,member_state,portal_id,creation_user,creation_ip');

select define_function_args('dotlrn_ca_rel__delete','rel_id');




--
-- procedure dotlrn_ca_rel__new/8
--
CREATE OR REPLACE FUNCTION dotlrn_ca_rel__new(
   p_rel_id integer,
   p_rel_type varchar, -- default 'dotlrn_ca_rel'
   p_class_instance_id integer,
   p_user_id integer,
   p_member_state varchar,
   p_portal_id integer,
   p_creation_user integer,
   p_creation_ip varchar

) RETURNS integer AS $$
DECLARE
        v_rel_id                integer;
BEGIN
        v_rel_id:= dotlrn_admin_rel__new(
            p_rel_id,
            p_rel_type,
            p_class_instance_id,
            p_user_id,
            p_member_state,
            p_portal_id,
            p_creation_user,
            p_creation_ip
        );

        insert
        into dotlrn_ca_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
END;

$$ LANGUAGE plpgsql;




--
-- procedure dotlrn_ca_rel__delete/1
--
CREATE OR REPLACE FUNCTION dotlrn_ca_rel__delete(
   p_rel_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
        delete
        from dotlrn_ca_rels
        where rel_id = p_rel_id;

        PERFORM dotlrn_admin_rel__delete(p_rel_id);
        
        return 0;
END;

$$ LANGUAGE plpgsql;


-- course admin

select define_function_args('dotlrn_cadmin_rel__new','rel_id,rel_type;dotlrn_cadmin_rel,class_instance_id,user_id,member_state,portal_id,creation_user,creation_ip');

select define_function_args('dotlrn_cadmin_rel__delete','rel_id');




--
-- procedure dotlrn_cadmin_rel__new/8
--
CREATE OR REPLACE FUNCTION dotlrn_cadmin_rel__new(
   p_rel_id integer,
   p_rel_type varchar, -- default 'dotlrn_cadmin_rel'
   p_class_instance_id integer,
   p_user_id integer,
   p_member_state varchar,
   p_portal_id integer,
   p_creation_user integer,
   p_creation_ip varchar

) RETURNS integer AS $$
DECLARE
        v_rel_id                integer;
BEGIN
        v_rel_id:= dotlrn_admin_rel__new(
            p_rel_id,
            p_rel_type,
            p_class_instance_id,
            p_user_id,
            p_member_state,
            p_portal_id,
            p_creation_user,
            p_creation_ip
        );

        insert
        into dotlrn_cadmin_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
END;

$$ LANGUAGE plpgsql;




--
-- procedure dotlrn_cadmin_rel__delete/1
--
CREATE OR REPLACE FUNCTION dotlrn_cadmin_rel__delete(
   p_rel_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
        delete
        from dotlrn_cadmin_rels
        where rel_id = p_rel_id;

        PERFORM dotlrn_admin_rel__delete(p_rel_id);
        
        return 0;
END;

$$ LANGUAGE plpgsql;


-- instructor rel

select define_function_args('dotlrn_instructor_rel__new','rel_id,rel_type;dotlrn_instructor_rel,class_instance_id,user_id,member_state,portal_id,creation_user,creation_ip');

select define_function_args('dotlrn_instructor_rel__delete','rel_id');




--
-- procedure dotlrn_instructor_rel__new/8
--
CREATE OR REPLACE FUNCTION dotlrn_instructor_rel__new(
   p_rel_id integer,
   p_rel_type varchar, -- default 'dotlrn_instructor_rel'
   p_class_instance_id integer,
   p_user_id integer,
   p_member_state varchar,
   p_portal_id integer,
   p_creation_user integer,
   p_creation_ip varchar

) RETURNS integer AS $$
DECLARE
        v_rel_id                integer;
BEGIN
        v_rel_id:= dotlrn_admin_rel__new(
            p_rel_id,
            p_rel_type,
            p_class_instance_id,
            p_user_id,
            p_member_state,
            p_portal_id,
            p_creation_user,
            p_creation_ip
        );

        insert
        into dotlrn_instructor_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
END;

$$ LANGUAGE plpgsql;




--
-- procedure dotlrn_instructor_rel__delete/1
--
CREATE OR REPLACE FUNCTION dotlrn_instructor_rel__delete(
   p_rel_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
        delete
        from dotlrn_instructor_rels
        where rel_id = p_rel_id;

        PERFORM dotlrn_admin_rel__delete(p_rel_id);
        
        return 0;
END;

$$ LANGUAGE plpgsql;


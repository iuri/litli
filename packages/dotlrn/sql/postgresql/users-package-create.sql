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
-- @version $Id: users-package-create.sql,v 1.5 2013/11/01 21:08:30 gustafn Exp $
--


-- old define_function_args ('dotlrn_user_profile_rel__new','rel_id,id,rel_type;dotlrn_user_profile_rel,group_id,user_id,creation_user,creation_ip')
-- new
select define_function_args('dotlrn_user_profile_rel__new','rel_id,user_id,portal_id;dotlrn_user_profile_rel,theme_id,id,rel_type,group_id,creation_user,creation_ip');


select define_function_args ('dotlrn_user_profile_rel__delete','rel_id');




--
-- procedure dotlrn_user_profile_rel__new/9
--
CREATE OR REPLACE FUNCTION dotlrn_user_profile_rel__new(
   p_rel_id integer,
   p_user_id integer,
   p_portal_id integer, -- default 'dotlrn_user_profile_rel'
   p_theme_id integer,
   p_id varchar,
   p_rel_type varchar,
   p_group_id integer,
   p_creation_user integer,
   p_creation_ip varchar

) RETURNS integer AS $$
DECLARE
        v_rel_id                user_profile_rels.rel_id%TYPE;
        v_group_id              groups.group_id%TYPE;
BEGIN
        if p_group_id is null then
            select min(group_id)
            into v_group_id
            from profiled_groups
            where profile_provider = (select min(impl_id)
                                      from acs_sc_impls
                                      where impl_name = 'dotlrn_user_profile_provider');
        else
             v_group_id := p_group_id;
        end if;

        v_rel_id := user_profile_rel__new(
            p_rel_id,
            p_rel_type,
            v_group_id,
            p_user_id,
            p_creation_user,
            p_creation_ip
        );

        insert
        into dotlrn_user_profile_rels
        (rel_id, portal_id, theme_id, id)
        values
        (v_rel_id, p_portal_id, p_theme_id, p_id);

        return v_rel_id;
END;

$$ LANGUAGE plpgsql;




--
-- procedure dotlrn_user_profile_rel__delete/1
--
CREATE OR REPLACE FUNCTION dotlrn_user_profile_rel__delete(
   p_rel_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
        delete
        from dotlrn_user_profile_rels
        where rel_id = p_rel_id;

        PERFORM user_profile_rel__delete(p_rel_id);        
        return (0);
END;

$$ LANGUAGE plpgsql;


-- full users 

select define_function_args('dotlrn_full_user_profile_rel__new','rel_id,portal_id,theme_id,id,rel_type;dotlrn_full_user_profile_rel,group_id,user_id,creation_user,creation_ip');

select define_function_args('dotlrn_full_user_profile_rel__delete','rel_id');




--
-- procedure dotlrn_full_user_profile_rel__new/9
--
CREATE OR REPLACE FUNCTION dotlrn_full_user_profile_rel__new(
   p_rel_id integer,
   p_portal_id integer,
   p_theme_id integer,
   p_id varchar,
   p_rel_type varchar, -- default 'dotlrn_full_user_profile_rel'
   p_group_id integer,
   p_user_id integer,
   p_creation_user integer,
   p_creation_ip varchar

) RETURNS integer AS $$
DECLARE
        v_rel_id                dotlrn_user_profile_rels.rel_id%TYPE;
        v_group_id              groups.group_id%TYPE;
BEGIN
        if p_group_id is null then
            select min(group_id)
            into v_group_id
            from profiled_groups
            where profile_provider = (select min(impl_id)
                                      from acs_sc_impls
                                      where impl_name = 'dotlrn_user_profile_provider');
        else
             v_group_id := p_group_id;
        end if;

        v_rel_id := dotlrn_user_profile_rel__new(
            p_rel_id,
            p_id,
            p_rel_type,
            v_group_id,
            p_user_id,
            p_creation_user,
            p_creation_ip
        );

        insert
        into dotlrn_full_user_profile_rels
        (rel_id, portal_id, theme_id)
        values
        (v_rel_id, p_portal_id, p_theme_id);

        return v_rel_id;
END;

$$ LANGUAGE plpgsql;




--
-- procedure dotlrn_full_user_profile_rel__delete/1
--
CREATE OR REPLACE FUNCTION dotlrn_full_user_profile_rel__delete(
   p_rel_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
        delete
        from dotlrn_full_user_profile_rels
        where rel_id = p_rel_id;

        PERFORM dotlrn_user_profile_rel__delete(p_rel_id);
        return (0);
END;

$$ LANGUAGE plpgsql;

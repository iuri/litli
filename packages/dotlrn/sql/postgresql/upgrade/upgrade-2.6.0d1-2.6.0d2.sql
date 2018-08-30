-- 
-- 
-- 
-- @author Victor Guerra (vguerra@gmail.com)
-- @creation-date 2010-11-08
-- @cvs-id $Id: upgrade-2.6.0d1-2.6.0d2.sql,v 1.2 2013/11/01 21:08:30 gustafn Exp $
--

-- PG 9.0 compatibility. Changes regarding usage of sequences.



-- added
select define_function_args('dotlrn_community_type__new','community_type,parent_type,pretty_name,pretty_plural,description,package_id,creation_date,creation_user,creation_ip,context_id');

--
-- procedure dotlrn_community_type__new/10
--
CREATE OR REPLACE FUNCTION dotlrn_community_type__new(
   p_community_type varchar,
   p_parent_type varchar,
   p_pretty_name varchar,
   p_pretty_plural varchar,
   p_description varchar,
   p_package_id integer,
   p_creation_date timestamptz,
   p_creation_user integer,
   p_creation_ip varchar,
   p_context_id integer
) RETURNS varchar AS $$
DECLARE
        v_parent_object_type acs_object_types.object_type%TYPE;
        v_unique_name acs_objects.object_id%TYPE;
BEGIN
        if p_parent_type is null then
            v_parent_object_type:= 'application_group';
        else
            v_parent_object_type:= p_parent_type;
        end if;

        select nextval('t_acs_object_id_seq')
        into v_unique_name
        from dual;

        PERFORM acs_object_type__create_type (
            p_community_type,
            p_community_type,
            p_community_type,
	    v_parent_object_type,
            cast(v_unique_name as varchar),
            cast(v_unique_name as varchar),
            cast(v_unique_name as varchar),
	    'f',
	    null,
            'acs_group.name'
        );

        insert
        into group_types
        (group_type, default_join_policy)
        values
        (p_community_type, 'closed');

        insert
        into dotlrn_community_types
        (community_type, 
	 pretty_name, 
	 description, 
	 package_id, 
	 supertype)
        values
        (p_community_type, 
	 p_pretty_name, 
	 p_description, 
	 p_package_id, 
	 p_parent_type);

        return p_community_type;
END;

$$ LANGUAGE plpgsql;


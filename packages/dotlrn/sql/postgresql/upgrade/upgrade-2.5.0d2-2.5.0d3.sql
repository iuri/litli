


--
-- procedure dotlrn_community__new/15
--
CREATE OR REPLACE FUNCTION dotlrn_community__new(
   p_community_id integer,
   p_parent_community_id integer,
   p_community_type varchar,
   p_community_key varchar,
   p_pretty_name varchar,
   p_description varchar,
   p_archived_p varchar, -- default 'f'
   p_portal_id integer,
   p_non_member_portal_id integer,
   p_package_id integer,
   p_join_policy varchar,
   p_creation_date timestamptz,
   p_creation_user integer,
   p_creation_ip varchar,
   p_context_id integer

) RETURNS integer AS $$
DECLARE
        c_id                            integer;
        v_group_type_exists_p           integer;
BEGIN

        c_id := application_group__new (
            p_community_id,
            p_community_type,
            p_creation_date,
            p_creation_user,
            p_creation_ip,
            null,
            null,
            p_community_key,
            p_package_id,
            p_join_policy,
            p_context_id
        );

        insert into dotlrn_communities_all
          (community_id, 
           parent_community_id,
           community_type, 
           community_key, 
           pretty_name,  
           description, 
           package_id, 
           portal_id,
           archived_p,
           non_member_portal_id)
        values
          (c_id, 
           p_parent_community_id, 
           p_community_type, 
           p_community_key, 
           p_pretty_name, 
           p_description,    
           p_package_id, 
           p_portal_id,
           p_archived_p,
           p_non_member_portal_id);

        return c_id;        
END;

$$ LANGUAGE plpgsql;



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

        select acs_object_id_seq.nextval
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

select define_function_args('dotlrn_community__new','community_id,parent_community_id,community_type,community_key,pretty_name,description,archived_p;f,portal_id,non_member_portal_id,package_id,join_policy,creation_date,creation_user,creation_ip,context_id');



--
-- procedure dotlrn_community__new/15
--
CREATE OR REPLACE FUNCTION dotlrn_community__new(
   p_community_id integer,
   p_parent_community_id integer,
   p_community_type varchar,
   p_community_key varchar,
   p_pretty_name varchar,
   p_description varchar,
   p_archived_p varchar, -- default 'f'
   p_portal_id integer,
   p_non_member_portal_id integer,
   p_package_id integer,
   p_join_policy varchar,
   p_creation_date timestamptz,
   p_creation_user integer,
   p_creation_ip varchar,
   p_context_id integer

) RETURNS integer AS $$
DECLARE
        c_id                            integer;
        v_group_type_exists_p           integer;
BEGIN

        c_id := application_group__new (
            p_community_id,
            p_community_type,
            p_creation_date,
            p_creation_user,
            p_creation_ip,
            null,
            null,
            p_community_key,
            p_package_id,
            p_join_policy,
            p_context_id
        );

        insert into dotlrn_communities_all
          (community_id, 
           parent_community_id,
           community_type, 
           community_key, 
           pretty_name,  
           description, 
           package_id, 
           portal_id,
           archived_p,
           non_member_portal_id)
        values
          (c_id, 
           p_parent_community_id, 
           p_community_type, 
           p_community_key, 
           p_pretty_name, 
           p_description,    
           p_package_id, 
           p_portal_id,
           p_archived_p,
           p_non_member_portal_id);

        return c_id;        
END;

$$ LANGUAGE plpgsql;


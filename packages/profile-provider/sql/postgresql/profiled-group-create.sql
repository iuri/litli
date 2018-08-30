--
-- Groups that implement the profile provider interface
--
-- @author <a href="mailto:yon@milliped.com">yon@milliped.com</a>
-- @version $Id: profiled-group-create.sql,v 1.3 2014/10/27 16:41:52 victorg Exp $
--

create table profiled_groups (
    group_id                    integer
				constraint pg_group_id_fk
                                references groups (group_id)
                                constraint profiled_groups_pk
                                primary key,
    profile_provider            integer
				constraint pg_profile_provider_fk
                                references acs_sc_impls (impl_id)
                                constraint pg_profile_provider_nn
                                not null
);

select acs_object_type__create_type(
        'profiled_group',
        'Profiled Group',
        'Profiled Groups',
        'group',
        'profiled_groups',
        'group_id',
        'profiled_group',
	'f',
        NULL,
        'acs_group.name'
);


select define_function_args ('profiled_group__new','group_id,profile_provider,group_name,join_policy,email,url,object_type;profiled_group,creation_date,creation_user,creation_ip');



--
-- procedure profiled_group__new/10
--
CREATE OR REPLACE FUNCTION profiled_group__new(
   p_group_id integer,
   p_profile_provider integer,
   p_group_name varchar,
   p_join_policy varchar,
   p_email varchar,
   p_url varchar,
   p_object_type varchar, -- default 'profiled_group'
   p_creation_date timestamptz,
   p_creation_user integer,
   p_creation_ip varchar

) RETURNS integer AS $$
DECLARE
	v_group_id		integer;
BEGIN
        v_group_id := acs_group__new(
            p_group_id,
	    p_object_type,
	    p_creation_date,
	    p_creation_user,
	    p_creation_ip,
	    p_email,
	    p_url,
	    p_group_name,
	    p_join_policy,
	    NULL
        );
	
        insert
        into profiled_groups
        (group_id, profile_provider)
        values
        (v_group_id, p_profile_provider);

	return v_group_id;
END;

$$ LANGUAGE plpgsql;




--
-- procedure profiled_group__new/2
--
CREATE OR REPLACE FUNCTION profiled_group__new(
   p_profile_provider integer,
   p_group_name varchar
) RETURNS integer AS $$
--
-- profiled_group__new/2 maybe obsolete, when we define proper defaults for /10
--
DECLARE
BEGIN
	return profiled_group__new(
	       NULL,
	       p_profile_provider,
	       p_group_name,
	       NULL,
	       NULL,
	       NULL,
	       'profiled_group',
	       now(),
	       NULL,
	       NULL
	);
END;

$$ LANGUAGE plpgsql;


select define_function_args('profiled_group__delete','group_id');



--
-- procedure profiled_group__delete/1
--
CREATE OR REPLACE FUNCTION profiled_group__delete(
   p_group_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
        delete
        from profiled_groups
        where profiled_groups.group_id = p_group_id;

	perform acs_group__delete(p_group_id);

	return 0;
END;

$$ LANGUAGE plpgsql;


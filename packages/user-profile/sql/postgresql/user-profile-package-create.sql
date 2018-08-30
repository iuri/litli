--
-- Create the User Profile package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: user-profile-package-create.sql,v 1.3 2014/10/27 16:42:00 victorg Exp $
--


select define_function_args ('user_profile_rel__new','rel_id,rel_type;user_profile_rel,group_id,user_id,creation_user,creation_ip');

select define_function_args ('user_profile_rel__delete','rel_id');




--
-- procedure user_profile_rel__new/6
--
CREATE OR REPLACE FUNCTION user_profile_rel__new(
   p_rel_id integer,
   p_rel_type varchar, -- default 'user_profile_rel'
   p_group_id integer,
   p_user_id integer,
   p_creation_user integer,
   p_creation_ip varchar

) RETURNS integer AS $$
DECLARE
        v_rel_id                membership_rels.rel_id%TYPE;
        v_group_id              groups.group_id%TYPE;
BEGIN
        if p_group_id is null then
            select min(group_id)
            into v_group_id
            from profiled_groups
            where profile_provider = (select min(impl_id)
                                      from acs_sc_impls
                                      where impl_name = 'user_profile_provider');
        else
             v_group_id := p_group_id;
        end if;

        v_rel_id := membership_rel__new(
            p_rel_id,
            p_rel_type,
            v_group_id,
            p_user_id,
	    'approved',
            p_creation_user,
            p_creation_ip
        );

        insert
        into user_profile_rels
        (rel_id)
        values
        (v_rel_id);

        return v_rel_id;
END;

$$ LANGUAGE plpgsql;




--
-- procedure user_profile_rel__delete/1
--
CREATE OR REPLACE FUNCTION user_profile_rel__delete(
   p_rel_id integer
) RETURNS integer AS $$
DECLARE
BEGIN
        delete
        from user_profile_rels
        where rel_id = p_rel_id;

	PERFORM membership_rel__delete(p_rel_id);
	
	return 0;
END;

$$ LANGUAGE plpgsql;

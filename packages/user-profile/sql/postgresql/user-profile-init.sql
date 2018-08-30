--
-- Initialize the User Profile package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: user-profile-init.sql,v 1.2.2.1 2016/08/31 18:57:41 gustafn Exp $
--



--
-- procedure inline_1/0
--
CREATE OR REPLACE FUNCTION inline_1(

) RETURNS integer AS $$
DECLARE
	foo integer;
BEGIN
    PERFORM acs_rel_type__create_type(
        'user_profile_rel',
        'Profiled User Membership',
        'Profiled User Memberships',
        'membership_rel',
        'user_profile_rels',
        'rel_id',
        'user_profile_rel',
        'profiled_group',
        null,
        0,
        null::integer,
        'user',
        null,
        0,
        1
    );

    select min(impl_id)
    into foo
    from acs_sc_impls
    where impl_name = 'user_profile_provider';

    foo:= profiled_group__new(
	   foo,
	   'Profiled Users'
    );

    PERFORM rel_segment__new(
        NULL,
	'rel_segment',
	NULL,
	NULL,
	NULL,
	NULL,
	NULL,
        'Profiled Users',
        foo,
        'user_profile_rel',
	NULL
    );

    return 0;
END;

$$ LANGUAGE plpgsql;

select inline_1();
drop function inline_1();

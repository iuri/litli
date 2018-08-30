--
-- Sanitize the User Profile package
--
-- @author <a href="mailto:yon@openforce.net">yon@openforce.net</a>
-- @version $Id: user-profile-sanitize.sql,v 1.3 2014/10/27 16:42:00 victorg Exp $
--



--
-- procedure inline_1/0
--
CREATE OR REPLACE FUNCTION inline_1(

) RETURNS integer AS $$
DECLARE
    foo                         integer;
BEGIN

    select min(segment_id)
    into foo
    from rel_segments
    where segment_name = 'Profiled Users';

    perform rel_segment__delete(
        foo
    );

    select min(group_id)
    into foo
    from profiled_groups
    where profile_provider = (select min(impl_id)
                              from acs_sc_impls
                              where impl_name = 'user_profile_provider');

    perform profiled_group__delete(
        foo
    );

    perform acs_rel_type__drop_type(
        'user_profile_rel',
        't'
    );

    return 0;

END;

$$ LANGUAGE plpgsql;

select inline_1();
drop function inline_1();

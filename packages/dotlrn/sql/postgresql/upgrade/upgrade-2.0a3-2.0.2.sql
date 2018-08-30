--
-- Privacy control update
-- for systems upgrading to 2.0 from
-- code olderthan February 20, 2004.
--
-- by aegrumet@alum.mit.edu on 2004-02-23
--

-- prompt Creating relationships, relational segments, helper views and package...

-- This function was copied in from privacy-init.sql (v1.1.2.3) but
-- given an extra "if" condition.  We could have put the "if" directly
-- in privacy-init.sql but it doesn't really belong there.


--
-- procedure inline_1/0
--
CREATE OR REPLACE FUNCTION inline_1(

) RETURNS integer AS $$
DECLARE
    v_guest_segment_id integer;
    v_non_guest_segment_id integer;
    v_object_id integer;
    v_count integer;
BEGIN

    --
    -- Only run this code if the new rel_types haven't been created.
    -- Fix for bug #1633.
    --
    select count(*) into v_count
    from acs_object_types
    where object_type = 'dotlrn_guest_rel';

    if v_count = 0 then

    --
    -- Guests
    --

    perform acs_rel_type__create_type(
        'dotlrn_guest_rel',
        '.LRN Guest',
        '.LRN Guests',
        'membership_rel',
        'dotlrn_guest_rels',
        'rel_id',
        'dotlrn_guest_rel',
        'group',
        null,
        0,
        null,
        'user',
        null,
        0,
        1
    );

    v_guest_segment_id := rel_segment__new(
        'Registered .LRN Guests',
        acs__magic_object_id('registered_users'),
        'dotlrn_guest_rel'
    );

    --
    -- Non Guests
    --

    perform acs_rel_type__create_type(
        'dotlrn_non_guest_rel',
        '.LRN Non-Guest',
        '.LRN Non-Guests',
        'membership_rel',
        'dotlrn_non_guest_rels',
        'rel_id',
        'dotlrn_non_guest_rel',
        'group',
        null,
        0,
        null,
        'user',
        null,
        0,
        1
    );

    v_non_guest_segment_id := rel_segment__new(
        'Registered .LRN Non-Guests',
        acs__magic_object_id('registered_users'),
        'dotlrn_non_guest_rel'
    );

    end if;

    return(0);
END;

$$ LANGUAGE plpgsql;

select inline_1();
drop function inline_1();

-- Copied in from privacy-init.sql (v.1.1.2.3)
create or replace view dotlrn_guest_status
as
select r.object_id_two as user_id,
       case when r.rel_type = 'dotlrn_guest_rel' then 't' else 'f' end as guest_p
  from acs_rels r, 
       membership_rels m 
where m.rel_id = r.rel_id 
  and (r.rel_type = 'dotlrn_guest_rel' 
       or r.rel_type = 'dotlrn_non_guest_rel')
  and r.object_id_one = acs__magic_object_id('registered_users');


\i ../privacy-package-create.sql

-- prompt Establishing non-guest or guest status for each user...



--
-- procedure inline_1/0
--
CREATE OR REPLACE FUNCTION inline_1(

) RETURNS integer AS $$
DECLARE
   v_dotlrn_package_id integer;
   v_permission_p char(1);
   v_non_guest_relseg_id integer;
   v_guest_relseg_id integer;
   user record;
BEGIN

   --
   -- Load some constants.
   --

   -- Assume, as in dotlrn::package_key, that dotlrn is mounted at /dotlrn.
   select c.object_id into v_dotlrn_package_id
   from site_nodes c, site_nodes p
   where p.node_id = c.parent_id
     and c.name = 'dotlrn'
     and p.parent_id is null;

   select segment_id into v_non_guest_relseg_id
     from rel_segments
   where group_id = acs__magic_object_id('registered_users')
     and rel_type = 'dotlrn_non_guest_rel';

   select segment_id into v_guest_relseg_id
     from rel_segments
   where group_id = acs__magic_object_id('registered_users')
     and rel_type = 'dotlrn_guest_rel';

   --
   -- Convert permissions to relationships for each user.
   --

   for user in select user_id from dotlrn_users
   loop
     select acs_permission__permission_p(
       v_dotlrn_package_id,user.user_id,'read_private_data')
     into v_permission_p
     from dual;

     if v_permission_p = 't' then
        perform acs_permission__revoke_permission(
          v_dotlrn_package_id,user.user_id,'read_private_data');
        perform dotlrn_privacy__set_user_non_guest(user.user_id);
     else
        perform dotlrn_privacy__set_user_guest(user.user_id);
     end if;

    end loop;

    return(0);
END;

$$ LANGUAGE plpgsql;

select inline_1();
drop function inline_1();


-- prompt Granting read_private_data privilege to non-guests on each community...



--
-- procedure inline_1/0
--
CREATE OR REPLACE FUNCTION inline_1(

) RETURNS integer AS $$
DECLARE
  v_count integer;
  v_parameter_id integer;
  community record;
BEGIN

  for community in select community_id, package_id from dotlrn_communities_all
  loop

    -- Grant permission to non-guests on community.
    perform dotlrn_privacy__grant_rd_prv_dt_to_rel(
      community.community_id,'dotlrn_non_guest_rel');

  end loop;

  return(0);

END;

$$ LANGUAGE plpgsql;

select inline_1();
drop function inline_1();

-- prompt Finished.


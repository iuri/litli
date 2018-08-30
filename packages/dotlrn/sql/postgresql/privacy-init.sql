--
-- Privacy control
-- by aegrumet@alum.mit.edu on 2004-02-10
--
--
-- dotLRN supports a method of protecting private information about
-- individuals.  This code is intended to help comply with privacy laws such
-- as the US -- Family Educational Right to Privacy Act aka the
-- "Buckley Amendment"
--
--     http://www.cpsr.org/cpsr/privacy/ssn/ferpa.buckley.html
--
-- Here we set up the structures for assigning a site-wide flag to
-- each user that indicates whether or not they are "guest" users.  In
-- the context of dotlrn, guest users do not by default have access to
-- private information such as the names of students taking a
-- particular class.
--


--
-- procedure inline_1/0
--
CREATE OR REPLACE FUNCTION inline_1(

) RETURNS integer AS $$
DECLARE
    v_guest_segment_id integer;
    v_non_guest_segment_id integer;
    v_object_id integer;
BEGIN

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
        null::integer,
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
        null::integer,
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

    return(0);
END;

$$ LANGUAGE plpgsql;

select inline_1();
drop function inline_1();

create or replace view dotlrn_guest_status
as
select r.object_id_two as user_id,
       case when r.rel_type = 'dotlrn_guest_rel' then true else false end as guest_p
  from acs_rels r, 
       membership_rels m 
where m.rel_id = r.rel_id 
  and (r.rel_type = 'dotlrn_guest_rel' 
       or r.rel_type = 'dotlrn_non_guest_rel')
  and r.object_id_one = acs__magic_object_id('registered_users');

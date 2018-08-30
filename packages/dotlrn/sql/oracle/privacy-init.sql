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
declare
    v_guest_segment_id integer;
    v_non_guest_segment_id integer;
    v_object_id integer;
begin

    --
    -- Guests
    --

    acs_rel_type.create_type(
        rel_type => 'dotlrn_guest_rel',
        pretty_name => '.LRN Guest',
        pretty_plural => '.LRN Guests',
        supertype => 'membership_rel',
        table_name => 'dotlrn_guest_rels',
        id_column => 'rel_id',
        package_name => 'dotlrn_guest_rel',
        object_type_one => 'group',
        role_one => null,
        min_n_rels_one => 0,
        max_n_rels_one => null,
        object_type_two => 'user',
        role_two => null,
        min_n_rels_two => 0,
        max_n_rels_two => 1
    );

    v_guest_segment_id := rel_segment.new(
        segment_name => 'Registered .LRN Guests',
        group_id => acs.magic_object_id('registered_users'),
        rel_type => 'dotlrn_guest_rel'
    );

    --
    -- Non Guests
    --

    acs_rel_type.create_type(
        rel_type => 'dotlrn_non_guest_rel',
        pretty_name => '.LRN Non-Guest',
        pretty_plural => '.LRN Non-Guests',
        supertype => 'membership_rel',
        table_name => 'dotlrn_non_guest_rels',
        id_column => 'rel_id',
        package_name => 'dotlrn_non_guest_rel',
        object_type_one => 'group',
        role_one => null,
        min_n_rels_one => 0,
        max_n_rels_one => null,
        object_type_two => 'user',
        role_two => null,
        min_n_rels_two => 0,
        max_n_rels_two => 1
    );

    v_non_guest_segment_id := rel_segment.new(
        segment_name => 'Registered .LRN Non-Guests',
        group_id => acs.magic_object_id('registered_users'),
        rel_type => 'dotlrn_non_guest_rel'
    );

end;
/
show errors

create or replace view dotlrn_guest_status
as
select r.object_id_two as user_id,
       case when r.rel_type = 'dotlrn_guest_rel' then 't' else 'f' end as guest_p
  from acs_rels r, 
       membership_rels m 
where m.rel_id = r.rel_id 
  and (r.rel_type = 'dotlrn_guest_rel' 
       or r.rel_type = 'dotlrn_non_guest_rel')
  and r.object_id_one = acs.magic_object_id('registered_users');

create or replace package dotlrn_privacy
is
    function guest_p (
        user_id in acs_objects.object_id%TYPE
    ) return char;

    procedure set_user_non_guest (
        user_id in acs_objects.object_id%TYPE
    );

    procedure set_user_guest (
        user_id in acs_objects.object_id%TYPE
    );

    procedure grant_rd_prv_dt_to_rel (
        object_id in acs_objects.object_id%TYPE,
        rel_type in rel_segments.rel_type%TYPE
    );
    procedure revoke_rd_prv_dt_from_rel (
        object_id in acs_objects.object_id%TYPE,
        rel_type in rel_segments.rel_type%TYPE
    );

end dotlrn_privacy;
/
show errors

create or replace package body dotlrn_privacy
is

    function guest_p (
        user_id in acs_objects.object_id%TYPE
    ) return char
    is
      v_count integer;
      v_guest_p char(1);
    begin

      select count(*) into v_count
      from dotlrn_guest_status where user_id = guest_p.user_id;

      if v_count > 1 then
        raise_application_error (
           -20000,
           'Guest status is multiply defined for user ' || guest_p.user_id
        );
      end if;

      if v_count = 0 then
        raise_application_error (
           -20000,
           'Guest status is not defined for user ' || guest_p.user_id
        );
      end if;

      select guest_p into v_guest_p
      from dotlrn_guest_status where user_id = guest_p.user_id;

      return v_guest_p;

    end;

    procedure set_user_non_guest (
        user_id in acs_objects.object_id%TYPE
    )
    is
      v_rel_id integer;
    begin
      for cur in (select r.rel_id from acs_rels r, 
                         membership_rels m 
                  where m.rel_id = r.rel_id 
                    and (r.rel_type = 'dotlrn_guest_rel' 
                         or r.rel_type = 'dotlrn_non_guest_rel')
                    and r.object_id_one = acs.magic_object_id('registered_users')
                    and r.object_id_two = set_user_non_guest.user_id)
      loop 
        membership_rel.del(cur.rel_id);
      end loop;

      v_rel_id := membership_rel.new(
        rel_type => 'dotlrn_non_guest_rel',
        object_id_one => acs.magic_object_id('registered_users'),
        object_id_two => set_user_non_guest.user_id,
        member_state => 'approved'
      );

    end;

    procedure set_user_guest (
        user_id in acs_objects.object_id%TYPE
    )
    is
      v_rel_id integer;
    begin
      for cur in (select r.rel_id from acs_rels r,
                  membership_rels m
                  where m.rel_id = r.rel_id
                    and (r.rel_type = 'dotlrn_guest_rel'
                         or r.rel_type = 'dotlrn_non_guest_rel')
                    and r.object_id_one = acs.magic_object_id('registered_users')
                    and r.object_id_two = set_user_guest.user_id)
      loop 
        membership_rel.del(cur.rel_id);
      end loop;

      v_rel_id := membership_rel.new(
        rel_type => 'dotlrn_guest_rel',
        object_id_one => acs.magic_object_id('registered_users'),
        object_id_two => set_user_guest.user_id,
        member_state => 'approved'
      );

    end;

    procedure grant_rd_prv_dt_to_rel (
        object_id in acs_objects.object_id%TYPE,
        rel_type in rel_segments.rel_type%TYPE
    )
    is
      v_segment_id integer;
    begin
      select segment_id into v_segment_id
      from rel_segments
      where group_id = acs.magic_object_id('registered_users')
        and rel_type = grant_rd_prv_dt_to_rel.rel_type;

      acs_permission.grant_permission(
          grant_rd_prv_dt_to_rel.object_id,v_segment_id,'read_private_data');

    end;

    procedure revoke_rd_prv_dt_from_rel (
        object_id in acs_objects.object_id%TYPE,
        rel_type in rel_segments.rel_type%TYPE
    )
    is
      v_segment_id integer;
    begin
      select segment_id into v_segment_id
      from rel_segments
      where group_id = acs.magic_object_id('registered_users')
        and rel_type = revoke_rd_prv_dt_from_rel.rel_type;

      acs_permission.revoke_permission(
          revoke_rd_prv_dt_from_rel.object_id,v_segment_id,'read_private_data');
    end;

end dotlrn_privacy;
/
show errors;

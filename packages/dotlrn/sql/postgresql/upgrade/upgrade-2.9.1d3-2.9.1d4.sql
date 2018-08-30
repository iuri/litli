--
-- procedure dotlrn_community__admin_p/2
--
CREATE OR REPLACE FUNCTION dotlrn_community__admin_p(
   p_community_id integer,
   p_party_id integer
) RETURNS boolean AS $$
DECLARE
        r_rv				  boolean;
BEGIN
	-- THIS NEEDS TO BE CHECKED!
	-- chak, 2002-07-01
	select CASE
		WHEN acs_permission__permission_p(p_community_id, p_party_id, 'dotlrn_admin_community') is false
		THEN acs_permission__permission_p(p_community_id,p_party_id,'admin')
		ELSE true
	     END
	   into r_rv
           from dual;

	return r_rv;
END;
$$ LANGUAGE plpgsql;


--
-- procedure dotlrn_community__member_p/2
--
CREATE OR REPLACE FUNCTION dotlrn_community__member_p(
   p_community_id integer,
   p_party_id integer
) RETURNS boolean AS $$
DECLARE
        v_member_p			  boolean;
BEGIN
       select (count(*) = 0)
        into v_member_p
        from dual
        where exists (select 1
                      from dotlrn_member_rels_approved
                      where dotlrn_member_rels_approved.user_id = dotlrn_community.member_p.party_id
                      and dotlrn_member_rels_approved.community_id = dotlrn_community.member_p.community_id);

        return v_member_p;

END;
$$ LANGUAGE plpgsql;

--
-- procedure dotlrn_community__has_subcomm_p/1
--
DROP FUNCTION IF EXISTS dotlrn_community__has_subcomm_p(integer);
CREATE OR REPLACE FUNCTION dotlrn_community__has_subcomm_p(
   p_community_id integer
) RETURNS boolean AS $$
DECLARE
	r_rv boolean;
BEGIN
	select (count(*) = 0)
	  into r_rv
	  from dotlrn_communities_all 
         where dotlrn_communities_all.community_id = p_community_id;
	 
	 return r_rv;
END;
$$ LANGUAGE plpgsql;


DROP VIEW IF EXISTS dotlrn_guest_status;

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

--
-- procedure dotlrn_privacy__guest_p/1
--
DROP FUNCTION dotlrn_privacy__guest_p(integer);
CREATE OR REPLACE FUNCTION dotlrn_privacy__guest_p(
   p_user_id integer
) RETURNS boolean AS $$
DECLARE
  v_count integer;
  v_guest_p boolean;
BEGIN
  select count(*) into v_count from dotlrn_guest_status where user_id = p_user_id;
  if v_count > 1 then
    raise EXCEPTION '-20000: Guest status is multiply defined for user %', p_user_id;
  end if;
  if v_count = 0 then
    raise EXCEPTION '-20000: Guest status is not defined for user %', p_user_id;
  end if;
  select guest_p into v_guest_p from dotlrn_guest_status where user_id = p_user_id;
  return v_guest_p;
END;
$$ LANGUAGE plpgsql;


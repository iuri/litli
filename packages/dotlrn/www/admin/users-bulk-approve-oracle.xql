<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="count_pending_users">
        <querytext>
    select count(*)
    from (select r.object_id_two
	  from acs_rels r, membership_rels mr
	  where r.object_id_one = (select acs.magic_object_id('registered_users') from dual)
	  and r.rel_id = mr.rel_id
	  and mr.member_state not in ('banned','deleted','rejected')
	  and r.object_id_two not in (                  
				      select r2.object_id_two
				      from acs_rels r2, dotlrn_user_types dut
				      where r2.object_id_one = dut.group_id))
        </querytext>
    </fullquery>

    <fullquery name="get_all_pending_users">
        <querytext>
	select distinct r.object_id_two
	from acs_rels r, membership_rels mr
	where r.object_id_one = (select acs.magic_object_id('registered_users') from dual)
	and r.rel_id = mr.rel_id
	and mr.member_state not in ('banned','deleted','rejected')
	and r.object_id_two not in (                  
				    select r2.object_id_two
				    from acs_rels r2, dotlrn_user_types dut
				    where r2.object_id_one = dut.group_id)
        </querytext>
    </fullquery>

</queryset>

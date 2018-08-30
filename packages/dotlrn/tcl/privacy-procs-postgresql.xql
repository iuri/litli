<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="dotlrn_privacy::set_user_guest_p.set_user_non_guest">
        <querytext>
	    select dotlrn_privacy__set_user_non_guest(:user_id)
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_privacy::set_user_guest_p.set_user_guest">
        <querytext>
	    select dotlrn_privacy__set_user_guest(:user_id)
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_privacy::set_read_private_data_for_rel.set_read_private_data_for_rel">
        <querytext>
	    select dotlrn_privacy__${db_proc}(:object_id,:rel_type)
        </querytext>
    </fullquery>

    <fullquery name="dotlrn_privacy::guests_can_view_private_data_p.guests_granted_read_private_data_p">
        <querytext>
            select case when count(1) = 0 then 0 else 1 end
        from acs_permissions p,
             rel_segments r
        where p.grantee_id = r.segment_id
          and p.privilege = 'read_private_data'
          and r.group_id = acs__magic_object_id('registered_users')
          and r.rel_type = 'dotlrn_guest_rel'
          and p.object_id = :object_id
        </querytext>
    </fullquery>

</queryset>

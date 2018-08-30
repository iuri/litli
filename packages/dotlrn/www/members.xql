<?xml version="1.0"?>

<queryset>
    <fullquery name="select_current_members">
        <querytext>
            select dotlrn_member_rels_approved.rel_id,
                   dotlrn_member_rels_approved.rel_type,
                   dotlrn_member_rels_approved.role,
                   dotlrn_member_rels_approved.user_id,
                   acs_users_all.first_names,
                   acs_users_all.last_name,
                   acs_users_all.email,
                   (select count(*) from acs_rels where rel_type = 'user_portrait_rel' and object_id_one = dotlrn_member_rels_approved.user_id) as portrait_p
            from acs_users_all,
                 dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.community_id = :community_id
            and dotlrn_member_rels_approved.user_id = acs_users_all.user_id
	    $orderby
        </querytext>
    </fullquery>

  <fullquery name="select_pending_users">
        <querytext>
	select dotlrn_users.*,
	       dotlrn_member_rels_full.rel_type,
	       dotlrn_member_rels_full.role
	from dotlrn_users,
	       dotlrn_member_rels_full
	where dotlrn_users.user_id = dotlrn_member_rels_full.user_id
	      and dotlrn_member_rels_full.community_id = :community_id
	      and dotlrn_member_rels_full.member_state = 'needs approval'
        </querytext>
    </fullquery>

  <fullquery name="select_members">
        <querytext>
	select user_id as member_id 
	from dotlrn_member_rels_approved 
	where community_id = :community_id and 
	rel_type = :reltype and 
	user_id <> :my_user_id
        </querytext>
    </fullquery>
</queryset>

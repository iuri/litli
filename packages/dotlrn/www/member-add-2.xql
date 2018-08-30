<?xml version="1.0"?>

<queryset>

    <fullquery name="select_role">
        <querytext>
	    select dotlrn_member_rels_approved.rel_type
            from dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.community_id = :community_id
            and dotlrn_member_rels_approved.user_id = :user_id
        </querytext>
    </fullquery>

</queryset>




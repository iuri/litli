<?xml version="1.0"?>

<queryset>
  <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_my_communities">
        <querytext>
            select dotlrn_communities.community_id,
                   dotlrn_communities.community_type,
                   dotlrn_communities.pretty_name,
                   dotlrn_communities.description,
                   dotlrn_communities.package_id,
                   dotlrn_community__url(dotlrn_communities.community_id) as url,
                   dotlrn_member_rels_approved.rel_type,
                   dotlrn_member_rels_approved.role,
                   '' as role_pretty_name,
                   CASE 
                      WHEN
                         acs_permission.permission_p(dotlrn_communities.community_id, :user_id, 'admin')
                      THEN 1
                      ELSE 0
                   END as admin_p
            from dotlrn_communities,
                 dotlrn_member_rels_approved
            where dotlrn_member_rels_approved.user_id = :user_id
            and dotlrn_communities.community_id = dotlrn_member_rels_approved.community_id
            and dotlrn_communities.community_type != 'dotlrn_community'
            order by dotlrn_communities.pretty_name
        </querytext>
    </fullquery>

</queryset>

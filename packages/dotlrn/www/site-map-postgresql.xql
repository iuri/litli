<?xml version="1.0"?>   

<queryset>
  <rdbms>
    <type>postgresql</type>
    <version>7.1</version>
  </rdbms>

  <fullquery name="select_courses">
    <querytext>
      select dotlrn_communities_all.community_id, 
             dotlrn_communities_all.pretty_name,
             dotlrn_community__url(dotlrn_communities_all.community_id) as url,
             portal_pages.pretty_name as page_name,
             portal_pages.sort_key
      from dotlrn_member_rels_approved, dotlrn_communities_all 
      inner join portal_pages on (dotlrn_communities_all.portal_id = portal_pages.portal_id)
      where dotlrn_communities_all.community_id = dotlrn_member_rels_approved.community_id
        and dotlrn_member_rels_approved.user_id = :user_id
        and dotlrn_communities_all.community_type not in ('dotlrn_community', 'dotlrn_club', 'dotlrn_pers_community')
        and archived_p = 'f'
      order by dotlrn_communities_all.pretty_name, portal_pages.sort_key
    </querytext>
  </fullquery>

  <fullquery name="select_communities">
    <querytext>
      select dotlrn_communities_all.community_id, 
             dotlrn_communities_all.pretty_name,
             dotlrn_community__url(dotlrn_communities_all.community_id) as url,
             portal_pages.pretty_name as page_name,
             portal_pages.sort_key
      from dotlrn_member_rels_approved, dotlrn_communities_all 
      inner join portal_pages on (dotlrn_communities_all.portal_id = portal_pages.portal_id)
      where dotlrn_communities_all.community_id = dotlrn_member_rels_approved.community_id
        and dotlrn_member_rels_approved.user_id = :user_id
        and dotlrn_communities_all.community_type = 'dotlrn_club'
        and archived_p = 'f'
      order by dotlrn_communities_all.pretty_name, portal_pages.sort_key
    </querytext>
  </fullquery>

</queryset>

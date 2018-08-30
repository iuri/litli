<?xml version="1.0"?>

<queryset>
  <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_club">
        <querytext>
            select dotlrn_communities.pretty_name,
                   dotlrn_communities.description,
                   dotlrn_community__url(:club_id) as url
            from dotlrn_communities
            where dotlrn_communities.community_id = :club_id
        </querytext>
    </fullquery>

</queryset>

<?xml version="1.0"?>

<queryset>
  <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="select_subgroups">
<querytext>
select community_id, community_key, pretty_name, dotlrn_community.url(community_id) as community_url from dotlrn_communities where parent_community_id= :community_id order by pretty_name
</querytext>
</fullquery>

</queryset>

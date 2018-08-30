<?xml version="1.0"?>

<queryset>

    <fullquery name="select_community_info">
        <querytext>
            select pretty_name 
 	    from dotlrn_communities
	    where community_id = :source_community_id
        </querytext>
    </fullquery>

</queryset>

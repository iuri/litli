<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="select_community_types">
        <querytext>
            select dotlrn_community_types.community_type,
                   dotlrn_community_types.pretty_name,
                   dotlrn_community_types.description,
                   (select site_node.url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = dotlrn_community_types.package_id) as url
            from dotlrn_community_types
            where dotlrn_community_types.supertype = :community_type
        </querytext>
    </fullquery>

</queryset>

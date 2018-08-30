<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="select_forums">
        <querytext>
	    select forums_forums.package_id,
            acs_object.name(apm_package.parent_id(forums_forums.package_id)) as parent_name,
            (select site_node.url(site_nodes.node_id)
            from site_nodes
            where site_nodes.object_id = forums_forums.package_id) as url,
            forums_forums.forum_id,
            forums_forums.name,
	    $unread_or_new_query
            from forums_forums_enabled forums_forums,
            acs_objects
            where acs_objects.object_id = forums_forums.forum_id and 
            forums_forums.package_id in ([join $list_of_package_ids ,])
            $private_data_restriction
             order by parent_name,
             forums_forums.name
        </querytext>
    </fullquery>

    <partialquery name="restrict_by_private_data_priv">
        <querytext>
            and exists (
                select 1
                from acs_object_party_privilege_map ppm
                where ppm.object_id = forums_forums.package_id
                  and ppm.party_id = :user_id
                  and ppm.privilege = 'read_private_data'
            )
        </querytext>
    </partialquery>

</queryset>

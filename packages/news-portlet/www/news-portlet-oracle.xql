<?xml version="1.0"?>

<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="select_news_items">
        <querytext>
            select news_items_approved.package_id,
                   acs_object.name(apm_package.parent_id(news_items_approved.package_id)) as parent_name,
                   (select site_node.url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = news_items_approved.package_id) as url,
                   news_items_approved.item_id,
                   news_items_approved.publish_title,
                   to_char(news_items_approved.publish_date, 'YYYY-MM-DD HH24:MI:SS') as publish_date_ansi,
                   item_creator,
                   creation_user
                   $content_column
            from news_items_approved
            where news_items_approved.publish_date < sysdate
            and (news_items_approved.archive_date >= sysdate or news_items_approved.archive_date is null)
            and news_items_approved.package_id in ([join $list_of_package_ids ", "])
            order by package_id,
                     parent_name,
                     news_items_approved.publish_date desc,
                     news_items_approved.publish_title			

        </querytext>
    </fullquery>

    <fullquery name="select_subgroup_package_ids">
        <querytext>
            select package_id
             from apm_packages p,
                  (select object_id,
                   parent_id
                   from site_nodes n
                   where (object_id is null
                     or acs_permission.permission_p(object_id, :user_id, 'read') = 't')               
                   start with node_id = :root_id
                   connect by prior node_id = parent_id)  site_map
             where site_map.object_id = p.package_id (+)
               and package_key = 'news'
        </querytext>
    </fullquery>

</queryset>

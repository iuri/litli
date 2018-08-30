<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="select_faqs">
        <querytext>
            select acs_objects.context_id as package_id,
                   acs_object__name(apm_package__parent_id(acs_objects.context_id)) as parent_name,
                   (select site_node__url(site_nodes.node_id)
                    from site_nodes
                    where site_nodes.object_id = acs_objects.context_id) as url,
                   faqs.faq_id,
                   faqs.faq_name
            from faqs,
                 acs_objects
            where faqs.faq_id = acs_objects.object_id
	    and faqs.disabled_p <> 't'
            and acs_objects.context_id in ([join $list_of_package_ids ", "])
            order by lower(faq_name)
        </querytext>
    </fullquery>

</queryset>

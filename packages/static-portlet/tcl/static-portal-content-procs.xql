<?xml version="1.0"?>

<queryset>

    <fullquery name="static_portal_content::clone.get_element_list">
        <querytext>
            select pem.element_id as element_id
            from portal_element_map pem, portal_pages pp
            where pp.portal_id= :portal_id
            and pp.page_id = pem.page_id
            and pem.datasource_id= :ds_id
        </querytext>
    </fullquery>

    <fullquery name="static_portal_content::clone.select_element_id">
        <querytext>
            select value
            from portal_element_parameters
            where element_id = :element_id
            and key = 'content_id'
        </querytext>
    </fullquery>

    <fullquery name="static_portal_content::update.update_content_item">
        <querytext>
            update static_portal_content set
            body = :content, pretty_name = :pretty_name, format = :format
            where content_id = :content_id
        </querytext>
    </fullquery>

    <fullquery name="static_portal_content::get_pretty_name.select">
        <querytext>
            select pretty_name
            from static_portal_content
            where content_id = :content_id
        </querytext>
    </fullquery>

    <fullquery name="static_portal_content::get_package_id.select">
        <querytext>
            select package_id
            from static_portal_content
            where content_id = :content_id
        </querytext>
    </fullquery>

    <fullquery name="static_portal_content::get_content.get_content.select">
        <querytext>
            select body
            from static_portal_content
            where content_id = :content_id
        </querytext>
    </fullquery>

    <fullquery name="static_portal_content::get_content_format.get_content_format.select">
        <querytext>
            select format
            from static_portal_content
            where content_id = :content_id
        </querytext>
    </fullquery>

</queryset>

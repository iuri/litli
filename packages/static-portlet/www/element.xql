<?xml version="1.0"?>

<queryset>

    <fullquery name="get_content_element">
        <querytext>
            select body, pretty_name, format
            from static_portal_content
            where content_id = :content_id
        </querytext>
    </fullquery>

</queryset>

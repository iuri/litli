<?xml version="1.0"?>

<queryset>
    <rdbms><type>postgresql</type><version>7.1</version></rdbms>

    <fullquery name="static_portal_content::new.new_content_item">
        <querytext>
            select static_portal_content_item__new(
                :package_id,
                :pretty_name,
                :content,
		:format
            );
        </querytext>
    </fullquery>

</queryset>

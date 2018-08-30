<?xml version="1.0"?>

<queryset>

    <fullquery name="get_item_id">
        <querytext>
            select item_id 
            from cr_items 
            where parent_id = :parent_id
              and name = :logo_name
        </querytext>
    </fullquery>

    <fullquery name="get_root_folder">
        <querytext>
            select c_root_folder_id 
            from content_item_globals
        </querytext>
    </fullquery>

</queryset>

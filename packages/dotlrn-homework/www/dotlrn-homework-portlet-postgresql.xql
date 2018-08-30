<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.2</version></rdbms>

    <fullquery name="select_default_min_level">
        <querytext>
            select tree_level(tree_sortkey) - 1 as min_level
            from cr_items where item_id = :folder_id
	</querytext>
    </fullquery>

</queryset>

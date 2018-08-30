<?xml version="1.0"?>

<queryset>
    <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="delete_cr_item">
        <querytext>
            begin
                content_item.del(:item_id);
            end;
        </querytext>
    </fullquery>

</queryset>

<?xml version="1.0"?>
<queryset>

<fullquery name="check_photo_id">      
      <querytext>
      select count(*) from cr_items where item_id = :photo_id
      </querytext>
</fullquery>

</queryset>

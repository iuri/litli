<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="unmap_photo">      
      <querytext>

    delete from pa_collection_photo_map 
    where collection_id = :collection_id 
      and photo_id = :photo_id 
      and acs_permission.permission_p(:collection_id, :user_id, 'write') = 't'

      </querytext>
</fullquery>
 
</queryset>

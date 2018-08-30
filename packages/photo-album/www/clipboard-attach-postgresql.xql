<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="new_collection">      
      <querytext>

select pa_collection__new(:collection_id, :user_id, :title, now(), :user_id, :peeraddr, :context)

      </querytext>
</fullquery>

<fullquery name="map_photo">      
      <querytext>

    insert into pa_collection_photo_map 
    (collection_id, photo_id) 
    select :collection_id, :photo_id where 
    acs_permission__permission_p(:collection_id, :user_id, 'write') = 't'

      </querytext>
</fullquery>
 
</queryset>

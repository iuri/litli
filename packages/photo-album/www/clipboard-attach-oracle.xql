<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="new_collection">      
      <querytext>

    begin
        :1 := pa_collection.new (
            p_collection_id => :collection_id, 
            p_owner_id      => :user_id, 
            p_title         => :title, 
            p_creation_date => sysdate, 
            p_creation_user => :user_id, 
            p_creation_ip   => :peeraddr, 
            p_context_id    => :context
        );
    end;

      </querytext>
</fullquery>

<fullquery name="map_photo">      
      <querytext>

    insert into pa_collection_photo_map 
    (collection_id, photo_id) 
    select :collection_id, :photo_id from dual where 
    acs_permission.permission_p(:collection_id, :user_id, 'write') = 't'

      </querytext>
</fullquery>

 
</queryset>

<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="new_collection">      
      <querytext>
	begin
	:1 := pa_collection.new(
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

 
</queryset>

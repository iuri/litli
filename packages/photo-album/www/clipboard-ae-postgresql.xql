<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="new_collection">      
      <querytext>

select pa_collection__new(:collection_id, :user_id, :title, now(), :user_id, :peeraddr, :context)

      </querytext>
</fullquery>

 
</queryset>

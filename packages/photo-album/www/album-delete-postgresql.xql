<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="album_delete">      
      <querytext>
      select pa_album__delete(:album_id)
      </querytext>
</fullquery>

 
<fullquery name="album_name">      
      <querytext>
      select content_item__get_title(:album_id,'t') 
      </querytext>
</fullquery>

 
</queryset>

<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="photo_iconic">      
      <querytext>

    UPDATE pa_albums 
       SET iconic = :photo_id 
     WHERE pa_album_id = content_item__get_live_revision(:album_id)

      </querytext>
</fullquery>
 
</queryset>

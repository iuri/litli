<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="photo_iconic">      
      <querytext>

    UPDATE pa_albums 
       SET iconic = :photo_id 
     WHERE pa_album_id = content_item.get_live_revision(:album_id)

      </querytext>
</fullquery>
 
</queryset>

<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="drop_image">      
      <querytext>
	select pa_photo__delete (:photo_id)
     </querytext>
</fullquery>

 
</queryset>

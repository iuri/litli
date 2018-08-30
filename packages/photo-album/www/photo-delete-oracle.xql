<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="drop_pa_image">      
      <querytext>
      
	begin
	pa_photo.del (:photo_id);
	end;
    
      </querytext>
</fullquery>

 
</queryset>

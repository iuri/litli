<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_next_object_id">      
      <querytext>
      select acs_object_id_seq.nextval 
      </querytext>
</fullquery>

 
<fullquery name="update_photo_attributes">      
      <querytext>
	    select content_revision__new (
	      :new_title, -- title => 
  	      :new_desc, -- description 
      	      current_timestamp, -- publish_date
      	      null, -- mime_type
      	      null, -- nls_language
              null, -- locale
	      :photo_id, -- item_id 
	      :revision_id, -- revision_id 
	      current_timestamp, -- creation_date 
	      :user_id, -- creation_user
	      :peeraddr -- creation_ip 
	    )
	      </querytext>
</fullquery>


<fullquery name="update_photo_user_filename">      
      <querytext>
	 UPDATE pa_photos
 	    SET user_filename = prev.user_filename,
                camera_model = prev.camera_model,
                date_taken   = prev.date_taken,
                flash        = prev.flash, 
                aperture     = prev.aperture,
                metering     = prev.metering,   
                focal_length = prev.focal_length,
                exposure_time  = prev.exposure_time,
                focus_distance = prev.focus_distance,
                sha256         = prev.sha256,
                photographer   = prev.photographer
           FROM (
             SELECT user_filename,camera_model,date_taken,flash, 
                    aperture,metering,focal_length,exposure_time,
                    focus_distance,sha256,photographer
               FROM pa_photos prev
              WHERE prev.pa_photo_id = :previous_revision
              ) prev
           WHERE pa_photo_id = :revision_id
      </querytext>
</fullquery>

<fullquery name="set_live_revision">      
      <querytext>
	    select content_item__set_live_revision (:revision_id)
      </querytext>
</fullquery>

 
</queryset>

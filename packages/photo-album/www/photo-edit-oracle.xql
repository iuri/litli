<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_next_object_id">      
      <querytext>
      select acs_object_id_seq.nextval from dual
      </querytext>
</fullquery>

 
<fullquery name="update_photo_attributes">      
      <querytext>
      
	    declare
	      dummy integer;
	    begin

	    dummy := content_revision.new (
	      title => :new_title,
  	      description => :new_desc,
	      item_id => :photo_id,
	      revision_id => :revision_id,
	      creation_date => sysdate,
	      creation_user => :user_id,
	      creation_ip => :peeraddr
	    );
	    end;
	
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
            begin	
	    content_item.set_live_revision (
	      revision_id => :revision_id
            );

	    end;
      </querytext>
</fullquery>

 
</queryset>

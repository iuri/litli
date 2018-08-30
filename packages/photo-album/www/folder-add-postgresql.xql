<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="new_folder">      
      <querytext>
	    select content_folder__new (
	      :name, -- name 
              :label, -- label
              :description, -- description 
              :parent_id, -- parent_id 
	      null, -- context_id
              :folder_id, -- folder_id    
              current_timestamp, -- creation_date 
              :user_id, -- creation_user 
              :peeraddr -- creation_ip   
	    )
      </querytext>
</fullquery>

 
</queryset>

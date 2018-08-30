<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="new_album">      
      <querytext>
      select pa_album__new (
	      :name, -- name          
	      :album_id, -- album_id       
	      :parent_id, -- parent_id	     
      	      't', -- is_live	     
	      :user_id, -- creation_user  
	      :peeraddr, -- creation_ip    
	      :title, -- title	     
	      :description, -- description    
	      :story, -- story	    
              :photographer, -- photographer
	      null, -- revision_id
	      current_timestamp, -- creation_date
	      null, -- locale
	      null, -- context_id
	      current_timestamp, -- publish_date
	      null -- nls_language
	    );
      </querytext>
</fullquery>

 
</queryset>

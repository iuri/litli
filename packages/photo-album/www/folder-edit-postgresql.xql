<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="edit_folder">      
      <querytext>
      select content_folder__edit_name (
            :folder_id, -- folder_id 
	    null, -- name
            :label, -- label 
            :description -- description  
      )
      </querytext>
</fullquery>

 
</queryset>

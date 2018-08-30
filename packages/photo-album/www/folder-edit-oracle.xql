<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="edit_folder">      
      <querytext>
      
	    begin
	    content_folder.edit_name (
            folder_id  => :folder_id,
            label => :label,
            description  => :description
	    );
	    end;
	
      </querytext>
</fullquery>

 
</queryset>

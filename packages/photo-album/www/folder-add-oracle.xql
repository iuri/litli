<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="new_folder">      
      <querytext>
      
	    declare
	      fldr_id    integer;
	    begin
	    
	    fldr_id :=content_folder.new (
	      name          => :name,
              label         => :label,
              description   => :description,
              parent_id     => :parent_id,
              folder_id     => :folder_id,
              creation_date => sysdate,
              creation_user => :user_id,
              creation_ip   => :peeraddr
	    );

	    -- content_folder.new automatically registers 
	    -- the content_types of the parent to the new folder
	
	    end;
	
      </querytext>
</fullquery>

 
</queryset>

<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="file_move">      
      <querytext>
      
	begin
    		file_storage.move_file (
    			file_id => :file_id,
    			target_folder_id => :parent_id,
                        creation_user => :creation_user,
                        creation_ip => :creation_ip
    			);
	end;

      </querytext>
</fullquery>

<fullquery name="correction_file_move">      
      <querytext>
      
	begin
    		file_storage.move_file (
    			file_id => :correction_file_id,
    			target_folder_id => :parent_id,
                        creation_user => :creation_user,
                        creation_ip => :creation_ip
    			);
	end;

      </querytext>
</fullquery>

 
</queryset>

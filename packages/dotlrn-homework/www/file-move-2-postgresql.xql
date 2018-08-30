<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.2</version></rdbms>

<fullquery name="file_move">      
      <querytext>
      
	select file_storage__move_file (
    			:file_id,
    			:parent_id,
                        :creation_user,
                        :creation_ip
    			);

      </querytext>
</fullquery>

<fullquery name="correction_file_move">      
      <querytext>
      
    	select file_storage__move_file (
    			:correction_file_id,
    			:parent_id,
                        :creation_user,
                        :creation_ip
    			);

      </querytext>
</fullquery>

 
</queryset>

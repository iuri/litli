<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="correction_file_copy">      
      <querytext>

	select file_storage__copy_file (
            	:correction_file_id, -- correction_file_id
            	:parent_id,	     -- taget_folder_id
            	:user_id,	     -- creation_user
            	:ip_address	     -- creation_ip
        	);

      </querytext>
</fullquery>

<fullquery name="file_copy">      
      <querytext>

	select file_storage__copy_file (
            	:file_id,	     -- file_id
            	:parent_id,	     -- taget_folder_id
            	:user_id,	     -- creation_user
            	:ip_address	     -- creation_ip
        	);

      </querytext>
</fullquery>

</queryset>



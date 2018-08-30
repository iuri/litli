<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.2</version></rdbms>

<fullquery name="folder_create">      
      <querytext>
      
    select file_storage__new_folder (
        :name,
        :folder_name,
        :parent_id,
        :user_id,
        :creation_ip
    );

      </querytext>
</fullquery>

</queryset>

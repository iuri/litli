<?xml version="1.0"?>

<queryset>
<rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="dotlrn_homework::new.check_duplicate">      
   <querytext>
      
     select 1
     where exists (select name
                   from cr_items
                   where parent_id = :parent_folder_id
                     and name = :encoded_filename)

   </querytext>
</fullquery>

 
<fullquery name="dotlrn_homework::new.new_lob_file">      
   <querytext>

       select file_storage__new_file (
               :encoded_filename,
               :parent_folder_id,
               :user_id,
               :creation_ip,
               :indb_p,
               :file_id,
	       :package_id
       );
            
   </querytext>
</fullquery>

 
<fullquery name="dotlrn_homework::new.new_version">      
   <querytext>

       select file_storage__new_version (
               :title,
               :description,
               :mime_type,
               :file_id,
               :user_id,
               :creation_ip
        );
     
   </querytext>
</fullquery>

 
<fullquery name="dotlrn_homework::new.lob_content">      
   <querytext>

     update cr_revisions
     set lob = [set __lob_id [db_string get_lob_id "select empty_lob()"]]
     where revision_id = :revision_id

            
   </querytext>
</fullquery>

 
<fullquery name="dotlrn_homework::new.lob_size">      
   <querytext>
      
     update cr_revisions
     set content_length = lob_length(lob) 
     where revision_id = :revision_id
            
   </querytext>
</fullquery>

 
<fullquery name="dotlrn_homework::add_correction_relation.relate">      
   <querytext>

       select content_item__relate(
               :homework_file_id,
               :correction_file_id,
               'homework_correction',
               null,
               'cr_item_rel'
       );
        
   </querytext>
</fullquery>

 
</queryset>

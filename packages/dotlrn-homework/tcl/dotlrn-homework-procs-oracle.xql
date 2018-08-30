<?xml version="1.0"?>

<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="dotlrn_homework::new.check_duplicate">      
   <querytext>
     
     select 1
     from dual
     where exists (select name
                   from cr_items
                   where parent_id = :parent_folder_id
                     and name = :encoded_filename)
   </querytext>
</fullquery>

 
<fullquery name="dotlrn_homework::new.new_lob_file">      
   <querytext>
      
     begin
       :1 := file_storage.new_file (
               item_id => :file_id,
               title => :encoded_filename,
               folder_id => :parent_folder_id,
               creation_user => :user_id,
               creation_ip => :creation_ip,
	       package_id => :package_id,
               indb_p => :indb_p
             );
     end;
            
   </querytext>
</fullquery>

 
<fullquery name="dotlrn_homework::new.new_version">      
   <querytext>
      
     begin
       :1 := file_storage.new_version (
               filename => :title,
               description => :description,
               mime_type => :mime_type,
               item_id => :file_id,
               creation_user => :user_id,
               creation_ip => :creation_ip
             );
     end;
   </querytext>
</fullquery>

 
<fullquery name="dotlrn_homework::new.lob_content">      
   <querytext>
      
     update cr_revisions
     set content = empty_blob()
     where revision_id = :revision_id
     returning content into :1
            
   </querytext>
</fullquery>

 
<fullquery name="dotlrn_homework::new.lob_size">      
   <querytext>
      
     update cr_revisions
     set content_length = dbms_lob.getlength(content) 
     where revision_id = :revision_id
            
   </querytext>
</fullquery>

 
<fullquery name="dotlrn_homework::add_correction_relation.relate">      
   <querytext>
      
     begin
       :1 := content_item.relate(
               item_id => :homework_file_id,
               object_id => :correction_file_id,
               relation_tag => 'homework_correction'
             );
     end;
        
   </querytext>
</fullquery>

 
</queryset>

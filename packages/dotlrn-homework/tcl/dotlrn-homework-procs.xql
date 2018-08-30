<?xml version="1.0"?>
<queryset>

<fullquery name="dotlrn_homework::new.get_owner_id">      
   <querytext>
     select creation_user as homework_user_id from acs_objects where object_id = :homework_file_id
   </querytext>
</fullquery>

 
<fullquery name="dotlrn_homework::new.live_version_title">      
   <querytext>

     select r.title
     from cr_revisions r, cr_items i
     where i.item_id = :file_id
       and i.content_type = 'file_storage_object'
       and r.revision_id = i.live_revision
            
   </querytext>
</fullquery>
 
<fullquery name="dotlrn_homework::new.fs_content_size">      
   <querytext>
      
     update cr_revisions
     set content = :tmp_filename,
       content_length = :tmp_size
     where revision_id = :revision_id
            
   </querytext>
</fullquery>

 
<fullquery name="dotlrn_homework::send_homework_alerts.get_alert_info">      
   <querytext>
      
     select f.name, folder.label as folder_name,
       u.first_names || ' ' || u.last_name as student_name
     from cr_items f, cr_folders folder, cc_users u, acs_objects o
     where f.item_id = :file_id
       and o.object_id = :file_id
       and folder.folder_id = :folder_id
       and u.user_id = o.creation_user

   </querytext>
</fullquery>

 
<fullquery name="dotlrn_homework::send_correction_alerts.get_alert_info">      
   <querytext>
      
     select f.name, folder.label as folder_name,
       u.first_names || ' ' || u.last_name as admin_name
     from cr_items f, cr_folders folder, cc_users u
     where item_id = :homework_file_id
       and folder.folder_id = :folder_id
       and u.user_id = :user_id

   </querytext>
</fullquery>
 
</queryset>

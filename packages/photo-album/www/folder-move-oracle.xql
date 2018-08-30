<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_folder_info">      
      <querytext>
      select content_folder.get_label(:folder_id) as title from dual
      </querytext>
</fullquery>

 
<fullquery name="get_folders">      
      <querytext>
      select padded_name, folder_id from (select
    ci.item_id,
    lpad ('&nbsp;&nbsp;&nbsp;',((level - 1) * 6),'&nbsp;&nbsp;&nbsp;') || content_folder.get_label(ci.item_id) as padded_name,
    ci.item_id as folder_id
    from cr_items ci
    where ci.content_type = 'content_folder'
    start with ci.item_id = :root_folder_id
    connect by prior ci.item_id = ci.parent_id
      and ci.item_id != :folder_id
    )
    where acs_permission.permission_p(item_id, :user_id, 'pa_create_folder') = 't'
    
      </querytext>
</fullquery>

 
<fullquery name="folder_move">      
      <querytext>
      
	begin 
	content_folder.move (
	  folder_id           => :folder_id,
	  target_folder_id  => :new_folder_id
	);
	end;
	
      </querytext>
</fullquery>

 
</queryset>

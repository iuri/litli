<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_folder_info">      
      <querytext>
      select content_folder__get_label(:folder_id) as title 
      </querytext>
</fullquery>

 
<fullquery name="get_folders">      
      <querytext>
    select
    repeat('&nbsp;&nbsp;&nbsp;',(tree_level(ci.tree_sortkey) - tree_level(i2.tree_sortkey) - 1) * 6) || content_folder__get_label(ci.item_id) as padded_name,
    ci.item_id as folder_id
    from cr_items ci, cr_items i2
    where ci.content_type = 'content_folder'
      and ci.item_id <> :folder_id  
      and ci.tree_sortkey between i2.tree_sortkey and tree_right(i2.tree_sortkey)
      and i2.item_id = :root_folder_id
      and acs_permission__permission_p(ci.item_id, :user_id, 'pa_create_folder') = 't'
    order by ci.tree_sortkey    
    
    
      </querytext>
</fullquery>

 
<fullquery name="folder_move">      
      <querytext>
	select content_folder__move (
	  :folder_id, -- folder_id           
	  :new_folder_id -- target_folder_id  
	)
	
      </querytext>
</fullquery>

 
</queryset>

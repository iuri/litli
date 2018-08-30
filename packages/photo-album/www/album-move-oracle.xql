<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="get_folders">      
      <querytext>
      select 
    lpad ('&nbsp;&nbsp;&nbsp;',((level - 1) * 6),'&nbsp;&nbsp;&nbsp;') || content_folder.get_label(ci.item_id) as padded_name,
    ci.item_id as folder_id
    from cr_items ci
    where ci.content_type = 'content_folder'
      -- do not include the albums current folder in move to list
      and ci.item_id != :old_folder_id
      and acs_permission.permission_p(ci.item_id, :user_id, 'pa_create_album') = 't'
    connect by prior ci.item_id = ci.parent_id
    start with ci.item_id = :root_folder_id
    
      </querytext>
</fullquery>

 
<fullquery name="album_move">      
      <querytext>
      
	begin 
	content_item.move (
	  item_id           => :album_id,
	  target_folder_id  => :new_folder_id
	);
	end;
	
      </querytext>
</fullquery>

 
</queryset>

<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="get_folders">      
      <querytext>
      select 
      repeat('&nbsp;&nbsp;&nbsp;',(tree_level(ci.tree_sortkey) - tree_level(i2.tree_sortkey) - 1) * 6) || content_folder__get_label(ci.item_id) as padded_name,
      ci.item_id as folder_id
      from cr_items ci, cr_items i2
      where ci.content_type = 'content_folder'
      -- do not include the albums current folder in move to list
        and ci.item_id <> :old_folder_id
        and acs_permission__permission_p(ci.item_id, :user_id, 'pa_create_album')
        and ci.tree_sortkey between i2.tree_sortkey and tree_right(i2.tree_sortkey)
        and i2.item_id = :root_folder_id
      order by ci.tree_sortkey    
      </querytext>
</fullquery>

 
<fullquery name="album_move">      
      <querytext>
      select content_item__move (
      :album_id, -- item_id           
      :new_folder_id -- target_folder_id  
      )
      </querytext>
</fullquery>

 
</queryset>

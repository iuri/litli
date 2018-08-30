<?xml version="1.0"?>
<queryset>

<fullquery name="get_parent_folder">      
      <querytext>
      select parent_id from cr_items where item_id = :folder_id
      </querytext>
</fullquery>

 
<fullquery name="context_update">      
      <querytext>
      
	update acs_objects
	set    context_id = :new_folder_id
	where  object_id = :folder_id
	
      </querytext>
</fullquery>

 
<fullquery name="folder_name">      
      <querytext>
      
	select name from cr_items where item_id = :folder_id
      </querytext>
</fullquery>

 
<fullquery name="duplicate_check">      
      <querytext>
      
	select count(*)
	from   cr_items
	where  name = :folder_name
	and    parent_id = :new_folder_id
      </querytext>
</fullquery>

 
</queryset>

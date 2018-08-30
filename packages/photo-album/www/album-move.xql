<?xml version="1.0"?>
<queryset>

<fullquery name="get_album_info">      
      <querytext>
      select cr.title,cr.description,pa.story
        from pa_albums pa, cr_items ci, cr_revisions cr
       where ci.live_revision = cr.revision_id
         and ci.live_revision = pa_album_id
         and ci.item_id = :album_id
      </querytext>
</fullquery>

<fullquery name="get_parent_folder">      
      <querytext>
      select parent_id from cr_items where item_id = :album_id
      </querytext>
</fullquery>

 
<fullquery name="context_update">      
      <querytext>
      
	update acs_objects
	set    context_id = :new_folder_id
	where  object_id = :album_id
	
      </querytext>
</fullquery>

 
<fullquery name="folder_name">      
      <querytext>
      
	select name from cr_items where item_id = :album_id
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

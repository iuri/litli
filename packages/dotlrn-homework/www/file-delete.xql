<?xml version="1.0"?>
<queryset>

<fullquery name="parent_id">      
      <querytext>

	select parent_id from cr_items where item_id = :file_id

      </querytext>
</fullquery>

<fullquery name="version_perms_delete">      
      <querytext>

        delete from acs_permissions
        where object_id in (select revision_id
                            from cr_revisions
                            where item_id = :file_id)

      </querytext>
</fullquery>

<fullquery name="file_name">      
      <querytext>
      
    	select name as title
    	from   cr_items
    	where  item_id = :file_id

      </querytext>
</fullquery>

</queryset>

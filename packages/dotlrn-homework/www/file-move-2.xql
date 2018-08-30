<?xml version="1.0"?>
<queryset>

<fullquery name="correction_file_id">      
      <querytext>
      
          select related_object_id as correction_file_id
          from cr_item_rels
          where item_id = :file_id
            and relation_tag = 'homework_correction'

      </querytext>
</fullquery>

<fullquery name="context_update">      
      <querytext>
      
	update acs_objects
	set    context_id = null
	where  object_id = :file_id

      </querytext>
</fullquery>

<fullquery name="correction_context_update">      
      <querytext>
      
	update acs_objects
	set    context_id = null
	where  object_id = :correction_file_id

      </querytext>
</fullquery>

 
<fullquery name="filename">      
      <querytext>
      
    	select name from cr_items where item_id = :file_id

      </querytext>
</fullquery>

 
<fullquery name="duplicate_check">      
      <querytext>
      
    	select count(*)
    	from   cr_items
    	where  name = :filename
    	and    parent_id = :parent_id

      </querytext>
</fullquery>

 
</queryset>

<?xml version="1.0"?>
<queryset>

<fullquery name="duplicate_check">      
      <querytext>
      
	  select count(*)
	  from   cr_items
	  where  (item_id = :album_id or name = :name)
	  and    parent_id = :parent_id
      </querytext>
</fullquery>

 
</queryset>

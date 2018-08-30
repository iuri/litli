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

<fullquery name="item_info">      
      <querytext>
       
    	select name, content_type from cr_items where item_id = :file_id

      </querytext>
</fullquery>

<fullquery name="get_new_homework_info">      
      <querytext>
      
	select item_id as new_homework_id
        from cr_revisions
        where revision_id = :new_homework_revision_id

      </querytext>
</fullquery>

<fullquery name="get_new_correction_info">      
      <querytext>
      
	select item_id as new_correction_id
        from cr_revisions
        where revision_id = :new_correction_revision_id

      </querytext>
</fullquery>
 
<fullquery name="update_homework_id">      
      <querytext>

        update acs_objects
        set security_inherit_p = 'f'
        where object_id = :new_homework_id

      </querytext>
</fullquery>
 
<fullquery name="update_correction_id">      
      <querytext>

        update acs_objects
        set security_inherit_p = 'f'
        where object_id = :new_correction_id

      </querytext>
</fullquery>
 
<fullquery name="update_homework_context">      
      <querytext>

        update acs_objects
        set context_id = null
        where object_id = :new_homework_id

      </querytext>
</fullquery>
 
<fullquery name="update_correction_context">      
      <querytext>

        update acs_objects
        set context_id = null
        where object_id = :new_correction_id

      </querytext>
</fullquery>

</queryset>

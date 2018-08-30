<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="file_info">      
      <querytext>
	select person.name(o.creation_user) as owner,
       		i.name,
                r.title,
       		acs_permission.permission_p(:file_id, :user_id, 'write') as write_file_p,
                acs_permission.permission_p(:file_id, :user_id, 'delete') as delete_p,
                decode(cir.item_id, null, 'f', 't') as correction_file_p
	from   acs_objects o, cr_revisions r, cr_items i, cr_item_rels cir
	where  o.object_id = :file_id
	and    i.item_id   = o.object_id
	and    r.revision_id = i.live_revision
        and    cir.related_object_id(+) = i.item_id

      </querytext>
</fullquery>

<fullquery name="version_info">      
      <querytext>

	select  i.name as version_name,
                r.title,
       		r.revision_id as version_id,
       		person.name(o.creation_user) as author,
       		r.mime_type as type,
       		to_char(o.last_modified,'YYYY-MM-DD HH24:MI') as last_modified,
       		r.description,
       		r.content_length as content_size,
                acs_permission.permission_p(r.revision_id, :user_id, 'delete') as delete_p
	from   acs_objects o, cr_revisions r, cr_items i
	where  o.object_id = r.revision_id
	and    r.item_id = i.item_id
	and    r.item_id = :file_id
	$show_versions

      </querytext>
</fullquery> 

<partialquery name="show_all_versions">      
      <querytext>

      </querytext>
</partialquery> 	

<partialquery name="show_live_version">      
      <querytext>

	and r.revision_id = i.live_revision

      </querytext>
</partialquery> 	

 
</queryset>

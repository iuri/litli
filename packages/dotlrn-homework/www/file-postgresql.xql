<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="file_info">      
      <querytext>
      
	select person__name(o.creation_user) as owner,
		i.name,
		r.title,
		acs_permission__permission_p(:file_id,:user_id,'write') as write_file_p,
		acs_permission__permission_p(:file_id,:user_id,'delete') as delete_p,
		case when cir.item_id is null then 'f' else 't' end as correction_file_p
	from   acs_objects o
           join cr_items i on (i.item_id = o.object_id)
           join cr_revisions r on (r.revision_id = i.live_revision)
           left join cr_item_rels cir on 
             (cir.item_id = o.object_id and cir.relation_tag = 'homework_correction')
	where  o.object_id = :file_id
      </querytext>
</fullquery>

<fullquery name="version_info">      
      <querytext>

	select  i.name as version_name,
                r.title,
       		r.revision_id as version_id,
       		person__name(o.creation_user) as author,
       		r.mime_type as type,
       		to_char(o.last_modified,'YYYY-MM-DD HH24:MI') as last_modified,
       		r.description,
		r.content_length as content_size,
		acs_permission__permission_p(:file_id,:user_id,'delete') as delete_p
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



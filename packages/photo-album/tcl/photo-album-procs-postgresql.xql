<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="pa_get_root_folder_internal.pa_root_folder">      
      <querytext>
      select photo_album__get_root_folder(:package_id) 
      </querytext>
</fullquery>

 
<fullquery name="pa_new_root_folder.make_new_root">      
      <querytext>
      select photo_album__new_root_folder(:package_id)  
      </querytext>
</fullquery>

 
<fullquery name="pa_new_root_folder.get_grantee_id">      
      <querytext>
      select acs__magic_object_id('$party') 
      </querytext>
</fullquery>

 
<fullquery name="pa_new_root_folder.grant_default">      
      <querytext>
      select acs_permission__grant_permission (
      :new_folder_id, -- object_id
      :grantee_id, -- grantee_id
      :privilege -- privilege
      )
      </querytext>
</fullquery>

 
<fullquery name="pa_get_folder_name.folder_name">      
      <querytext>
      select content_folder__get_label(:folder_id) 
      </querytext>
</fullquery>

 
<fullquery name="pa_context_bar_list.get_start_and_final">      
      <querytext>
      select parent_id as start_id,
      content_item__get_title(item_id,'t') as final
      from cr_items 
      where item_id = :item_id
      </querytext>
</fullquery>

 
<fullquery name="pa_context_bar_list.context_bar">      
      <querytext>
      select case
           when content_item__get_content_type(i.item_id) = 'content_folder'
           then 'index?folder_id='
           when content_item__get_content_type(i.item_id) = 'pa_album'
           then 'album?album_id='
           else 'photo?photo_id='
           end || i.item_id,
           content_item__get_title(i.item_id,'t')
      from cr_items i,
        (select tree_ancestor_keys(cr_items_get_tree_sortkey(:start_id)) as tree_sortkey) parents,
        (select tree_sortkey from cr_items where item_id = :root_folder_id) as root
      where i.tree_sortkey = parents.tree_sortkey
        and i.tree_sortkey > root.tree_sortkey
      order by i.tree_sortkey asc
      </querytext>
</fullquery>

 
<fullquery name="pa_is_type_in_package.check_is_type_in_package">      
      <querytext>
      select exists (select 1 
                     from cr_items i, cr_items i2
                     where i.item_id = :item_id
                       and i.tree_sortkey between i2.tree_sortkey and tree_right(i2.tree_sortkey)
                       and i2.item_id = :root_folder
                    )
             and content_item__get_content_type(:item_id) = :content_type

      </querytext>
</fullquery>

 
<fullquery name="pa_grant_privilege_to_creator.grant_privilege">      
      <querytext>
        
        select acs_permission__grant_permission (
        :object_id, -- object_id 
        :user_id, -- grantee_id
        :privilege -- privilege  
        )
        
      </querytext>
</fullquery>

<fullquery name="pa_load_images.new_photo">      
      <querytext>
        select pa_photo__new (
          :image_name, -- name
          :album_id, -- parent_id
          :photo_id, -- item_id
          :photo_rev_id, -- revision_id
          current_timestamp, -- creation_date
          :user_id, -- creation_user
          :peeraddr, -- creation_ip
          null, -- locale
          :album_id, -- context_id
          :client_filename, -- title
          :description, -- description
          't', -- is_live
          current_timestamp, -- publish_date
          null, -- nls_lang
          :caption, -- caption
          :story -- story
        )
    </querytext>
</fullquery>

 
<fullquery name="pa_insert_image.pa_insert_image">      
      <querytext>
        select image__new (
          :name, -- name
          :photo_id, -- parent_id
          :item_id, -- item_id
          :rev_id, -- revision_id
          :mime_type, -- mime_type
          :user_id, -- creation_user
          :peeraddr, -- creation_ip
          :relation, -- relation_tag
          :title, -- title
          :description, -- description
          :is_live, -- is_live
          current_timestamp, -- publish_date
          :path, -- path
          :size, -- file_size
          :height, -- height
          :width, -- width
          :package_id
        )    
      </querytext>
</fullquery>

<fullquery name="photo_album::photo::get.basic">      
    <querytext>
      SELECT
        ci.item_id as photo_id,
        u.user_id,
        u.first_names || ' ' || u.last_name as username,
        pp.caption,
        pp.story,
        cr.title,
        cr.description,
        ci.parent_id as album_id,
        to_char(o.creation_date,'YYYY-MM-DD HH24:MI:SS') as created_ansi,
        case when acs_permission__permission_p(ci.item_id, :user_id, 'admin') ='t' then 1 else 0 end as admin_p,
        case when acs_permission__permission_p(ci.item_id, :user_id, 'write') = 't' then 1 else 0 end as write_p,
        case when acs_permission__permission_p(ci.parent_id, :user_id, 'write') = 't' then 1 else 0 end as album_write_p,
        case when acs_permission__permission_p(ci.item_id, :user_id, 'delete') = 't' then 1 else 0 end as photo_delete_p
      FROM cr_items ci,
           cr_revisions cr,
           pa_photos pp,
           acs_objects o,
           acs_users_all u
      WHERE cr.revision_id = pp.pa_photo_id
        and ci.live_revision = cr.revision_id
        and o.object_id = ci.item_id
        and u.user_id = o.creation_user 
        and ci.item_id = :photo_id
    </querytext>
</fullquery>

<fullquery name="photo_album::photo::package_url.package_url">      
    <querytext>
        SELECT n.node_id, i1.item_id
        FROM cr_items i1, cr_items i2, pa_package_root_folder_map m, site_nodes n
        WHERE m.folder_id = i2.item_id
          and i1.item_id = coalesce((select item_id from cr_revisions where revision_id = :photo_id),:photo_id)
          and n.object_id = m.package_id
          and i1.tree_sortkey between i2.tree_sortkey and tree_right(i2.tree_sortkey)
        limit 1
    </querytext>
</fullquery>

<fullquery name="photo_album::list_albums_in_root_folder.list_albums">      
    <querytext>
        select cr.title, ci1.item_id as album_id, ci1.tree_sortkey
    from cr_revisions cr, 
         (select ci.item_id, ci.live_revision, ci.tree_sortkey from
          cr_items ci, cr_items ci2
          where ci.content_type = 'pa_album'
          and ci.tree_sortkey between ci2.tree_sortkey and tree_right(ci2.tree_sortkey)
          and ci2.item_id = :root_folder_id) ci1
    where ci1.live_revision = cr.revision_id
    and acs_permission__permission_p(cr.revision_id, :user_id, 'read')
    order by cr.title
   </querytext>
</fullquery>

</queryset>

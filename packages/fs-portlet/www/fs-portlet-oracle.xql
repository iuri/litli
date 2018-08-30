<?xml version="1.0"?>

<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

    <fullquery name="select_folders">
        <querytext>
            select file_storage.get_package_id(fs_objects.object_id) as package_id,
                   case when fs_objects.type = 'url' then
                      file_storage.get_package_id(fs_objects.parent_id)
                   else
                      file_storage.get_package_id(fs_objects.object_id) as url_package_id,
                   fs_objects.object_id,
                   fs_objects.name,
		   fs_objects.file_upload_name,
                   fs_objects.live_revision,
                   fs_objects.type,
                   fs_objects.content_size
            from fs_objects
            where fs_objects.object_id in ([join $list_of_folder_ids ", "])
            and 't' = acs_permission.permission_p(fs_objects.object_id, :user_id, 'read')
            order by fs_objects.sort_key,
                     fs_objects.name
        </querytext>
    </fullquery>

</queryset>








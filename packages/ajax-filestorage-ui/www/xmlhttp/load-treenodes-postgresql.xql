<?xml version="1.0"?>
<!DOCTYPE queryset PUBLIC "-//OpenACS//DTD XQL 1.0//EN"
"http://www.thecodemill.biz/repository/xql.dtd">

<queryset>
  
  <rdbms>
    <type>postgresql</type>
    <version>7.2</version>
  </rdbms>

  <fullquery name="treenodes">
    <querytext>
        select  fs_objects.object_id,
                fs_objects.name,
                fs_objects.title,
                fs_objects.parent_id,
                fs_objects.content_size,
                fs_objects.type,
                (select acs_permission__permission_p(fs_objects.object_id, :viewing_user_id, 'write') from dual) as write_p,
                (select acs_permission__permission_p(fs_objects.object_id, :viewing_user_id, 'delete') from dual) as delete_p,
                (select acs_permission__permission_p(fs_objects.object_id, :viewing_user_id, 'admin') from dual) as admin_p
            from fs_objects 
            where fs_objects.type in ('folder','symlink')
            and fs_objects.parent_id = :node
            and exists (select 1
                from acs_object_party_privilege_map m
                where m.object_id = fs_objects.object_id
                and m.party_id = :viewing_user_id
                and m.privilege = 'read') order by lower(fs_objects.name)
    </querytext>
  </fullquery>

</queryset>
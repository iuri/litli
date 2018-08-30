<?xml version="1.0"?>

<queryset>

    <fullquery name="callback::merge::MergePackageUser::impl::dotlrn.get_from_rel_ids">
        <querytext>	
        select rel_id, rel_type, object_id_one
	from acs_rels 
	where object_id_two = :from_user_id
	and object_id_one not in (select object_id_one 
	                          from acs_rels 
	                          where object_id_two = :to_user_id )
        </querytext>
    </fullquery>


  <fullquery name="callback::merge::MergePackageUser::impl::dotlrn.merge_dotlrn_fs">
        <querytext>	
       UPDATE cr_items 
       SET parent_id = :to_fs_root_folder
       WHERE parent_id = :from_fs_root_folder
        </querytext>
    </fullquery>

  <fullquery name="callback::merge::MergePackageUser::impl::dotlrn.merge_dotlrn_fs_shared_folder">
        <querytext>	
       UPDATE cr_items 
       SET parent_id = :to_fs_shared_folder
       WHERE parent_id = :from_fs_shared_folder
        </querytext>
    </fullquery>


  <fullquery name="callback::merge::MergePackageUser::impl::dotlrn.merge_dotlrn_fs_get_duplicates">
        <querytext>

	select item_id, name
	from cr_items
	where parent_id = :from_fs_root_folder and name in (select name
	from cr_items
	where parent_id = :to_fs_root_folder);

        </querytext>
    </fullquery>



    <fullquery name="callback::merge::MergeShowUserInfo::impl::dotlrn.get_from_rel_ids">
        <querytext>	
        select rel_id, rel_type, object_id_one
	from acs_rels 
	where object_id_two = :user_id
        </querytext>
    </fullquery>

    <fullquery name="callback::contact::person_new::impl::dotlrn_user.get_community_id">
        <querytext>	

	select c.community_id 
	  from acs_rels r, dotlrn_communities c 
         where r.object_id_one = :contact_id 
         and r.object_id_two = c.community_id

        </querytext>
    </fullquery>


</queryset>

<?xml version="1.0"?>
<queryset>

<fullquery name="callback::merge::MergePackageUser::impl::photo_album.upd_collections">      
    <querytext>
      update pa_collections
      set owner_id = :to_user_id
      where owner_id = :from_user_id
    </querytext>
</fullquery>

<fullquery name="callback::merge::MergeShowUserInfo::impl::photo_album.sel_collections">      
    <querytext>
      select collection_id, title
      from pa_collections
      where owner_id = :user_id
    </querytext>
</fullquery>

</queryset>
